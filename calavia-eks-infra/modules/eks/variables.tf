variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
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

variable "instance_type" {
  description = "Tipo de instancia para los nodos del clúster"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el clúster"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de subredes donde se desplegará el clúster"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para el clúster"
  type        = list(string)
}

variable "enable_monitoring" {
  description = "Habilitar monitoreo para el clúster"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Etiquetas para los recursos del clúster"
  type        = map(string)
  default     = {}
}