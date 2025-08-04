# Centralized tagging module for production
module "tags" {
  source = "../../modules/tags"

  environment            = "production"
  owner_email            = var.owner_email
  project_name           = var.project_name
  cost_center            = var.cost_center
  business_unit          = var.business_unit
  department             = var.department
  criticality            = "critical"
  service                = "board-games-platform" # Main service identifier
  infrastructure_version = var.infrastructure_version

  additional_tags = {
    Environment_Type   = "production"
    Compliance         = "sox-required"
    DataClassification = "confidential"
  }
}

resource "aws_vpc" "calavia_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-production"
    Component = "networking"
    Purpose   = "main-vpc-production"
  })
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.calavia_vpc.id

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-flow-logs-production"
    Component = "monitoring"
    Purpose   = "vpc-flow-logs"
  })
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flowlogs/production"
  retention_in_days = 7

  tags = merge(module.tags.tags, {
    Name      = "calavia-vpc-flow-logs-group-production"
    Component = "monitoring"
    Purpose   = "vpc-flow-logs"
  })
}

resource "aws_iam_role" "flow_logs_role" {
  name = "flow-logs-role-production"

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
  name = "flow-logs-policy-production"
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

  tags = merge(module.tags.tags, {
    Name             = "calavia-subnet-production-${count.index}"
    Component        = "networking"
    Purpose          = "kubernetes-subnet-${count.index}"
    SubnetType       = "private"
    AvailabilityZone = element(var.availability_zones, count.index)
  })
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

resource "aws_eks_cluster" "calavia_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  # VPC configuration with restricted public access
  vpc_config {
    subnet_ids              = aws_subnet.calavia_subnet[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
    public_access_cidrs     = [] # No public access
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
    Service   = "container-orchestration-service" # Main orchestration service
    Purpose   = "container-orchestration"
  })
}

resource "aws_iam_role" "eks_role" {
  name = "calavia-eks-role-production"

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

  tags = module.tags.tags
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
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

resource "aws_db_instance" "calavia_postgres" {
  identifier        = "calavia-postgres-production"
  engine            = "postgres"
  engine_version    = "14.9"
  instance_class    = var.postgres_instance_type # db.t3.small
  allocated_storage = var.storage_size           # 100 GB
  storage_type      = var.storage_type           # gp2

  # Configuración de base de datos
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  # Configuraciones para producción
  multi_az                = var.enable_multi_az         # true para alta disponibilidad
  backup_retention_period = var.backup_retention_period # 7 días
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  # Configuraciones de seguridad
  vpc_security_group_ids    = [aws_security_group.db_sg.id]
  skip_final_snapshot       = false # Para producción sí necesitamos snapshot final
  final_snapshot_identifier = "calavia-postgres-production-final-snapshot"

  # Security enhancements
  storage_encrypted                   = true
  kms_key_id                          = aws_kms_key.rds_encryption.arn
  iam_database_authentication_enabled = true
  deletion_protection                 = true

  # Performance Insights habilitado para producción
  performance_insights_enabled = false # Deshabilitado para ahorrar costes

  tags = merge(module.tags.tags, {
    Name           = "calavia-postgres-production"
    Component      = "database"
    Service        = "user-data-service" # Specific service using this database
    Purpose        = "application-data-store"
    BackupSchedule = "daily"
  })
}

resource "aws_security_group" "db_sg" {
  name_prefix = "calavia-db-sg-production"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(module.tags.tags, {
    Name      = "calavia-db-sg-production"
    Component = "security"
    Purpose   = "database-access-control"
  })
}

resource "aws_elasticache_cluster" "calavia_redis" {
  cluster_id           = "calavia-redis-production"
  engine               = "redis"
  node_type            = var.redis_node_type # cache.t3.micro
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_sg.id]

  # Backup configuration
  snapshot_retention_limit = 7
  snapshot_window          = "03:00-05:00"

  tags = merge(module.tags.tags, {
    Name      = "calavia-redis-production"
    Component = "cache"
    Service   = "session-cache-service" # Specific service using this cache
    Purpose   = "application-cache"
  })
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "calavia-redis-sg-production"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(module.tags.tags, {
    Name      = "calavia-redis-sg-production"
    Component = "security"
    Purpose   = "redis-access-control"
  })
}

resource "aws_eks_node_group" "calavia_on_demand" {
  cluster_name    = aws_eks_cluster.calavia_eks.name
  node_group_name = "calavia-on-demand-production"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.calavia_subnet[*].id

  capacity_type  = "ON_DEMAND"
  instance_types = [var.on_demand_instance_type] # t3.small

  scaling_config {
    desired_size = var.on_demand_desired_size # 2
    max_size     = var.on_demand_max_size     # 4
    min_size     = var.on_demand_min_size     # 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy,
  ]

  tags = merge(module.tags.tags, {
    Name         = "calavia-on-demand-production"
    Component    = "compute"
    Purpose      = "worker-nodes-on-demand"
    CapacityType = "on-demand"
  })

  # Configuración de tagging para los nodos
  labels = {
    Environment = "production"
    NodeType    = "on-demand"
    Purpose     = "general-workloads"
  }
}

resource "aws_eks_node_group" "calavia_spot" {
  cluster_name    = aws_eks_cluster.calavia_eks.name
  node_group_name = "calavia-spot-production"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.calavia_subnet[*].id

  capacity_type  = "SPOT"
  instance_types = var.spot_instance_types # ["t3.small", "t3.medium"]

  scaling_config {
    desired_size = var.spot_desired_size # 2
    max_size     = var.spot_max_size     # 6
    min_size     = var.spot_min_size     # 0
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy,
  ]

  tags = merge(module.tags.tags, {
    Name         = "calavia-spot-production"
    Component    = "compute"
    Purpose      = "worker-nodes-spot"
    CapacityType = "spot"
  })

  # Configuración de tagging para los nodos
  labels = {
    Environment = "production"
    NodeType    = "spot"
    Purpose     = "batch-workloads"
  }
}

resource "aws_iam_role" "node_role" {
  name = "calavia-node-role-production"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })

  tags = module.tags.tags
}

resource "aws_iam_role_policy_attachment" "node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}
