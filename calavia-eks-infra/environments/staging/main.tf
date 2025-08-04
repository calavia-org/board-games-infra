# Centralized tagging module for staging
module "tags" {
  source = "../../modules/tags"

  environment            = "staging"
  owner_email            = var.owner_email
  project_name           = var.project_name
  cost_center            = var.cost_center
  business_unit          = var.business_unit
  department             = var.department
  criticality            = "medium"
  service                = "board-games-platform" # Main service identifier
  infrastructure_version = var.infrastructure_version

  additional_tags = {
    Environment_Type   = "staging"
    AutoShutdown       = "enabled"
    DataClassification = "internal"
  }
}

resource "aws_vpc" "calavia_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-staging"
    Component = "networking"
    Purpose   = "main-vpc-staging"
  })
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.calavia_vpc.id

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-flow-logs-staging"
    Component = "monitoring"
    Purpose   = "vpc-flow-logs"
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/staging"
  retention_in_days = 3 # Shorter retention for staging

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-flow-logs-group-staging"
    Component = "monitoring"
    Purpose   = "vpc-flow-logs"
  })
}

resource "aws_iam_role" "flow_logs_role" {
  name = "flow-logs-role-staging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = module.tags.tags
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name = "flow-logs-policy-staging"
  role = aws_iam_role.flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_subnet" "calavia_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.calavia_vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "calavia-subnet-staging-${count.index}"
  }
}

# KMS key for EKS encryption
resource "aws_kms_key" "eks_encryption" {
  description             = "KMS key for EKS cluster encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(module.tags.tags, {
    Name      = "${var.cluster_name}-eks-encryption-key"
    Component = "security"
    Purpose   = "eks-encryption"
  })
}

resource "aws_kms_alias" "eks_encryption" {
  name          = "alias/${var.cluster_name}-eks-encryption"
  target_key_id = aws_kms_key.eks_encryption.key_id
}

# KMS key for RDS encryption
resource "aws_kms_key" "rds_encryption" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(module.tags.tags, {
    Name      = "${var.cluster_name}-rds-encryption-key"
    Component = "security"
    Purpose   = "rds-encryption"
  })
}

resource "aws_kms_alias" "rds_encryption" {
  name          = "alias/${var.cluster_name}-rds-encryption"
  target_key_id = aws_kms_key.rds_encryption.key_id
}

resource "aws_eks_cluster" "calavia_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  # VPC configuration with restricted public access for staging
  vpc_config {
    subnet_ids              = aws_subnet.calavia_subnet[*].id
    endpoint_private_access = true
    endpoint_public_access  = false           # Disable public access for security
    public_access_cidrs     = ["10.0.0.0/16"] # Restrict to VPC CIDR only
  }

  # Enable control plane logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Enable encryption for secrets
  encryption_config {
    provider {
      key_arn = aws_kms_key.eks_encryption.arn
    }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy,
    aws_kms_key.eks_encryption
  ]

  tags = merge(module.tags.tags, {
    Name      = var.cluster_name
    Component = "kubernetes"
    Purpose   = "staging-container-orchestration"
  })
}

resource "aws_iam_role" "eks_role" {
  name = "calavia-eks-role-staging"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_db_instance" "calavia_postgres" {
  identifier        = "calavia-postgres-staging"
  engine            = "postgres"
  engine_version    = "14.9"
  instance_class    = var.postgres_instance_type # db.t3.micro
  allocated_storage = var.storage_size           # 20 GB mínimo
  storage_type      = var.storage_type           # gp2 para staging

  # Configuración de base de datos
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Configuraciones de coste optimizado para staging
  multi_az                = var.enable_multi_az # false para staging
  backup_retention_period = 7                   # 7 días mínimo recomendado
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  # Configuraciones de seguridad
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true # Para staging no necesitamos snapshot final

  # Security enhancements
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.rds_encryption.arn
  iam_database_authentication_enabled = true
  deletion_protection                 = true # Enable protection even for staging

  # Performance Insights deshabilitado para ahorrar costes
  performance_insights_enabled = false

  tags = merge(module.tags.tags, {
    Name            = "calavia-postgres-staging"
    Component       = "database"
    Service         = "user-data-service-staging" # Staging version of user data service
    Purpose         = "staging-game-database"
    Engine          = "postgresql"
    EngineVersion   = "14.9"
    BackupRetention = "1-day"
    MultiAZ         = "false"
    StorageType     = var.storage_type
    CostOptimized   = "true"
  })
}

resource "aws_elasticache_cluster" "calavia_redis" {
  cluster_id           = "calavia-redis-staging"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = var.redis_instance_type # cache.t2.micro - la más barata
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  # Backup and snapshot settings
  snapshot_retention_limit = 5
  snapshot_window          = "03:00-05:00"

  tags = merge(module.tags.tags, {
    Name          = "calavia-redis-staging"
    Component     = "cache"
    Service       = "session-cache-service-staging" # Staging version of session cache
    Purpose       = "staging-session-cache"
    Engine        = "redis"
    EngineVersion = "7.0"
    NodeType      = var.redis_instance_type
    CostOptimized = "true"
    Encryption    = "disabled"
  })
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "calavia-redis-subnet-group-staging"
  subnet_ids = aws_subnet.calavia_subnet[*].id

  tags = merge(module.tags.tags, {
    Name          = "calavia-redis-subnet-group-staging"
    Component     = "networking"
    Purpose       = "redis-subnet-group"
    ResourceType  = "elasticache-subnet-group"
    CostOptimized = "true"
  })
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.calavia_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_sg.id]
  }

  tags = merge(module.tags.tags, {
    Name         = "calavia-db-sg-staging"
    Component    = "database"
    Purpose      = "postgres-security-group"
    ResourceType = "security-group"
    Protocol     = "tcp"
    Port         = "5432"
  })
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "calavia-redis-sg-staging"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(module.tags.tags, {
    Name          = "calavia-redis-sg-staging"
    Component     = "cache"
    Purpose       = "redis-security-group"
    ResourceType  = "security-group"
    Protocol      = "tcp"
    Port          = "6379"
    CostOptimized = "true"
  })
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(module.tags.tags, {
    Name         = "calavia-eks-sg-staging"
    Component    = "compute"
    Purpose      = "eks-cluster-security-group"
    ResourceType = "security-group"
    Protocol     = "tcp"
    Port         = "443"
  })
}
