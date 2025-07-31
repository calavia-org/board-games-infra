variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain monitoring data"
  type        = number
  default     = 3
}

variable "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "prometheus_storage_size" {
  description = "Storage size for Prometheus in GB"
  type        = string
  default     = "50Gi"
}

variable "grafana_storage_size" {
  description = "Storage size for Grafana in GB"
  type        = string
  default     = "10Gi"
}

variable "alertmanager_storage_size" {
  description = "Storage size for AlertManager in GB"
  type        = string
  default     = "10Gi"
}

variable "enable_aws_managed_grafana" {
  description = "Enable AWS Managed Grafana"
  type        = bool
  default     = true
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for alerts"
  type        = string
  default     = ""
  sensitive   = true
}

variable "email_notifications" {
  description = "Email address for alert notifications"
  type        = string
  default     = "admin@example.com"
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring resources"
  type        = string
  default     = "monitoring"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}