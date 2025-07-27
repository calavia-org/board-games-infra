variable "redis_instance_type" {
  description = "Tipo de instancia para ElastiCache Redis"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_node_count" {
  description = "Número de nodos para ElastiCache Redis"
  type        = number
  default     = 1
}

variable "redis_cluster_name" {
  description = "Nombre del clúster de ElastiCache Redis"
  type        = string
  default     = "calavia-redis-cluster"
}

variable "redis_subnet_group_name" {
  description = "Nombre del grupo de subredes para ElastiCache Redis"
  type        = string
}

variable "redis_security_group_ids" {
  description = "IDs de los grupos de seguridad para ElastiCache Redis"
  type        = list(string)
}

variable "redis_parameter_group_name" {
  description = "Nombre del grupo de parámetros para ElastiCache Redis"
  type        = string
  default     = "default.redis3.2"
}

variable "redis_backup_retention_days" {
  description = "Días de retención de backups para ElastiCache Redis"
  type        = number
  default     = 7
}