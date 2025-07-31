variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks allowed to access the cluster"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to security resources"
  type        = map(string)
  default     = {}
}