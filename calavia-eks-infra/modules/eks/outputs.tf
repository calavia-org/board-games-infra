output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "node_group_role_arn" {
  value = module.eks.node_group_role_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "redis_endpoint" {
  value = module.elasticache_redis.redis_endpoint
}

output "postgres_endpoint" {
  value = module.rds_postgres.postgres_endpoint
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}