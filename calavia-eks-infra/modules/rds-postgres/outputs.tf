output "db_instance_endpoint" {
  value = aws_db_instance.postgres_instance.endpoint
}

output "db_instance_port" {
  value = aws_db_instance.postgres_instance.port
}

output "db_instance_identifier" {
  value = aws_db_instance.postgres_instance.id
}

output "db_instance_arn" {
  value = aws_db_instance.postgres_instance.arn
}