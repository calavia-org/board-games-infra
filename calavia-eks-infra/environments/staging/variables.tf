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
  description = "Número de subredes a crear"
  type        = number
  default     = 3
  
}
variable "subnet_cidrs" {
  description = "Lista de CIDRs para las subredes"
  type        = list(string)
  default     = [
    "10.0.0.0/20", 
    "10.0.16.0/20",
    "10.0.32.0/20"
  ]
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
  description = "Lista de zonas de disponibilidad para el clúster"
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
  default     = 2
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster"
  type        = number
  default     = 1
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