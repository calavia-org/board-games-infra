variable "monitoring_enabled" {
  description = "Enable monitoring for the EKS cluster"
  type        = bool
  default     = true
}

variable "alertmanager_retention" {
  description = "Retention period for Alertmanager data"
  type        = string
  default     = "3d"
}

variable "prometheus_retention" {
  description = "Retention period for Prometheus data"
  type        = string
  default     = "3d"
}

variable "grafana_admin_password" {
  description = "Admin password for AWS Managed Grafana"
  type        = string
  sensitive   = true
}

variable "grafana_workspace_name" {
  description = "Name of the AWS Managed Grafana workspace"
  type        = string
  default     = "calavia-grafana"
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring resources"
  type        = string
  default     = "monitoring"
}