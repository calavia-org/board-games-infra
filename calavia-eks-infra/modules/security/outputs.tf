output "eks_cluster_sg_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "ID of the EKS nodes security group"
  value       = aws_security_group.eks_nodes.id
}

output "rds_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "redis_sg_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.redis.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = aws_network_acl.database.id
}
