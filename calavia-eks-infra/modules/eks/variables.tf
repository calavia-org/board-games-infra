variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 10
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["m5.large", "m5.xlarge", "m4.large"]
}

variable "use_spot_instances" {
  description = "Whether to use spot instances"
  type        = bool
  default     = true
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}