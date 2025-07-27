output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.endpoint
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.port
}

output "redis_primary_endpoint" {
  value = aws_elasticache_cluster.redis.primary_endpoint
}

output "redis_cluster_id" {
  value = aws_elasticache_cluster.redis.id
}