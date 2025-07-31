output "external_dns_role_arn" {
  description = "ARN of the IAM role for External DNS"
  value       = aws_iam_role.external_dns.arn
}

output "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "helm_release_status" {
  description = "Status of the Helm release"
  value       = helm_release.external_dns.status
}
