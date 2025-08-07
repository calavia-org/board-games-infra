# Variables for Secrets Manager Module

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "backup_region" {
  description = "AWS backup region for secret replication"
  type        = string
  default     = "us-west-2"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for Lambda functions"
  type        = list(string)
}

# PostgreSQL Configuration
variable "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
}

variable "postgres_username" {
  description = "PostgreSQL master username"
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL master password"
  type        = string
  sensitive   = true
}

variable "postgres_rotation_days" {
  description = "Number of days between PostgreSQL password rotations"
  type        = number
  default     = 30
  validation {
    condition     = var.postgres_rotation_days >= 1 && var.postgres_rotation_days <= 365
    error_message = "PostgreSQL rotation days must be between 1 and 365."
  }
}

# Redis Configuration
variable "redis_endpoint" {
  description = "Redis ElastiCache endpoint"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "redis_auth_token" {
  description = "Redis auth token"
  type        = string
  sensitive   = true
}

variable "redis_rotation_days" {
  description = "Number of days between Redis auth token rotations"
  type        = number
  default     = 30
  validation {
    condition     = var.redis_rotation_days >= 1 && var.redis_rotation_days <= 365
    error_message = "Redis rotation days must be between 1 and 365."
  }
}

# Grafana Configuration
variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "grafana_url" {
  description = "Grafana URL"
  type        = string
  default     = ""
}

variable "grafana_rotation_days" {
  description = "Number of days between Grafana password rotations"
  type        = number
  default     = 90
  validation {
    condition     = var.grafana_rotation_days >= 1 && var.grafana_rotation_days <= 365
    error_message = "Grafana rotation days must be between 1 and 365."
  }
}

# EKS Configuration
variable "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

# Service Account Token Rotation
variable "sa_token_rotation_days" {
  description = "Number of days between Service Account token rotations"
  type        = number
  default     = 90
  validation {
    condition     = var.sa_token_rotation_days >= 1 && var.sa_token_rotation_days <= 365
    error_message = "Service Account token rotation days must be between 1 and 365."
  }
}

# Logging Configuration
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch retention period."
  }
}

# Notification Configuration
# variable "enable_rotation_notifications" {
#   description = "Enable SNS notifications for rotation events"
#   type        = bool
#   default     = true
# }

# variable "notification_email" {
#   description = "Email address for rotation notifications"
#   type        = string
#   default     = ""
# }

# variable "slack_webhook_url" {
#   description = "Slack webhook URL for rotation notifications"
#   type        = string
#   default     = ""
#   sensitive   = true
# }

# Environment Configuration
# variable "environment" {
#   description = "Environment (staging, production)"
#   type        = string
#   validation {
#     condition     = contains(["staging", "production"], var.environment)
#     error_message = "Environment must be either 'staging' or 'production'."
#   }
# }

# Custom Rotation Schedules
# variable "custom_rotation_schedules" {
#   description = "Custom rotation schedules for different services"
#   type = object({
#     database_credentials   = optional(number, 30)
#     cache_credentials      = optional(number, 30)
#     admin_credentials      = optional(number, 90)
#     service_account_tokens = optional(number, 90)
#     api_keys               = optional(number, 60)
#   })
#   default = {
#     database_credentials   = 30
#     cache_credentials      = 30
#     admin_credentials      = 90
#     service_account_tokens = 90
#     api_keys               = 60
#   }
# }

# Security Configuration
# variable "enable_secret_replication" {
#   description = "Enable cross-region secret replication"
#   type        = bool
#   default     = true
# }

# variable "require_approval_for_rotation" {
#   description = "Require manual approval for critical secret rotations"
#   type        = bool
#   default     = false
# }

# variable "allowed_rotation_window" {
#   description = "Time window when rotations are allowed (24h format)"
#   type = object({
#     start_hour = number
#     end_hour   = number
#   })
#   default = {
#     start_hour = 2 # 2 AM
#     end_hour   = 4 # 4 AM
#   }
#   validation {
#     condition = (
#       var.allowed_rotation_window.start_hour >= 0 &&
#       var.allowed_rotation_window.start_hour <= 23 &&
#       var.allowed_rotation_window.end_hour >= 0 &&
#       var.allowed_rotation_window.end_hour <= 23
#     )
#     error_message = "Rotation window hours must be between 0 and 23."
#   }
# }

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Environment Configuration
variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
}

# Notification Configuration
variable "enable_rotation_notifications" {
  description = "Enable notifications for secret rotations"
  type        = bool
  default     = true
}

variable "notification_email" {
  description = "Email address for rotation notifications"
  type        = string
  default     = ""
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for notifications"
  type        = string
  default     = ""
  sensitive   = true
}
