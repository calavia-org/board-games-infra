# Centralized tagging module
module "tags" {
  source = "../../modules/tags"
  
  environment             = "production"
  owner_email            = var.owner_email
  project_name           = var.project_name
  cost_center            = var.cost_center
  business_unit          = var.business_unit
  department             = var.department
  criticality            = "critical"
  infrastructure_version = var.infrastructure_version
  
  additional_tags = {
    Environment_Type = "production"
    Compliance      = "sox-required"
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

resource "aws_subnet" "calavia_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.calavia_vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(module.tags.tags, {
    Name      = "calavia-subnet-production-${count.index}"
    Component = "networking"
    Purpose   = "kubernetes-subnet-${count.index}"
    SubnetType = "private"
    AvailabilityZone = element(var.availability_zones, count.index)
  })
}

resource "aws_eks_cluster" "calavia_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  
  vpc_config {
    subnet_ids = aws_subnet.calavia_subnet[*].id
  }

  tags = merge(module.tags.tags, {
    Name      = var.cluster_name
    Component = "container-orchestration"
    Purpose   = "kubernetes-cluster"
    KubernetesVersion = "1.27"
  })

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
}

resource "aws_iam_role" "eks_role" {
  name = "calavia-eks-role-production"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
      Sid = ""
    }]
  })

  tags = merge(module.tags.tags, {
    Name      = "calavia-eks-role-production"
    Component = "iam"
    Purpose   = "eks-cluster-service-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_eks_node_group" "calavia_node_group" {
  cluster_name    = aws_eks_cluster.calavia_eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = aws_subnet.calavia_subnet[*].id
  
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = merge(module.tags.tags, {
    Name           = "${var.cluster_name}-node-group"
    Component      = "compute"
    Purpose        = "kubernetes-worker-nodes"
    InstanceType   = var.node_instance_type
    AutoScaling    = "enabled"
  })

  depends_on = [aws_eks_cluster.calavia_eks]
}

resource "aws_iam_role" "eks_node_role" {
  name = "calavia-eks-node-role-production"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Effect = "Allow"
      Sid = ""
    }]
  })

  tags = merge(module.tags.tags, {
    Name      = "calavia-eks-node-role-production"
    Component = "iam"
    Purpose   = "eks-node-group-service-role"
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_db_instance" "calavia_postgres" {
  identifier                = "calavia-postgres-production"
  engine                   = "postgres"
  instance_class           = var.postgres_instance_type
  allocated_storage        = 20
  username                 = var.db_username
  password                 = var.db_password
  db_name                  = "games"
  backup_retention_period  = 7
  vpc_security_group_ids   = [aws_security_group.calavia_db_sg.id]
  
  # Configuración específica para producción
  multi_az                 = true
  storage_encrypted        = true
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  
  # Prevenir destrucción accidental
  deletion_protection     = true
  skip_final_snapshot     = false
  final_snapshot_identifier = "calavia-postgres-production-final-snapshot"

  tags = merge(module.tags.tags, {
    Name              = "calavia-postgres-production"
    Component         = "database"
    Purpose           = "primary-game-database"
    Engine            = "postgresql"
    EngineVersion     = "14.9"
    BackupRetention   = "7-days"
    MultiAZ           = "true"
    StorageEncrypted  = "true"
    MaintenanceWindow = "Sunday-04:00"
    ReservedInstance  = "candidate"
  })
}

resource "aws_elasticache_cluster" "calavia_redis" {
  cluster_id           = "calavia-redis-production"
  engine              = "redis"
  node_type           = var.redis_instance_type
  num_cache_nodes     = 1
  parameter_group_name = "default.redis7"
  port                = 6379
  subnet_group_name   = aws_elasticache_subnet_group.calavia_redis_subnet_group.name
  security_group_ids  = [aws_security_group.calavia_redis_sg.id]
  
  tags = merge(module.tags.tags, {
    Name              = "calavia-redis-production"
    Component         = "cache"
    Purpose           = "session-cache"
    Engine            = "redis"
    EngineVersion     = "7.0"
    ReservedInstance  = "candidate"
  })
}

resource "aws_elasticache_subnet_group" "calavia_redis_subnet_group" {
  name       = "calavia-redis-subnet-group-production"
  subnet_ids = aws_subnet.calavia_subnet[*].id

  tags = merge(module.tags.tags, {
    Name      = "calavia-redis-subnet-group-production"
    Component = "networking"
    Purpose   = "redis-subnet-group"
  })
}

resource "aws_security_group" "calavia_db_sg" {
  name        = "calavia-db-sg-production"
  description = "Security group for PostgreSQL database"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.calavia_eks_sg.id]
    description     = "PostgreSQL access from EKS cluster"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(module.tags.tags, {
    Name      = "calavia-db-sg-production"
    Component = "security"
    Purpose   = "database-security-group"
    Protocol  = "postgresql"
  })
}

resource "aws_security_group" "calavia_redis_sg" {
  name        = "calavia-redis-sg-production"
  description = "Security group for Redis cache"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.calavia_eks_sg.id]
    description     = "Redis access from EKS cluster"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
    description = "All outbound traffic"
  }

  tags = merge(module.tags.tags, {
    Name      = "calavia-redis-sg-production"
    Component = "security"
    Purpose   = "cache-security-group"
    Protocol  = "redis"
  })
}

resource "aws_security_group" "calavia_eks_sg" {
  name        = "calavia-eks-sg-production"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access to EKS API server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(module.tags.tags, {
    Name      = "calavia-eks-sg-production"
    Component = "security"
    Purpose   = "kubernetes-cluster-security-group"
    Protocol  = "https"
  })
}

module "eks" {
  source = "../modules/eks"
  cluster_name = var.cluster_name
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
}

module "rds_postgres" {
  source = "../modules/rds-postgres"
  db_username = var.db_username
  db_password = var.db_password
  db_name = var.db_name
}

module "elasticache_redis" {
  source = "../modules/elasticache-redis"
}

module "security" {
  source = "../modules/security"
}

module "monitoring" {
  source = "../modules/monitoring"
}

module "alb_ingress" {
  source = "../modules/alb-ingress"
}

module "external_dns" {
  source = "../modules/external-dns"
}

module "cert_manager" {
  source = "../modules/cert-manager"
}