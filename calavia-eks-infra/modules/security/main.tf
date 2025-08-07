terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Security Groups para la infraestructura de juegos de mesa
# Incluye security groups para EKS, RDS, ElastiCache, ALB y componentes de monitoreo

# Security Group para Application Load Balancer
resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Permite tráfico HTTP desde internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from internet"
  }

  # Permite tráfico HTTPS desde internet
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from internet"
  }

  # Permite todo el tráfico saliente a VPC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All outbound traffic to VPC"
  }

  # Permite HTTPS outbound para ALB health checks
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outbound for health checks"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-alb-sg"
    Type = "ALB"
  })
}

# Security Group para el EKS Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  # Permitir comunicación interna del cluster
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Self communication"
  }

  # Permitir acceso desde CIDRs autorizados si se especifican
  dynamic "ingress" {
    for_each = length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
      description = "HTTPS from authorized CIDRs"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All outbound traffic to VPC"
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
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Self communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "VPC outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-nodes-sg"
    Type = "EKS-Worker-Nodes"
  })
}

# Reglas separadas para evitar dependencias circulares entre EKS control plane y nodos
resource "aws_security_group_rule" "cluster_ingress_nodes_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_nodes.id
  security_group_id        = aws_security_group.eks_cluster.id
  description              = "Allow HTTPS from worker nodes to control plane"
}

resource "aws_security_group_rule" "nodes_ingress_cluster_kubelet" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_nodes.id
  description              = "Allow kubelet API from control plane"
}

resource "aws_security_group_rule" "nodes_ingress_cluster_coredns" {
  type                     = "ingress"
  from_port                = 53
  to_port                  = 53
  protocol                 = "udp"
  source_security_group_id = aws_security_group.eks_cluster.id
  security_group_id        = aws_security_group.eks_nodes.id
  description              = "Allow CoreDNS from control plane"
}

resource "aws_security_group_rule" "nodes_ingress_alb" {
  type                     = "ingress"
  from_port                = 30000
  to_port                  = 32767
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = aws_security_group.eks_nodes.id
  description              = "Allow NodePort services from ALB"
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
    description     = "PostgreSQL from EKS nodes"
  }

  # Permite conexiones desde la VPC para troubleshooting
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "PostgreSQL from VPC CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All outbound traffic within VPC"
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
    description     = "Redis from EKS nodes"
  }

  # Permite conexiones desde la VPC para troubleshooting
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Redis from VPC CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All outbound traffic within VPC"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-redis-sg"
    Type = "ElastiCache-Redis"
  })
}

# Security Group para componentes de monitoreo (Prometheus, Grafana)
resource "aws_security_group" "monitoring" {
  name        = "${var.cluster_name}-monitoring-sg"
  description = "Security group for monitoring components"
  vpc_id      = var.vpc_id

  # Prometheus metrics scraping
  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "Prometheus from EKS nodes"
  }

  # Grafana web interface
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "Grafana from ALB"
  }

  # Node Exporter metrics
  ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "Node Exporter from EKS nodes"
  }

  # AlertManager
  ingress {
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "AlertManager from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "VPC outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-monitoring-sg"
    Type = "Monitoring"
  })
}

# Security Group para VPC Endpoints (AWS Secrets Manager, etc.)
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.cluster_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  # HTTPS desde los nodos EKS para acceder a VPC endpoints
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
    description     = "HTTPS from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
    description = "All outbound traffic within VPC"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-vpc-endpoints-sg"
    Type = "VPC-Endpoints"
  })
}

# Security Group para Lambda functions (rotación de secretos)
resource "aws_security_group" "lambda" {
  name        = "${var.cluster_name}-lambda-sg"
  description = "Security group for Lambda functions"
  vpc_id      = var.vpc_id

  # Permitir acceso a RDS para rotación de credenciales
  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.rds.id]
    description     = "PostgreSQL to RDS"
  }

  # Permitir acceso a Redis para rotación de credenciales
  egress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.redis.id]
    description     = "Redis to ElastiCache"
  }

  # Permitir acceso HTTPS a servicios AWS
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS to AWS services"
  }

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-lambda-sg"
    Type = "Lambda-Functions"
  })
}

# Regla para permitir que Lambda acceda a RDS
resource "aws_security_group_rule" "rds_ingress_lambda" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
  security_group_id        = aws_security_group.rds.id
  description              = "PostgreSQL from Lambda functions"
}

# Regla para permitir que Lambda acceda a Redis
resource "aws_security_group_rule" "redis_ingress_lambda" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda.id
  security_group_id        = aws_security_group.redis.id
  description              = "Redis from Lambda functions"
}
