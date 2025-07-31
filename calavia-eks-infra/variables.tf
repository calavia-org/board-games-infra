variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (staging/production)"
  type        = string
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be either 'staging' or 'production'."
  }
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará el clúster"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para el clúster"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster"
  type        = number
  default     = 3
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster"
  type        = number
  default     = 10
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "Tipos de instancia para los nodos del clúster"
  type        = list(string)
  default     = ["m5.large", "m5.xlarge", "m4.large"]
}

variable "spot_instance" {
  description = "Indica si se deben usar instancias spot"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_username" {
  description = "Nombre de usuario para la base de datos"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Contraseña para la base de datos"
  type        = string
  sensitive   = true
  default     = null
}

variable "redis_node_type" {
  description = "Tipo de nodo para Redis"
  type        = string
  default     = "cache.t3.micro"
}

variable "postgres_db_name" {
  description = "Nombre de la base de datos PostgreSQL"
  type        = string
  default     = "boardgames"
}

variable "postgres_instance_type" {
  description = "Tipo de instancia para PostgreSQL"
  type        = string
  default     = "db.t3.micro"
}

variable "postgres_storage_size" {
  description = "Tamaño de almacenamiento para PostgreSQL en GB"
  type        = number
  default     = 20
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

variable "domain_name" {
  description = "Nombre de dominio principal para la aplicación"
  type        = string
  default     = "boardgames.example.com"
}

variable "lets_encrypt_email" {
  description = "Email para certificados Let's Encrypt"
  type        = string
  default     = "admin@example.com"
}