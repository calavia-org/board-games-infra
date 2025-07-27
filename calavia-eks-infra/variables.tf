variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
}

variable "region" {
  description = "Región de AWS donde se desplegará el clúster"
  type        = string
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para el clúster"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster"
  type        = number
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster"
  type        = number
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster"
  type        = number
}

variable "instance_type" {
  description = "Tipo de instancia para los nodos del clúster"
  type        = string
}

variable "spot_instance" {
  description = "Indica si se deben usar instancias spot"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "db_username" {
  description = "Nombre de usuario para la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña para la base de datos"
  type        = string
  sensitive   = true
}

variable "redis_node_type" {
  description = "Tipo de nodo para Redis"
  type        = string
}

variable "postgres_db_name" {
  description = "Nombre de la base de datos PostgreSQL"
  type        = string
}

variable "monitoring_retention_days" {
  description = "Días de retención para las métricas de monitoreo"
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