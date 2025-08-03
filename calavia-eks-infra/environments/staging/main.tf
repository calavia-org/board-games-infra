# Centralized tagging module for staging
module "tags" {
  source = "../../modules/tags"
  
  environment             = "staging"
  owner_email            = var.owner_email
  project_name           = var.project_name
  cost_center            = var.cost_center
  business_unit          = var.business_unit
  department             = var.department
  criticality            = "medium"
  infrastructure_version = var.infrastructure_version
  
  additional_tags = {
    Environment_Type    = "staging"
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

resource "aws_subnet" "calavia_subnet" {
  count = var.subnet_count
  vpc_id = aws_vpc.calavia_vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "calavia-subnet-staging-${count.index}"
  }
}

resource "aws_eks_cluster" "calavia_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = aws_subnet.calavia_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy]
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
        Sid = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_db_instance" "calavia_postgres" {
  identifier = "calavia-postgres-staging"
  engine     = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "calavia-postgres-staging"
  }
}

resource "aws_elasticache_cluster" "calavia_redis" {
  cluster_id = "calavia-redis-staging"
  engine = "redis"
  node_type = "cache.t3.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.redis3.2"
  port = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    Name = "calavia-redis-staging"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "calavia-redis-subnet-group-staging"
  subnet_ids = aws_subnet.calavia_subnet[*].id

  tags = {
    Name = "calavia-redis-subnet-group-staging"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_sg.id]
  }

  tags = {
    Name = "calavia-db-sg-staging"
  }
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "calavia-eks-sg-staging"
  }
}

output "cluster_endpoint" {
  value = aws_eks_cluster.calavia_eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.calavia_eks.name
}

output "db_instance_endpoint" {
  value = aws_db_instance.calavia_postgres.endpoint
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.calavia_redis.configuration_endpoint
}