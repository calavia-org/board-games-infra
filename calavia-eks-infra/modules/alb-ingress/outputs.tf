output "aws_load_balancer_controller_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}

output "helm_release_status" {
  description = "Status of the Helm release"
  value       = helm_release.aws_load_balancer_controller.status
}
