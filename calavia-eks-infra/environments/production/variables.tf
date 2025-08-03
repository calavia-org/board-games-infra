variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
  default     = "calavia-eks-cluster"
}

variable "region" {
  description = "Región de AWS donde se desplegará el clúster"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "Zonas de disponibilidad para el clúster"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "node_instance_type" {
  description = "Tipo de instancia para los nodos del clúster"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster"
  type        = number
  default     = 2
}

variable "redis_instance_type" {
  description = "Tipo de instancia para Redis"
  type        = string
  default     = "cache.t3.micro"
}

variable "postgres_instance_type" {
  description = "Tipo de instancia para PostgreSQL"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Nombre de usuario para la base de datos"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Contraseña para la base de datos"
  type        = string
  sensitive   = true
}

variable "monitoring_retention_days" {
  description = "Días de retención para las métricas de monitoreo en producción"
  type        = number
  default     = 3
}

variable "staging_monitoring_retention_days" {
  description = "Días de retención para las métricas de monitoreo en staging"
  type        = number
  default     = 1
}

variable "enable_external_dns" {
  description = "Habilitar External DNS"
  type        = bool
  default     = true
}

variable "enable_cert_manager" {
  description = "Habilitar Cert-Manager"
  type        = bool
  default     = true
}

# ===================================
# VARIABLES DE NETWORKING
# ===================================

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Número de subnets a crear"
  type        = number
  default     = 3
}

variable "subnet_cidrs" {
  description = "CIDR blocks para las subnets"
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24", 
    "10.0.3.0/24"
  ]
}

# ===================================
# VARIABLES DE TAGGING
# ===================================

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "board-games"
}

variable "owner_email" {
  description = "Email del equipo/persona responsable"
  type        = string
  default     = "devops@calavia.org"
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Owner email debe ser una dirección de email válida."
  }
}

variable "cost_center" {
  description = "Centro de coste para facturación"
  type        = string
  default     = "CC-001-GAMING"
}

variable "business_unit" {
  description = "Unidad de negocio"
  type        = string
  default     = "Gaming-Platform"
}

variable "department" {
  description = "Departamento responsable"
  type        = string
  default     = "Engineering"
  validation {
    condition     = contains(["Engineering", "DevOps", "QA", "Security", "Finance"], var.department)
    error_message = "Department debe ser uno de: Engineering, DevOps, QA, Security, Finance."
  }
}

variable "infrastructure_version" {
  description = "Versión de la infraestructura"
  type        = string
  default     = "1.0.0"
}