output "prometheus_role_arn" {
  description = "ARN of the IAM role for Prometheus"
  value       = aws_iam_role.prometheus.arn
}

output "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_workspace_id" {
  description = "ID of the AWS Managed Grafana workspace"
  value       = var.enable_aws_managed_grafana ? aws_grafana_workspace.main[0].id : null
}

output "grafana_workspace_url" {
  description = "URL of the AWS Managed Grafana workspace"
  value       = var.enable_aws_managed_grafana ? aws_grafana_workspace.main[0].endpoint : null
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.alerts.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for EKS cluster"
  value       = aws_cloudwatch_log_group.eks_cluster.name
}

output "helm_release_status" {
  description = "Status of the kube-prometheus-stack Helm release"
  value       = helm_release.kube_prometheus_stack.status
}
