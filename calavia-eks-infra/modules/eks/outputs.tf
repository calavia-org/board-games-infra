output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.this.version
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = var.use_spot_instances ? aws_eks_node_group.spot[0].arn : aws_eks_node_group.on_demand[0].arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = var.use_spot_instances ? aws_eks_node_group.spot[0].status : aws_eks_node_group.on_demand[0].status
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = aws_iam_openid_connect_provider.cluster.arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "node_group_role_arn" {
  value = module.eks.node_group_role_arn
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "redis_endpoint" {
  value = module.elasticache_redis.redis_endpoint
}

output "postgres_endpoint" {
  value = module.rds_postgres.postgres_endpoint
}

output "grafana_url" {
  value = module.monitoring.grafana_url
}