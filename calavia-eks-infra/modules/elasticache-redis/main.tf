# KMS Key for ElastiCache encryption
resource "aws_kms_key" "redis" {
  description             = "KMS key for ElastiCache Redis encryption"
  deletion_window_in_days = 7

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-key"
  })
}

resource "aws_kms_alias" "redis" {
  name          = "alias/${var.cluster_name}-redis"
  target_key_id = aws_kms_key.redis.key_id
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.cluster_name}-redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-subnet-group"
  })
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "redis" {
  family = "redis7.x"
  name   = "${var.cluster_name}-redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  parameter {
    name  = "timeout"
    value = "300"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-params"
  })
}

# ElastiCache Redis Replication Group (for better features)
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.cluster_name}-redis"
  description          = "Redis replication group for ${var.cluster_name}"

  # Engine settings
  engine               = "redis"
  engine_version       = var.redis_version
  node_type            = var.node_type
  port                 = var.port
  parameter_group_name = aws_elasticache_parameter_group.redis.name

  # Cluster settings
  num_cache_clusters = var.num_cache_nodes

  # Network settings
  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = var.security_group_ids

  # Backup settings
  snapshot_retention_limit = var.backup_retention_limit
  snapshot_window          = var.backup_window
  maintenance_window       = var.maintenance_window

  # Encryption settings
  at_rest_encryption_enabled = var.enable_encryption_at_rest
  transit_encryption_enabled = var.enable_encryption_in_transit
  kms_key_id                 = var.enable_encryption_at_rest ? aws_kms_key.redis.arn : null

  # Auth token for encryption in transit
  auth_token = var.enable_encryption_in_transit ? random_password.redis_auth_token.result : null

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis"
  })

  depends_on = [aws_elasticache_subnet_group.main]
}

# Random auth token for Redis
resource "random_password" "redis_auth_token" {
  length  = 32
  special = false
}

# Secret in AWS Secrets Manager for Redis auth token
resource "aws_secretsmanager_secret" "redis_credentials" {
  name                    = "${var.cluster_name}/redis/auth"
  description             = "Redis auth token for ${var.cluster_name}"
  recovery_window_in_days = 7

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-credentials"
  })
}

resource "aws_secretsmanager_secret_version" "redis_credentials" {
  secret_id = aws_secretsmanager_secret.redis_credentials.id
  secret_string = jsonencode({
    auth_token = random_password.redis_auth_token.result
    host       = aws_elasticache_replication_group.redis.primary_endpoint_address
    port       = aws_elasticache_replication_group.redis.port
    engine     = "redis"
  })
}

# IAM Role for Kubernetes Service Account (IRSA)
resource "aws_iam_role" "redis_service_account" {
  name = "${var.cluster_name}-redis-service-account-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.cluster_oidc_issuer_url, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:default:redis-service-account"
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for accessing ElastiCache and Secrets Manager
resource "aws_iam_policy" "redis_access" {
  name        = "${var.cluster_name}-redis-access-policy"
  description = "Policy for accessing ElastiCache and secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.redis_credentials.arn
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeReplicationGroups"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "redis_access" {
  role       = aws_iam_role.redis_service_account.name
  policy_arn = aws_iam_policy.redis_access.arn
}

# CloudWatch Log Group for Redis slow log
resource "aws_cloudwatch_log_group" "redis_slow_log" {
  name              = "/aws/elasticache/redis/${aws_elasticache_replication_group.redis.replication_group_id}"
  retention_in_days = 7

  tags = var.tags
}

# Data source for current AWS account
data "aws_caller_identity" "current" {}

# Automatic auth token rotation (monthly)
resource "aws_secretsmanager_secret_rotation" "redis_credentials" {
  secret_id           = aws_secretsmanager_secret.redis_credentials.id
  rotation_lambda_arn = aws_lambda_function.redis_token_rotation.arn

  rotation_rules {
    automatically_after_days = 30
  }

  depends_on = [aws_lambda_permission.secrets_manager_redis]
}

# Lambda function for auth token rotation
resource "aws_lambda_function" "redis_token_rotation" {
  filename         = "redis_token_rotation.zip"
  function_name    = "${var.cluster_name}-redis-token-rotation"
  role             = aws_iam_role.lambda_redis_rotation.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.redis_token_rotation.output_base64sha256
  runtime          = "python3.9"
  timeout          = 60

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${data.aws_region.current.name}.amazonaws.com" # pragma: allowlist secret
    }
  }

  tags = var.tags
}

# Archive file for Lambda function
data "archive_file" "redis_token_rotation" {
  type        = "zip"
  output_path = "redis_token_rotation.zip"
  source {
    content = templatefile("${path.module}/redis_token_rotation.py", {
      cluster_name = var.cluster_name
    })
    filename = "lambda_function.py"
  }
}

# IAM Role for Lambda function
resource "aws_iam_role" "lambda_redis_rotation" {
  name = "${var.cluster_name}-lambda-redis-rotation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_redis_rotation_basic" {
  role       = aws_iam_role.lambda_redis_rotation.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_redis_rotation_secrets" {
  name = "${var.cluster_name}-lambda-redis-rotation-secrets-policy"
  role = aws_iam_role.lambda_redis_rotation.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage"
        ]
        Resource = aws_secretsmanager_secret.redis_credentials.arn
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:ModifyCacheCluster"
        ]
        Resource = aws_elasticache_replication_group.redis.arn
      }
    ]
  })
}

# Lambda permission for Secrets Manager
resource "aws_lambda_permission" "secrets_manager_redis" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redis_token_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}

# Data source for current region
data "aws_region" "current" {}
