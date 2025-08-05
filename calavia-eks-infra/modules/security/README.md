# Security Module for Calavia EKS Infrastructure

This module is responsible for implementing the necessary security policies for the EKS cluster and the associated network. It ensures that the infrastructure adheres to best practices for security and compliance.

## Overview

The security module includes configurations for:

- IAM roles and policies for the EKS cluster.
- Security groups to control inbound and outbound traffic.
- Network policies to restrict communication between pods.
- Integration with AWS services for enhanced security.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "security" {
  source = "../modules/security"

  # Add required variables here
}
```

## Variables

This module requires the following variables:

- `vpc_id`: The ID of the VPC where the EKS cluster is deployed.
- `cluster_name`: The name of the EKS cluster.
- `allowed_cidrs`: A list of CIDR blocks that are allowed to access the cluster.

## Outputs

The module will output the following:

- `iam_role_arn`: The ARN of the IAM role created for the EKS cluster.
- `security_group_id`: The ID of the security group associated with the cluster.

## Security Best Practices

- Regularly review IAM policies and roles to ensure least privilege access.
- Implement logging and monitoring for security-related events.
- Use security groups to restrict access to only necessary ports and IP ranges.
- Keep your Terraform configurations and modules up to date with the latest security practices.

## License

This module is licensed under the MIT License. See the LICENSE file for more information.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_ingress_nodes_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDR blocks allowed to access the cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Admin password for Grafana | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to security resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_sg_id"></a> [ALB\_sg\_id](#output\_alb\_sg\_id) | ID of the ALB security group |
| <a name="output_eks_cluster_sg_id"></a> [EKS\_cluster\_sg\_id](#output\_eks\_cluster\_sg\_id) | ID of the EKS cluster security group |
| <a name="output_eks_nodes_sg_id"></a> [EKS\_nodes\_sg\_id](#output\_eks\_nodes\_sg\_id) | ID of the EKS nodes security group |
| <a name="output_rds_sg_id"></a> [RDS\_sg\_id](#output\_rds\_sg\_id) | ID of the RDS security group |
| <a name="output_redis_sg_id"></a> [Redis\_sg\_id](#output\_redis\_sg\_id) | ID of the Redis security group |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_ingress_nodes_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDR blocks allowed to access the cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Admin password for Grafana | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to security resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_sg_id"></a> [ALB\_sg\_id](#output\_alb\_sg\_id) | ID of the ALB security group |
| <a name="output_eks_cluster_sg_id"></a> [EKS\_cluster\_sg\_id](#output\_eks\_cluster\_sg\_id) | ID of the EKS cluster security group |
| <a name="output_eks_nodes_sg_id"></a> [EKS\_nodes\_sg\_id](#output\_eks\_nodes\_sg\_id) | ID of the EKS nodes security group |
| <a name="output_rds_sg_id"></a> [RDS\_sg\_id](#output\_rds\_sg\_id) | ID of the RDS security group |
| <a name="output_redis_sg_id"></a> [Redis\_sg\_id](#output\_redis\_sg\_id) | ID of the Redis security group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ALB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_ingress_nodes_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDR blocks allowed to access the cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Admin password for Grafana | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to security resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_sg_id"></a> [ALB\_sg\_id](#output\_alb\_sg\_id) | ID of the ALB security group |
| <a name="output_eks_cluster_sg_id"></a> [EKS\_cluster\_sg\_id](#output\_eks\_cluster\_sg\_id) | ID of the EKS cluster security group |
| <a name="output_eks_nodes_sg_id"></a> [EKS\_nodes\_sg\_id](#output\_eks\_nodes\_sg\_id) | ID of the EKS nodes security group |
| <a name="output_rds_sg_id"></a> [RDS\_sg\_id](#output\_rds\_sg\_id) | ID of the RDS security group |
| <a name="output_redis_sg_id"></a> [Redis\_sg\_id](#output\_redis\_sg\_id) | ID of the Redis security group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_ingress_nodes_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_ingress_cluster_kubelet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rds_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.redis_ingress_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidrs"></a> [allowed\_cidrs](#input\_allowed\_cidrs) | List of CIDR blocks allowed to access the cluster | `list(string)` | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [grafana\_admin\_password](#input\_grafana\_admin\_password) | Admin password for Grafana | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to security resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_sg_id"></a> [alb\_sg\_id](#output\_alb\_sg\_id) | ID of the ALB security group |
| <a name="output_eks_cluster_sg_id"></a> [eks\_cluster\_sg\_id](#output\_eks\_cluster\_sg\_id) | ID of the EKS cluster security group |
| <a name="output_eks_nodes_sg_id"></a> [eks\_nodes\_sg\_id](#output\_eks\_nodes\_sg\_id) | ID of the EKS nodes security group |
| <a name="output_rds_sg_id"></a> [rds\_sg\_id](#output\_rds\_sg\_id) | ID of the RDS security group |
| <a name="output_redis_sg_id"></a> [redis\_sg\_id](#output\_redis\_sg\_id) | ID of the Redis security group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
