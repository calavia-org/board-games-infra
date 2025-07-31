output "cert_manager_role_arn" {
  description = "ARN of the IAM role for Cert-Manager"
  value       = aws_iam_role.cert_manager.arn
}

output "helm_release_status" {
  description = "Status of the Helm release"
  value       = helm_release.cert_manager.status
}

output "letsencrypt_staging_issuer" {
  description = "Name of the Let's Encrypt staging cluster issuer"
  value       = "letsencrypt-staging"
}

output "letsencrypt_production_issuer" {
  description = "Name of the Let's Encrypt production cluster issuer"
  value       = "letsencrypt-production"
}
