terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# AWS Secrets Manager Module for Service Account Password Rotation

# KMS Key for Secrets Encryption
resource "aws_kms_key" "secrets_key" {
  description             = "KMS key for ${var.cluster_name} secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Secrets Manager access"
        Effect = "Allow"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-secrets-kms-key"
  })
}

resource "aws_kms_alias" "secrets_key_alias" {
  name          = "alias/${var.cluster_name}-secrets"
  target_key_id = aws_kms_key.secrets_key.key_id
}

# PostgreSQL Master Credentials
resource "aws_secretsmanager_secret" "postgres_master" {
  name                    = "${var.cluster_name}-postgres-master-credentials"
  description             = "Master credentials for PostgreSQL RDS instance"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  replica {
    region = var.backup_region
  }

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-postgres-master"
    Service    = "RDS"
    SecretType = "database-credentials" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret_version" "postgres_master" {
  secret_id = aws_secretsmanager_secret.postgres_master.id
  secret_string = jsonencode({
    username = var.postgres_username
    password = var.postgres_password # pragma: allowlist secret
    engine   = "postgres"
    host     = var.postgres_endpoint
    port     = var.postgres_port
    dbname   = var.postgres_database
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# PostgreSQL Application User Credentials
resource "aws_secretsmanager_secret" "postgres_app_user" {
  name                    = "${var.cluster_name}-postgres-app-credentials"
  description             = "Application user credentials for PostgreSQL"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  replica {
    region = var.backup_region
  }

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-postgres-app"
    Service    = "RDS"
    SecretType = "database-credentials" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret_version" "postgres_app_user" {
  secret_id = aws_secretsmanager_secret.postgres_app_user.id
  secret_string = jsonencode({
    username   = "${var.cluster_name}_app_user"
    password   = random_password.postgres_app_password.result # pragma: allowlist secret
    engine     = "postgres"
    host       = var.postgres_endpoint
    port       = var.postgres_port
    dbname     = var.postgres_database
    privileges = ["CONNECT", "CREATE", "TEMPORARY"]
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "random_password" "postgres_app_password" {
  length  = 32
  special = true
}

# Redis Auth Token
resource "aws_secretsmanager_secret" "redis_auth" {
  name                    = "${var.cluster_name}-redis-auth-token"
  description             = "Auth token for Redis ElastiCache cluster"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  replica {
    region = var.backup_region
  }

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-redis-auth"
    Service    = "ElastiCache"
    SecretType = "auth-token" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id = aws_secretsmanager_secret.redis_auth.id
  secret_string = jsonencode({
    auth_token = var.redis_auth_token
    host       = var.redis_endpoint
    port       = var.redis_port
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Grafana Admin Credentials
resource "aws_secretsmanager_secret" "grafana_admin" {
  name                    = "${var.cluster_name}-grafana-admin-credentials"
  description             = "Admin credentials for Grafana"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  replica {
    region = var.backup_region
  }

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-grafana-admin"
    Service    = "Grafana"
    SecretType = "admin-credentials" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret_version" "grafana_admin" {
  secret_id = aws_secretsmanager_secret.grafana_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = var.grafana_admin_password # pragma: allowlist secret
    url      = var.grafana_url
  })

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Service Account Tokens for Kubernetes
resource "aws_secretsmanager_secret" "prometheus_sa_token" {
  name                    = "${var.cluster_name}-prometheus-sa-token"
  description             = "Service Account token for Prometheus"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-prometheus-sa"
    Service    = "Prometheus"
    SecretType = "service-account-token" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret" "external_dns_sa_token" {
  name                    = "${var.cluster_name}-external-dns-sa-token"
  description             = "Service Account token for External DNS"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-external-dns-sa"
    Service    = "ExternalDNS"
    SecretType = "service-account-token" # pragma: allowlist secret
  })
}

resource "aws_secretsmanager_secret" "cert_manager_sa_token" {
  name                    = "${var.cluster_name}-cert-manager-sa-token"
  description             = "Service Account token for Cert Manager"
  kms_key_id              = aws_kms_key.secrets_key.arn
  recovery_window_in_days = 7

  tags = merge(var.tags, {
    Name       = "${var.cluster_name}-cert-manager-sa"
    Service    = "CertManager"
    SecretType = "service-account-token" # pragma: allowlist secret
  })
}

# Lambda Execution Role for Rotation
resource "aws_iam_role" "secrets_rotation_lambda_role" {
  name = "${var.cluster_name}-secrets-rotation-lambda-role"

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

resource "aws_iam_role_policy" "secrets_rotation_lambda_policy" {
  name = "${var.cluster_name}-secrets-rotation-lambda-policy"
  role = aws_iam_role.secrets_rotation_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecretVersionStage",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          aws_secretsmanager_secret.postgres_master.arn,
          aws_secretsmanager_secret.postgres_app_user.arn,
          aws_secretsmanager_secret.redis_auth.arn,
          aws_secretsmanager_secret.grafana_admin.arn,
          aws_secretsmanager_secret.prometheus_sa_token.arn,
          aws_secretsmanager_secret.external_dns_sa_token.arn,
          aws_secretsmanager_secret.cert_manager_sa_token.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey"
        ]
        Resource = aws_kms_key.secrets_key.arn
      },
      {
        Effect = "Allow"
        Action = [
          "rds:ModifyDBInstance",
          "rds:DescribeDBInstances"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:ModifyReplicationGroup",
          "elasticache:DescribeReplicationGroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda function for PostgreSQL rotation
resource "aws_lambda_function" "postgres_rotation" {
  filename         = data.archive_file.postgres_rotation_zip.output_path
  function_name    = "${var.cluster_name}-postgres-rotation"
  role             = aws_iam_role.secrets_rotation_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.postgres_rotation_zip.output_base64sha256
  runtime          = "python3.9"
  timeout          = 300

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com" # pragma: allowlist secret
      RDS_ENDPOINT             = var.postgres_endpoint
    }
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_rotation_sg.id]
  }

  tags = var.tags
}

# Lambda function for Redis rotation
resource "aws_lambda_function" "redis_rotation" {
  filename         = data.archive_file.redis_rotation_zip.output_path
  function_name    = "${var.cluster_name}-redis-rotation"
  role             = aws_iam_role.secrets_rotation_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.redis_rotation_zip.output_base64sha256
  runtime          = "python3.9"
  timeout          = 300

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com" # pragma: allowlist secret
      ELASTICACHE_ENDPOINT     = var.redis_endpoint
    }
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_rotation_sg.id]
  }

  tags = var.tags
}

# Lambda function for Service Account token rotation
resource "aws_lambda_function" "sa_token_rotation" {
  filename         = data.archive_file.sa_rotation_zip.output_path
  function_name    = "${var.cluster_name}-sa-token-rotation"
  role             = aws_iam_role.secrets_rotation_lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.sa_rotation_zip.output_base64sha256
  runtime          = "python3.9"
  timeout          = 300

  environment {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.${var.region}.amazonaws.com" # pragma: allowlist secret
      EKS_CLUSTER_NAME         = var.cluster_name
      EKS_CLUSTER_ENDPOINT     = var.eks_cluster_endpoint
    }
  }

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_rotation_sg.id]
  }

  tags = var.tags
}

