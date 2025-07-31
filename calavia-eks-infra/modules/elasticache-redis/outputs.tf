output "redis_replication_group_id" {
  description = "ElastiCache Redis replication group ID"
  value       = aws_elasticache_replication_group.redis.replication_group_id
}

output "redis_primary_endpoint" {
  description = "Redis primary endpoint"
  value       = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.redis.port
}

output "redis_reader_endpoint" {
  description = "Redis reader endpoint"
  value       = aws_elasticache_replication_group.redis.reader_endpoint_address
}

output "secret_arn" {
  description = "ARN of the secret containing Redis credentials"
  value       = aws_secretsmanager_secret.redis_credentials.arn
}

output "secret_name" {
  description = "Name of the secret containing Redis credentials"
  value       = aws_secretsmanager_secret.redis_credentials.name
}

output "service_account_role_arn" {
  description = "ARN of the IAM role for the Kubernetes service account"
  value       = aws_iam_role.redis_service_account.arn
}

output "kms_key_id" {
  description = "KMS Key ID used for encryption"
  value       = aws_kms_key.redis.key_id
}

output "kms_key_arn" {
  description = "KMS Key ARN used for encryption"
  value       = aws_kms_key.redis.arn
}

output "subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.main.name
}

output "redis_cluster_id" {
  description = "ID of the Redis replication group"
  value       = aws_elasticache_replication_group.redis.replication_group_id
}