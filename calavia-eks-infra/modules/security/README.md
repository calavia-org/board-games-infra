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