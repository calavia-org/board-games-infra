# RDS PostgreSQL Module

This module provisions an Amazon RDS PostgreSQL database instance within a specified VPC. It includes configurations for security, backups, and parameter groups to ensure optimal performance and security.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "rds_postgres" {
  source              = "../modules/rds-postgres"
  db_instance_class   = var.db_instance_class
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  vpc_security_group_ids = var.vpc_security_group_ids
  allocated_storage    = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  multi_az            = var.multi_az
  tags                = var.tags
}
```

## Inputs

| Name                        | Description                                         | Type     | Default | Required |
|-----------------------------|-----------------------------------------------------|----------|---------|----------|
| db_instance_class           | The instance class for the RDS instance             | string   | `db.t3.micro` | no       |
| db_name                     | The name of the database to create                   | string   |         | yes      |
| username                    | The username for the database                         | string   |         | yes      |
| password                    | The password for the database                         | string   |         | yes      |
| vpc_security_group_ids      | List of VPC security group IDs                       | list     |         | yes      |
| allocated_storage            | The allocated storage size in GB                      | number   | `20`    | no       |
| backup_retention_period     | The number of days to retain backups                 | number   | `7`     | no       |
| multi_az                    | Whether to create a Multi-AZ deployment              | bool     | `false` | no       |
| tags                        | A map of tags to assign to the resource              | map      | `{}`    | no       |

## Outputs

| Name                | Description                                   |
|---------------------|-----------------------------------------------|
| db_instance_endpoint | The connection endpoint for the database      |
| db_instance_id      | The ID of the RDS instance                    |
| db_instance_arn     | The ARN of the RDS instance                   |

## Example

Here is an example of how to use the RDS PostgreSQL module:

```hcl
module "rds_postgres" {
  source              = "../modules/rds-postgres"
  db_instance_class   = "db.t3.medium"
  db_name             = "mydatabase"
  username            = "admin"
  password            = "securepassword"
  vpc_security_group_ids = ["sg-0123456789abcdef0"]
  allocated_storage    = 20
  backup_retention_period = 7
  multi_az            = true
  tags                = {
    Name = "MyPostgresDB"
  }
}
```

## Notes

- Ensure that the VPC and security groups are properly configured to allow access to the RDS instance.
- The password must meet the RDS password policy requirements.
- Backups are enabled by default with a retention period of 7 days, which can be adjusted as needed.