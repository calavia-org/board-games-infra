# Data source for current AWS account ID
data "aws_caller_identity" "current" {}

# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-hosted-zone"
  })
}

# IAM Role for External DNS
resource "aws_iam_role" "external_dns" {
  name = "${var.cluster_name}-external-dns"

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
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:external-dns"
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for External DNS
resource "aws_iam_policy" "external_dns" {
  name        = "${var.cluster_name}-external-dns-policy"
  description = "IAM policy for External DNS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = [
          "arn:aws:route53:::hostedzone/${aws_route53_zone.main.zone_id}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.external_dns.name
}

# Helm Release for External DNS
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.13.1"

  values = [
    <<-EOF
    provider: aws
    aws:
      region: ${var.region}
    domainFilters:
      - ${var.domain_name}
    serviceAccount:
      create: true
      name: external-dns
      annotations:
        eks.amazonaws.com/role-arn: ${aws_iam_role.external_dns.arn}
    policy: sync
    registry: txt
    txtOwnerId: ${var.cluster_name}
    EOF
  ]

  depends_on = [aws_iam_role_policy_attachment.external_dns]
}

resource "kubernetes_manifest" "external_dns_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "external-dns"
      namespace = var.namespace
    }
    spec = {
      type = "ClusterIP"
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]
      selector = {
        app = "external-dns"
      }
    }
  }
}
