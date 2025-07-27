variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el clúster EKS"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs de subredes donde se desplegarán los nodos del clúster EKS"
  type        = list(string)
}

variable "cluster_name" {
  description = "Nombre del clúster EKS"
  type        = string
}

variable "node_instance_type" {
  description = "Tipo de instancia para los nodos del clúster EKS"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Número deseado de nodos en el clúster EKS"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Número máximo de nodos en el clúster EKS"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Número mínimo de nodos en el clúster EKS"
  type        = number
  default     = 1
}

variable "enable_spot_instances" {
  description = "Habilitar instancias spot para los nodos del clúster EKS"
  type        = bool
  default     = true
}

variable "allowed_cidrs" {
  description = "Lista de CIDRs permitidos para el acceso a la red"
  type        = list(string)
}

variable "monitoring_retention_days" {
  description = "Días de retención para las métricas de monitoreo"
  type        = number
  default     = 3
}

variable "grafana_admin_password" {
  description = "Contraseña para el usuario administrador de Grafana"
  type        = string
  sensitive   = true
}