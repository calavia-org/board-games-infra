output "cluster_endpoint" {
  description = "EKS cluster endpoint for API server access"
  value       = aws_eks_cluster.calavia_eks.endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.calavia_eks.name
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint for database connections"
  value       = aws_db_instance.calavia_postgres.endpoint
}

output "redis_endpoint" {
  description = "ElastiCache Redis cluster endpoint for caching"
  value       = aws_elasticache_cluster.calavia_redis.configuration_endpoint
}
