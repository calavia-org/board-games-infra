resource "aws_db_instance" "postgres" {
  identifier              = var.db_identifier
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type           = var.storage_type
  username               = var.username
  password               = var.password
  db_name                = var.db_name
  skip_final_snapshot    = false
  final_snapshot_identifier = "${var.db_identifier}-final-snapshot"
  backup_retention_period = var.backup_retention_period
  vpc_security_group_ids  = [var.security_group_id]
  db_subnet_group_name    = var.db_subnet_group_name

  tags = {
    Name = var.db_identifier
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_instance_id" {
  value = aws_db_instance.postgres.id
}