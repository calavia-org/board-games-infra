output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "rds_postgres_endpoint" {
  value = module.rds_postgres.endpoint
}

output "redis_endpoint" {
  value = module.elasticache_redis.endpoint
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}

output "alb_dns_name" {
  value = module.alb_ingress.alb_dns_name
}