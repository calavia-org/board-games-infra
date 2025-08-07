# Outputs for Secrets Manager Module

# KMS Key Outputs
output "secrets_kms_key_id" {
  description = "KMS key ID for secrets encryption"
  value       = aws_kms_key.secrets_key.key_id
}

output "secrets_kms_key_arn" {
  description = "KMS key ARN for secrets encryption"
  value       = aws_kms_key.secrets_key.arn
}

output "secrets_kms_alias_name" {
  description = "KMS key alias name"
  value       = aws_kms_alias.secrets_key_alias.name
}

# PostgreSQL Secret Outputs
output "postgres_master_secret_arn" {
  description = "ARN of PostgreSQL master credentials secret"
  value       = aws_secretsmanager_secret.postgres_master.arn
}

output "postgres_master_secret_name" {
  description = "Name of PostgreSQL master credentials secret"
  value       = aws_secretsmanager_secret.postgres_master.name
}

output "postgres_app_secret_arn" {
  description = "ARN of PostgreSQL application user credentials secret"
  value       = aws_secretsmanager_secret.postgres_app_user.arn
}

output "postgres_app_secret_name" {
  description = "Name of PostgreSQL application user credentials secret"
  value       = aws_secretsmanager_secret.postgres_app_user.name
}

# Redis Secret Outputs
output "redis_auth_secret_arn" {
  description = "ARN of Redis auth token secret"
  value       = aws_secretsmanager_secret.redis_auth.arn
}

output "redis_auth_secret_name" {
  description = "Name of Redis auth token secret"
  value       = aws_secretsmanager_secret.redis_auth.name
}

# Grafana Secret Outputs
output "grafana_admin_secret_arn" {
  description = "ARN of Grafana admin credentials secret"
  value       = aws_secretsmanager_secret.grafana_admin.arn
}

output "grafana_admin_secret_name" {
  description = "Name of Grafana admin credentials secret"
  value       = aws_secretsmanager_secret.grafana_admin.name
}

# Service Account Token Secret Outputs
output "prometheus_sa_secret_arn" {
  description = "ARN of Prometheus service account token secret"
  value       = aws_secretsmanager_secret.prometheus_sa_token.arn
}

output "prometheus_sa_secret_name" {
  description = "Name of Prometheus service account token secret"
  value       = aws_secretsmanager_secret.prometheus_sa_token.name
}

output "external_dns_sa_secret_arn" {
  description = "ARN of External DNS service account token secret"
  value       = aws_secretsmanager_secret.external_dns_sa_token.arn
}

output "external_dns_sa_secret_name" {
  description = "Name of External DNS service account token secret"
  value       = aws_secretsmanager_secret.external_dns_sa_token.name
}

output "cert_manager_sa_secret_arn" {
  description = "ARN of Cert Manager service account token secret"
  value       = aws_secretsmanager_secret.cert_manager_sa_token.arn
}

output "cert_manager_sa_secret_name" {
  description = "Name of Cert Manager service account token secret"
  value       = aws_secretsmanager_secret.cert_manager_sa_token.name
}

# Lambda Function Outputs
output "postgres_rotation_lambda_arn" {
  description = "ARN of PostgreSQL rotation Lambda function"
  value       = aws_lambda_function.postgres_rotation.arn
}

output "redis_rotation_lambda_arn" {
  description = "ARN of Redis rotation Lambda function"
  value       = aws_lambda_function.redis_rotation.arn
}

output "sa_token_rotation_lambda_arn" {
  description = "ARN of Service Account token rotation Lambda function"
  value       = aws_lambda_function.sa_token_rotation.arn
}

# IAM Role Output
output "rotation_lambda_role_arn" {
  description = "ARN of the IAM role for rotation Lambda functions"
  value       = aws_iam_role.secrets_rotation_lambda_role.arn
}

# Security Group Output
output "lambda_security_group_id" {
  description = "Security group ID for Lambda rotation functions"
  value       = aws_security_group.lambda_rotation_sg.id
}

# Rotation Schedule Information
output "rotation_schedules" {
  description = "Information about configured rotation schedules"
  value = {
    postgres_master_days = var.postgres_rotation_days
    postgres_app_days    = var.postgres_rotation_days
    redis_days           = var.redis_rotation_days
    grafana_days         = var.grafana_rotation_days
    service_account_days = var.sa_token_rotation_days
  }
}

# Secret Names for External Reference
output "secret_names" {
  description = "Map of secret names for external reference"
  value = {
    postgres_master = aws_secretsmanager_secret.postgres_master.name
    postgres_app    = aws_secretsmanager_secret.postgres_app_user.name
    redis_auth      = aws_secretsmanager_secret.redis_auth.name
    grafana_admin   = aws_secretsmanager_secret.grafana_admin.name
    prometheus_sa   = aws_secretsmanager_secret.prometheus_sa_token.name
    external_dns_sa = aws_secretsmanager_secret.external_dns_sa_token.name
    cert_manager_sa = aws_secretsmanager_secret.cert_manager_sa_token.name
  }
}

# Secret ARNs for IAM Policies
output "secret_arns" {
  description = "Map of secret ARNs for IAM policy references"
  value = {
    postgres_master = aws_secretsmanager_secret.postgres_master.arn
    postgres_app    = aws_secretsmanager_secret.postgres_app_user.arn
    redis_auth      = aws_secretsmanager_secret.redis_auth.arn
    grafana_admin   = aws_secretsmanager_secret.grafana_admin.arn
    prometheus_sa   = aws_secretsmanager_secret.prometheus_sa_token.arn
    external_dns_sa = aws_secretsmanager_secret.external_dns_sa_token.arn
    cert_manager_sa = aws_secretsmanager_secret.cert_manager_sa_token.arn
  }
}