# Security Group for Lambda functions
resource "aws_security_group" "lambda_rotation_sg" {
  name        = "${var.cluster_name}-lambda-rotation-sg"
  description = "Security group for Lambda rotation functions"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outbound for AWS APIs"
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "PostgreSQL access"
  }

  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Redis access"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-lambda-rotation-sg"
  })
}

# Automatic rotation schedules
resource "aws_secretsmanager_secret_rotation" "postgres_master_rotation" {
  secret_id           = aws_secretsmanager_secret.postgres_master.id
  rotation_lambda_arn = aws_lambda_function.postgres_rotation.arn

  rotation_rules {
    automatically_after_days = var.postgres_rotation_days
  }

  depends_on = [aws_lambda_permission.postgres_rotation_permission]
}

resource "aws_secretsmanager_secret_rotation" "postgres_app_rotation" {
  secret_id           = aws_secretsmanager_secret.postgres_app_user.id
  rotation_lambda_arn = aws_lambda_function.postgres_rotation.arn

  rotation_rules {
    automatically_after_days = var.postgres_rotation_days
  }

  depends_on = [aws_lambda_permission.postgres_rotation_permission]
}

resource "aws_secretsmanager_secret_rotation" "redis_rotation" {
  secret_id           = aws_secretsmanager_secret.redis_auth.id
  rotation_lambda_arn = aws_lambda_function.redis_rotation.arn

  rotation_rules {
    automatically_after_days = var.redis_rotation_days
  }

  depends_on = [aws_lambda_permission.redis_rotation_permission]
}

