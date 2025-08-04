variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "calavia_db"

}
variable "subnet_count" {
  description = "Número de subredes a crear - reducido para staging"
  type        = number
  default     = 2 # Reducido de 3 a 2 para ahorrar costes de NAT Gateway
}

variable "subnet_cidrs" {
  description = "Lista de CIDRs para las subredes - optimizado para staging"
  type        = list(string)
  default = [
    "10.0.0.0/20", # Subnet 1
    "10.0.16.0/20" # Subnet 2 - eliminada la tercera para reducir costes
  ]
}

# ===================================
# OPTIMIZACIÓN DE COSTES STAGING
# ===================================

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway - deshabilitado en staging para ahorrar costes"
  type        = bool
  default     = false # Deshabilitado para ahorrar ~$45/mes por NAT Gateway
}

variable "enable_multi_az" {
  description = "Habilitar Multi-AZ para RDS - deshabilitado en staging"
  type        = bool
  default     = false # Deshabilitado para ahorrar ~50% del coste de RDS
}

variable "backup_retention_period" {
  description = "Período de retención de backups - reducido para staging"
  type        = number
  default     = 1 # Mínimo de 1 día vs 7 días en producción
}

variable "storage_size" {
  description = "Tamaño de almacenamiento RDS en GB - mínimo para staging"
  type        = number
  default     = 20 # Tamaño mínimo permitido
}

variable "storage_type" {
  description = "Tipo de almacenamiento RDS - más económico para staging"
  type        = string
  default     = "gp2" # gp2 es más barato que gp3 para volúmenes pequeños
}

variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
  default     = "calavia-eks-staging"
}

variable "region" {
  description = "Región de AWS donde se desplegará el clúster"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para el clúster - reducidas para staging"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"] # Reducido de 3 a 2 AZs
}

variable "node_instance_type" {
  description = "Tipo de instancia para los nodos del clúster - usando Graviton2 ARM64 para staging"
  type        = string
  default     = "t4g.nano" # Graviton2 ARM64 - 2 vCPUs, 0.5 GB RAM (más eficiente y económico)
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster - mínimo para staging"
  type        = number
  default     = 1 # Reducido a 1 para minimizar costes
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster - limitado para staging"
  type        = number
  default     = 2 # Reducido para evitar escalado excesivo
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster - mínimo absoluto"
  type        = number
  default     = 1 # Mínimo de 1 nodo
}

variable "redis_instance_type" {
  description = "Tipo de instancia para Redis - Graviton2 ARM64 para mejor eficiencia"
  type        = string
  default     = "cache.t4g.micro" # Graviton2 ARM64 - más eficiente y económico que t2.micro
}

variable "postgres_instance_type" {
  description = "Tipo de instancia para PostgreSQL - Graviton2 ARM64 para mejor rendimiento por euro"
  type        = string
  default     = "db.t4g.micro" # Graviton2 ARM64 - mejor rendimiento por euro que t3.micro
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
  description = "Días de retención para las métricas de monitoreo"
  type        = number
  default     = 1
}

variable "external_dns_zone" {
  description = "Zona de Route 53 para gestionar DNS"
  type        = string
  default     = "calavia.example.com"
}

variable "letsencrypt_email" {
  description = "Email para el registro de Let's Encrypt"
  type        = string
  default     = "admin@example.com"
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