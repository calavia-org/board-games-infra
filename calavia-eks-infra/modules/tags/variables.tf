variable "environment" {
  description = "Environment name (production, staging, development, testing)"
  type        = string
  validation {
    condition     = contains(["production", "staging", "development", "testing"], var.environment)
    error_message = "Environment must be one of: production, staging, development, testing."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "board-games"
}

variable "owner_email" {
  description = "Email of the team/person responsible for the resource"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Owner email must be a valid email address."
  }
}

variable "cost_center" {
  description = "Cost center code for billing purposes"
  type        = string
  default     = "CC-001-GAMING"
}

variable "business_unit" {
  description = "Business unit name"
  type        = string
  default     = "Gaming-Platform"
}

variable "department" {
  description = "Department responsible for the resource"
  type        = string
  default     = "Engineering"
  validation {
    condition     = contains(["Engineering", "DevOps", "QA", "Security", "Finance"], var.department)
    error_message = "Department must be one of: Engineering, DevOps, QA, Security, Finance."
  }
}

variable "criticality" {
  description = "Resource criticality level"
  type        = string
  default     = "medium"
  validation {
    condition     = contains(["critical", "high", "medium", "low"], var.criticality)
    error_message = "Criticality must be one of: critical, high, medium, low."
  }
}

variable "billing_project" {
  description = "Billing project identifier"
  type        = string
  default     = "BG-2025-Q3"
}

variable "infrastructure_version" {
  description = "Version of the infrastructure code"
  type        = string
  default     = "2.0.0" # Updated for EKS 1.31 + Graviton migration
}

variable "additional_tags" {
  description = "Additional tags to merge with the standard tags"
  type        = map(string)
  default     = {}
}

variable "component" {
  description = "Component or service type"
  type        = string
  default     = ""
}

variable "service" {
  description = "Service or application name that uses this resource"
  type        = string
  default     = "board-games-platform"
  validation {
    condition     = length(var.service) > 0
    error_message = "Service name cannot be empty."
  }
}

variable "purpose" {
  description = "Purpose or description of the resource"
  type        = string
  default     = ""
}

variable "maintenance_window" {
  description = "Maintenance window in format WEEKDAY-HH:MM"
  type        = string
  default     = "Sunday-03:00"
  validation {
    condition     = can(regex("^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)-([0-1][0-9]|2[0-3]):[0-5][0-9]$", var.maintenance_window))
    error_message = "Maintenance window must be in format WEEKDAY-HH:MM (e.g., Sunday-03:00)."
  }
}

variable "expiry_date" {
  description = "Resource expiry date in YYYY-MM-DD format (for temporary resources)"
  type        = string
  default     = ""
  validation {
    condition     = var.expiry_date == "" || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", var.expiry_date))
    error_message = "Expiry date must be in YYYY-MM-DD format or empty string."
  }
}