resource "aws_secretsmanager_secret_rotation" "grafana_rotation" {
  secret_id           = aws_secretsmanager_secret.grafana_admin.id
  rotation_lambda_arn = aws_lambda_function.sa_token_rotation.arn

  rotation_rules {
    automatically_after_days = var.grafana_rotation_days
  }

  depends_on = [aws_lambda_permission.sa_rotation_permission]
}

# Service Account token rotations
resource "aws_secretsmanager_secret_rotation" "prometheus_sa_rotation" {
  secret_id           = aws_secretsmanager_secret.prometheus_sa_token.id
  rotation_lambda_arn = aws_lambda_function.sa_token_rotation.arn

  rotation_rules {
    automatically_after_days = var.sa_token_rotation_days
  }

  depends_on = [aws_lambda_permission.sa_rotation_permission]
}

resource "aws_secretsmanager_secret_rotation" "external_dns_sa_rotation" {
  secret_id           = aws_secretsmanager_secret.external_dns_sa_token.id
  rotation_lambda_arn = aws_lambda_function.sa_token_rotation.arn

  rotation_rules {
    automatically_after_days = var.sa_token_rotation_days
  }

  depends_on = [aws_lambda_permission.sa_rotation_permission]
}

resource "aws_secretsmanager_secret_rotation" "cert_manager_sa_rotation" {
  secret_id           = aws_secretsmanager_secret.cert_manager_sa_token.id
  rotation_lambda_arn = aws_lambda_function.sa_token_rotation.arn

  rotation_rules {
    automatically_after_days = var.sa_token_rotation_days
  }

  depends_on = [aws_lambda_permission.sa_rotation_permission]
}

# Lambda permissions for Secrets Manager
resource "aws_lambda_permission" "postgres_rotation_permission" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.postgres_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_lambda_permission" "redis_rotation_permission" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redis_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_lambda_permission" "sa_rotation_permission" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sa_token_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}

# CloudWatch Log Groups for Lambda functions
resource "aws_cloudwatch_log_group" "postgres_rotation_logs" {
  name              = "/aws/lambda/${aws_lambda_function.postgres_rotation.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.secrets_key.arn

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "redis_rotation_logs" {
  name              = "/aws/lambda/${aws_lambda_function.redis_rotation.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.secrets_key.arn

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "sa_rotation_logs" {
  name              = "/aws/lambda/${aws_lambda_function.sa_token_rotation.function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.secrets_key.arn

  tags = var.tags
}

# Data sources
data "aws_caller_identity" "current" {}

# Lambda deployment packages
data "archive_file" "postgres_rotation_zip" {
  type        = "zip"
  output_path = "${path.module}/postgres_rotation.zip"
  source {
    content = templatefile("${path.module}/lambda_functions/postgres_rotation.py", {
      region = var.region
    })
    filename = "lambda_function.py"
  }
}

data "archive_file" "redis_rotation_zip" {
  type        = "zip"
  output_path = "${path.module}/redis_rotation.zip"
  source {
    content = templatefile("${path.module}/lambda_functions/redis_rotation.py", {
      region = var.region
    })
    filename = "lambda_function.py"
  }
}

data "archive_file" "sa_rotation_zip" {
  type        = "zip"
  output_path = "${path.module}/sa_rotation.zip"
  source {
    content = templatefile("${path.module}/lambda_functions/sa_token_rotation.py", {
      region = var.region
    })
    filename = "lambda_function.py"
  }
}
