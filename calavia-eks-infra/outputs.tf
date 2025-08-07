output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  description = "Certificate authority data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "rds_postgres_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds_postgres.db_endpoint
}

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = module.elasticache_redis.redis_primary_endpoint
}

# output "grafana_url" {
#   value = module.monitoring.grafana_url
# }

# output "alb_dns_name" {
#   value = module.alb_ingress.alb_dns_name
# }

# Secrets Manager Outputs
output "secrets_kms_key_arn" {
  description = "ARN of the KMS key used for secrets encryption"
  value       = module.secrets_manager.secrets_kms_key_arn
}

output "postgres_master_secret_arn" {
  description = "ARN of PostgreSQL master credentials secret"
  value       = module.secrets_manager.postgres_master_secret_arn
  sensitive   = true
}

output "postgres_app_secret_arn" {
  description = "ARN of PostgreSQL application user credentials secret"
  value       = module.secrets_manager.postgres_app_secret_arn
  sensitive   = true
}

output "redis_auth_secret_arn" {
  description = "ARN of Redis auth token secret"
  value       = module.secrets_manager.redis_auth_secret_arn
  sensitive   = true
}

output "grafana_admin_secret_arn" {
  description = "ARN of Grafana admin credentials secret"
  value       = module.secrets_manager.grafana_admin_secret_arn
  sensitive   = true
}

output "secret_names" {
  description = "Map of all secret names for reference"
  value       = module.secrets_manager.secret_names
}

output "rotation_schedules" {
  description = "Information about configured rotation schedules"
  value       = module.secrets_manager.rotation_schedules
}
