# Tags Module Variables
# These variables allow customization of the tagging strategy per environment

variable "environment" {
  description = "Environment name (production, staging, development, testing)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "board-games"
}

variable "owner_email" {
  description = "Email of the team/person responsible for the resource"
  type        = string
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
}

variable "criticality" {
  description = "Resource criticality level (critical, high, medium, low)"
  type        = string
  default     = "medium"
}

variable "billing_project" {
  description = "Billing project identifier"
  type        = string
  default     = "BG-2025-Q3"
}

variable "infrastructure_version" {
  description = "Version of the infrastructure code"
  type        = string
  default     = "1.0.0"
}

variable "component" {
  description = "Component or service type (database, load-balancer, cache, etc.)"
  type        = string
  default     = ""
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
}

variable "expiry_date" {
  description = "Resource expiry date in YYYY-MM-DD format (optional)"
  type        = string
  default     = ""
}

variable "additional_tags" {
  description = "Additional custom tags to merge with standard tags"
  type        = map(string)
  default     = {}
}
