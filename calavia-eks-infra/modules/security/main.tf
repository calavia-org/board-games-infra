resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

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

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

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
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

# Security Group para el EKS Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  # Permitir comunicación interna del cluster
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  # Permitir HTTPS desde los nodos trabajadores
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  # Permitir acceso desde CIDRs autorizados si se especifican
  dynamic "ingress" {
    for_each = length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-cluster-sg"
    Type = "EKS-Control-Plane"
  })
}

# Security Group para los nodos trabajadores de EKS
resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # Permitir comunicación interna del cluster
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  # Permitir comunicación con el control plane
  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  # Permitir comunicación del control plane con kubelet
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodes-sg"
    Type = "EKS-Worker-Nodes"
  })
}

# Security Group para RDS PostgreSQL
resource "aws_security_group" "rds" {
  name        = "${var.cluster_name}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  # Permite conexiones PostgreSQL desde los nodos EKS
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  # Permite conexiones desde la VPC para troubleshooting
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-rds-sg"
    Type = "RDS-PostgreSQL"
  })
}

# Security Group para ElastiCache Redis
resource "aws_security_group" "redis" {
  name        = "${var.cluster_name}-redis-sg"
  description = "Security group for ElastiCache Redis"
  vpc_id      = var.vpc_id

  # Permite conexiones Redis desde los nodos EKS
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  # Permite conexiones desde la VPC para troubleshooting
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-sg"
    Type = "ElastiCache-Redis"
  })
}

# Security Group para ALB
resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Permite tráfico HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite tráfico HTTPS
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

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-alb-sg"
    Type = "Application-Load-Balancer"
  })
}

# Network ACL para subnets de base de datos (seguridad adicional)
resource "aws_network_acl" "database" {
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Permitir tráfico desde la VPC
  ingress {
    rule_no    = 100
    protocol   = "tcp"
    from_port  = 5432
    to_port    = 5432
    cidr_block = var.vpc_cidr
    action     = "allow"
  }

  ingress {
    rule_no    = 110
    protocol   = "tcp"
    from_port  = 6379
    to_port    = 6379
    cidr_block = var.vpc_cidr
    action     = "allow"
  }

  # Permitir respuestas de conexiones salientes
  ingress {
    rule_no    = 120
    protocol   = "tcp"
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    from_port  = 0
    to_port    = 0
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-database-nacl"
    Type = "Database-Network-ACL"
  })
}

resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }

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

resource "aws_security_group_rule" "allow_eks_cluster_to_nodes" {
  type              = "ingress"
  from_port        = 0
  to_port          = 65535
  protocol         = "tcp"
  security_group_id = aws_security_group.eks_node_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

resource "aws_security_group_rule" "allow_nodes_to_cluster" {
  type              = "ingress"
  from_port        = 0
  to_port          = 65535
  protocol         = "tcp"
  security_group_id = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_node_sg.id
}