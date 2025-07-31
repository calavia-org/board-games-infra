# Data source for current AWS account ID
data "aws_caller_identity" "current" {}

# Create monitoring namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
    labels = {
      name = var.monitoring_namespace
    }
  }
}

# IAM Role for Prometheus service account
resource "aws_iam_role" "prometheus" {
  name = "${var.cluster_name}-prometheus"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.cluster_oidc_issuer_url, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${var.monitoring_namespace}:prometheus-server"
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Prometheus to access CloudWatch
resource "aws_iam_policy" "prometheus_cloudwatch" {
  name        = "${var.cluster_name}-prometheus-cloudwatch"
  description = "IAM policy for Prometheus to access CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeTags",
          "autoscaling:DescribeAutoScalingGroups",
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "prometheus_cloudwatch" {
  policy_arn = aws_iam_policy.prometheus_cloudwatch.arn
  role       = aws_iam_role.prometheus.name
}

# Helm Release for kube-prometheus-stack
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.monitoring_namespace
  version    = "55.5.0"

  create_namespace = false

  # Prometheus configuration
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "${var.retention_days}d"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = var.prometheus_storage_size
  }

  set {
    name  = "prometheus.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.prometheus.arn
  }

  # AlertManager configuration
  set {
    name  = "alertmanager.alertmanagerSpec.retention"
    value = "${var.retention_days}d"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
    value = var.alertmanager_storage_size
  }

  # Grafana configuration
  set {
    name  = "grafana.enabled"
    value = var.enable_aws_managed_grafana ? "false" : "true"
  }

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }

  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.persistence.size"
    value = var.grafana_storage_size
  }

  values = [templatefile("${path.module}/values.yaml", {
    cluster_name           = var.cluster_name
    retention_days         = var.retention_days
    slack_webhook_url      = var.slack_webhook_url
    email_notifications    = var.email_notifications
    prometheus_storage     = var.prometheus_storage_size
    alertmanager_storage   = var.alertmanager_storage_size
    grafana_storage        = var.grafana_storage_size
  })]

  depends_on = [kubernetes_namespace.monitoring]
}

# AWS Managed Grafana Workspace (if enabled)
resource "aws_grafana_workspace" "main" {
  count = var.enable_aws_managed_grafana ? 1 : 0

  name                     = "${var.cluster_name}-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["PROMETHEUS", "CLOUDWATCH"]

  tags = var.tags
}

# SNS Topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "${var.cluster_name}-monitoring-alerts"

  tags = var.tags
}

# SNS Topic Subscription for email alerts
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.email_notifications != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.email_notifications
}

# CloudWatch Log Group for EKS cluster logs
resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.retention_days

  tags = var.tags
}