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
  description = "Tipo de instancia para los nodos del clúster - optimizado para producción"
  type        = string
  default     = "t3.small"  # Reducido de t3.medium a t3.small (2 vCPUs, 2 GB RAM)
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster - optimizado"
  type        = number
  default     = 2  # Reducido de 3 a 2 para ahorrar costes manteniendo HA
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster - controlado"
  type        = number
  default     = 4  # Reducido de 5 a 4
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster - mínimo para HA"
  type        = number
  default     = 2  # Mantenido en 2 para alta disponibilidad
}

variable "redis_instance_type" {
  description = "Tipo de instancia para Redis - optimizado para producción"
  type        = string
  default     = "cache.t3.micro"  # Mantenido micro para cargas ligeras
}

variable "postgres_instance_type" {
  description = "Tipo de instancia para PostgreSQL - optimizado para producción"
  type        = string
  default     = "db.t3.small"  # Aumentado a small para mejor rendimiento en producción
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

# ===================================
# OPTIMIZACIÓN DE COSTES PRODUCCIÓN
# ===================================

variable "enable_spot_instances" {
  description = "Habilitar instancias spot para ahorrar costes"
  type        = bool
  default     = true  # Habilitado para ahorrar hasta 70% en compute
}

variable "spot_instance_percentage" {
  description = "Porcentaje de instancias spot en el node group"
  type        = number
  default     = 50  # 50% spot, 50% on-demand para balance coste/disponibilidad
}

variable "backup_retention_period" {
  description = "Período de retención de backups en días"
  type        = number
  default     = 7  # Reducido de 30 a 7 días para ahorrar costes
}

variable "storage_size" {
  description = "Tamaño de almacenamiento RDS en GB - optimizado"
  type        = number
  default     = 20  # Empezar con el mínimo y escalar según necesidad
}

variable "storage_type" {
  description = "Tipo de almacenamiento RDS"
  type        = string
  default     = "gp3"  # gp3 es más eficiente para volúmenes grandes
}

variable "allocated_storage_max" {
  description = "Máximo storage auto-scaling para RDS"
  type        = number
  default     = 100  # Limitado a 100GB para controlar costes
}

variable "enable_performance_insights" {
  description = "Habilitar Performance Insights (tiene coste adicional)"
  type        = bool
  default     = false  # Deshabilitado para ahorrar ~$2.5/mes por DB
}

# Variables adicionales requeridas por main.tf
variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "calavia_production"
}

variable "enable_multi_az" {
  description = "Habilitar Multi-AZ para RDS"
  type        = bool
  default     = false  # Deshabilitado para ahorrar costes (habilitarlo duplica el coste)
}

variable "redis_node_type" {
  description = "Tipo de instancia para Redis"
  type        = string
  default     = "cache.t3.micro"
}

# Variables para node groups
variable "on_demand_instance_type" {
  description = "Tipo de instancia para nodos on-demand"
  type        = string
  default     = "t3.small"
}

variable "on_demand_desired_size" {
  description = "Número deseado de nodos on-demand"
  type        = number
  default     = 1  # Mínimo para producción con coste controlado
}

variable "on_demand_max_size" {
  description = "Número máximo de nodos on-demand"
  type        = number
  default     = 3
}

variable "on_demand_min_size" {
  description = "Número mínimo de nodos on-demand"
  type        = number
  default     = 1
}

variable "spot_instance_types" {
  description = "Tipos de instancia para nodos spot"
  type        = list(string)
  default     = ["t3.small", "t3.medium"]
}

variable "spot_desired_size" {
  description = "Número deseado de nodos spot"
  type        = number
  default     = 1
}

variable "spot_max_size" {
  description = "Número máximo de nodos spot"
  type        = number
  default     = 4
}

variable "spot_min_size" {
  description = "Número mínimo de nodos spot"
  type        = number
  default     = 0
}