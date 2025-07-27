# VPC Module for Calavia EKS Infrastructure

This module is responsible for creating the necessary Virtual Private Cloud (VPC) infrastructure for the Calavia EKS cluster. It includes the configuration of subnets, route tables, and security groups to ensure a secure and efficient networking environment.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "vpc" {
  source = "../modules/vpc"

  # Required variables
  cidr_block = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  # Optional variables
  tags = {
    Name = "calavia-vpc"
  }
}
```

## Inputs

| Name                | Description                                   | Type          | Default         |
|---------------------|-----------------------------------------------|---------------|------------------|
| `cidr_block`        | The CIDR block for the VPC                    | `string`      | n/a              |
| `availability_zones`| List of availability zones for subnets        | `list(string)`| n/a              |
| `tags`              | A map of tags to assign to the resources      | `map(string)` | `{}`             |

## Outputs

| Name                | Description                                   |
|---------------------|-----------------------------------------------|
| `vpc_id`            | The ID of the created VPC                     |
| `public_subnets`    | List of public subnet IDs                      |
| `private_subnets`   | List of private subnet IDs                     |

## Security Considerations

Ensure that the security groups and network ACLs are configured to allow only the necessary traffic to and from the resources within the VPC. This module provides a foundation for a secure networking environment for your EKS cluster.

## License

This module is licensed under the MIT License. See the LICENSE file for more details.