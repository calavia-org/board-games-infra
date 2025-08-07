# Local values for common configurations
locals {
  name   = var.cluster_name
  region = var.aws_region

  tags = {
    Environment = var.environment
    Project     = "board-games-infra"
    ManagedBy   = "terraform"
  }

  monitoring_retention = var.environment == "production" ? var.monitoring_retention_days : var.staging_monitoring_retention_days
}

# Generate random passwords
resource "random_password" "db_password" {
  count   = var.db_password == null ? 1 : 0
  length  = 16
  special = true
}

resource "random_password" "postgres_password" {
  length  = 16
  special = true
}

resource "random_password" "redis_auth_token" {
  length  = 32
  special = false
}

resource "random_password" "grafana_admin_password" {
  length  = 16
  special = true
}

# Create VPC and networking infrastructure
module "vpc" {
  source = "./modules/vpc"

  cluster_name       = local.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones

  tags = local.tags
}

# Create security groups and policies
module "security" {
  source = "./modules/security"

  cluster_name           = local.name
  vpc_id                 = module.vpc.vpc_id
  vpc_cidr               = var.vpc_cidr
  allowed_cidrs          = []
  subnet_ids             = module.vpc.database_subnet_ids
  grafana_admin_password = random_password.grafana_admin_password.result

  tags = local.tags
}

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name       = local.name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  availability_zones = var.availability_zones

  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  instance_types     = var.instance_types
  use_spot_instances = var.spot_instance

  security_group_ids = [module.security.eks_cluster_sg_id]

  tags = local.tags

  depends_on = [module.vpc, module.security]
}

# Create RDS PostgreSQL instance
module "rds_postgres" {
  source = "./modules/rds-postgres"

  cluster_name           = local.name
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.database_subnet_ids
  vpc_security_group_ids = [module.security.rds_sg_id]

  db_name           = var.postgres_db_name
  db_username       = var.db_username
  db_password       = var.db_password != null ? var.db_password : random_password.db_password[0].result
  instance_class    = var.postgres_instance_type
  allocated_storage = var.postgres_storage_size

  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = local.tags

  depends_on = [module.eks]
}

# Create ElastiCache Redis cluster
module "elasticache_redis" {
  source = "./modules/elasticache-redis"

  cluster_name       = local.name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.database_subnet_ids
  security_group_ids = [module.security.redis_sg_id]

  node_type       = var.redis_node_type
  num_cache_nodes = 1

  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = local.tags

  depends_on = [module.eks]
}

# Deploy ALB Ingress Controller
module "alb_ingress" {
  source = "./modules/alb-ingress"

  cluster_name      = module.eks.cluster_name
  aws_region        = local.region
  vpc_id            = module.vpc.vpc_id
  oidc_provider_arn = module.eks.oidc_provider_arn

  tags = local.tags

  depends_on = [module.eks]
}

# Deploy External DNS if enabled
module "external_dns" {
  count  = var.enable_external_dns ? 1 : 0
  source = "./modules/external-dns"

  cluster_name = module.eks.cluster_name
  region       = local.region

  domain_name             = var.domain_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = local.tags

  depends_on = [module.eks]
}

# Deploy Cert-Manager if enabled
module "cert_manager" {
  count  = var.enable_cert_manager ? 1 : 0
  source = "./modules/cert-manager"

  cluster_name = module.eks.cluster_name
  region       = local.region

  domain_name             = var.domain_name
  lets_encrypt_email      = var.lets_encrypt_email
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url

  tags = local.tags

  depends_on = [module.eks, module.external_dns]
}

# Deploy secrets management with automatic rotation
module "secrets_manager" {
  source = "./modules/secrets-manager"

  cluster_name = local.name
  region       = local.region
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids

  # PostgreSQL Configuration
  postgres_endpoint = module.rds_postgres.db_endpoint
  postgres_port     = module.rds_postgres.db_port
  postgres_database = module.rds_postgres.db_name
  postgres_username = "postgres"
  postgres_password = random_password.postgres_password.result

  # Redis configuration
  redis_endpoint   = module.elasticache_redis.redis_primary_endpoint
  redis_port       = module.elasticache_redis.redis_port
  redis_auth_token = random_password.redis_auth_token.result

  # Grafana Configuration
  grafana_admin_password = random_password.grafana_admin_password.result
  grafana_url            = var.enable_external_dns ? "https://grafana.${var.domain_name}" : ""

  # EKS Configuration
  eks_cluster_endpoint = module.eks.cluster_endpoint

  # Rotation Configuration
  postgres_rotation_days = var.environment == "production" ? 30 : 15
  redis_rotation_days    = var.environment == "production" ? 30 : 15
  grafana_rotation_days  = var.environment == "production" ? 90 : 30
  sa_token_rotation_days = var.environment == "production" ? 90 : 30

  # Notifications
  enable_rotation_notifications = var.enable_notifications
  notification_email            = var.notification_email
  slack_webhook_url             = var.slack_webhook_url

  tags = local.tags

  depends_on = [module.rds_postgres, module.elasticache_redis, module.eks]
}

# Deploy monitoring stack (Prometheus, Grafana, AlertManager)
module "monitoring" {
  source = "./modules/monitoring"

  cluster_name = module.eks.cluster_name
  region       = local.region

  retention_days          = local.monitoring_retention
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  grafana_admin_password  = random_password.grafana_admin_password.result

  tags = local.tags

  depends_on = [module.eks, module.secrets_manager]
}
