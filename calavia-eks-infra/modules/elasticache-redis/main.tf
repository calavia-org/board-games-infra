resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_id
  engine              = "redis"
  node_type           = var.node_type
  number_cache_nodes  = var.number_cache_nodes
  parameter_group_name = var.parameter_group_name
  port                = var.port
  subnet_group_name   = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids  = [aws_security_group.redis_sg.id]

  tags = {
    Name = var.cluster_id
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.cluster_id}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.cluster_id}-subnet-group"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.cluster_id}-sg"
  description = "Security group for Redis ElastiCache"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_id}-sg"
  }
}