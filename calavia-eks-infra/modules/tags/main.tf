# ===============================================================================
# Módulo Tags - Sistema de etiquetado estándar para Board Games Infrastructure
# ===============================================================================

# ===============================================================================
# Configuración de tags estándar
# ===============================================================================

locals {
  # Tags base que se aplican a todos los recursos
  base_tags = {
    Project     = var.project_name
    Service     = var.service
    Environment = var.environment
    Owner       = var.owner_email
    Version     = var.infrastructure_version
    ManagedBy   = "terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())

    # Tags para control de costes
    CostCenter     = var.cost_center
    BillingProject = var.billing_project
    BusinessUnit   = var.business_unit
    Department     = var.department

    # Tags para governance
    Criticality       = var.criticality
    Backup            = var.environment == "production" ? "required" : "optional"
    Monitoring        = "enabled"
    Security          = "standard"
    Compliance        = "gaming-workload"
    MaintenanceWindow = var.maintenance_window
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

output "service" {
  description = "Nombre del servicio"
  value       = var.service
}

output "project_name" {
  description = "Nombre del proyecto"
  value       = var.project_name
}

output "cost_center" {
  description = "Centro de costes para facturación"
  value       = local.base_tags.CostCenter
}

output "billing_project" {
  description = "Proyecto de facturación"
  value       = local.base_tags.BillingProject
}
