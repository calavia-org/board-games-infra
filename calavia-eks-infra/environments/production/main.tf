resource "aws_vpc" "calavia_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "calavia-vpc"
  }
}

resource "aws_subnet" "calavia_subnet" {
  count = var.subnet_count
  vpc_id = aws_vpc.calavia_vpc.id
  cidr_block = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "calavia-subnet-${count.index}"
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
  name = "calavia-eks-role"

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

  depends_on = [aws_eks_cluster.calavia_eks]
}

resource "aws_iam_role" "eks_node_role" {
  name = "calavia-eks-node-role"

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
  identifier = "calavia-postgres"
  engine = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = var.db_username
  password = var.db_password
  db_name = "games"
  backup_retention_period = 7
  vpc_security_group_ids = [aws_security_group.calavia_db_sg.id]

  tags = {
    Name = "calavia-postgres"
  }
}

resource "aws_elasticache_cluster" "calavia_redis" {
  cluster_id = "calavia-redis"
  engine = "redis"
  node_type = "cache.t3.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.redis3.2"
  port = 6379
  subnet_group_name = aws_elasticache_subnet_group.calavia_redis_subnet_group.name

  tags = {
    Name = "calavia-redis"
  }
}

resource "aws_elasticache_subnet_group" "calavia_redis_subnet_group" {
  name = "calavia-redis-subnet-group"
  subnet_ids = aws_subnet.calavia_subnet[*].id

  tags = {
    Name = "calavia-redis-subnet-group"
  }
}

resource "aws_security_group" "calavia_db_sg" {
  name        = "calavia-db-sg"
  description = "Allow access to the database"
  vpc_id     = aws_vpc.calavia_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.calavia_eks_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "calavia_eks_sg" {
  name        = "calavia-eks-sg"
  description = "Allow access to the EKS cluster"
  vpc_id     = aws_vpc.calavia_vpc.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  subnet_count = var.subnet_count
  subnet_cidrs = var.subnet_cidrs
  availability_zones = var.availability_zones
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