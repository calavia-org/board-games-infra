# ===============================================================================
# Módulo Tags - Sistema de etiquetado estándar para Board Games Infrastructure
# ===============================================================================

# Variables de entrada para configurar el etiquetado
variable "environment" {
  description = "Entorno de despliegue (staging, production)"
  type        = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be 'staging' or 'production'."
  }
}

variable "application" {
  description = "Nombre de la aplicación"
  type        = string
  default     = "board-games"
}

variable "version" {
  description = "Versión de la aplicación"
  type        = string
  default     = "v2.0.0"
}

variable "owner" {
  description = "Equipo responsable del recurso"
  type        = string
  default     = "calavia-org"
}

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  default     = "board-games-infra"
}

variable "additional_tags" {
  description = "Tags adicionales específicos del recurso"
  type        = map(string)
  default     = {}
}

# ===============================================================================
# Configuración de tags estándar
# ===============================================================================

locals {
  # Tags base que se aplican a todos los recursos
  base_tags = {
    Project     = var.project
    Application = var.application
    Environment = var.environment
    Owner       = var.owner
    Version     = var.version
    ManagedBy   = "terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())

    # Tags para control de costes
    CostCenter = var.environment == "production" ? "prod-gaming" : "dev-gaming"
    BillingTag = "${var.application}-${var.environment}"

    # Tags para governance
    Backup     = var.environment == "production" ? "required" : "optional"
    Monitoring = "enabled"
    Security   = "standard"
    Compliance = "gaming-workload"
  }

  # Combinar tags base con tags adicionales
  merged_tags = merge(local.base_tags, var.additional_tags)
}

# ===============================================================================
# Outputs - Tags listos para usar
# ===============================================================================

output "tags" {
  description = "Map completo de tags para aplicar a recursos"
  value       = local.merged_tags
}

output "environment" {
  description = "Entorno actual"
  value       = var.environment
}

output "application" {
  description = "Nombre de la aplicación"
  value       = var.application
}

output "project" {
  description = "Nombre del proyecto"
  value       = var.project
}

output "cost_center" {
  description = "Centro de costes para facturación"
  value       = local.base_tags.CostCenter
}

output "billing_tag" {
  description = "Tag de facturación"
  value       = local.base_tags.BillingTag
}
