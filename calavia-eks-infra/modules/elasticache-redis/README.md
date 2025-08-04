# Documentación del Módulo ElastiCache Redis

Este módulo de Terraform configura una instancia de ElastiCache para Redis en AWS. ElastiCache es un servicio de almacenamiento en caché en memoria que mejora el rendimiento de las aplicaciones al permitir un acceso rápido a los datos.

## Requisitos

- Tener configurado el proveedor de AWS en Terraform.
- Permisos adecuados para crear recursos de ElastiCache en la cuenta de AWS.

## Variables

Este módulo utiliza las siguientes variables:

- `redis_cluster_name`: Nombre del clúster de Redis.
- `redis_node_type`: Tipo de instancia para los nodos de Redis.
- `redis_engine_version`: Versión del motor de Redis.
- `redis_num_nodes`: Número de nodos en el clúster.
- `vpc_id`: ID de la VPC donde se desplegará ElastiCache.
- `subnet_ids`: Lista de IDs de subredes donde se desplegarán los nodos de Redis.

## Salidas

El módulo proporciona las siguientes salidas:

- `redis_endpoint`: Endpoint del clúster de Redis.
- `redis_primary_endpoint`: Endpoint del nodo primario de Redis.

## Uso

Para utilizar este módulo, puedes incluirlo en tu archivo de configuración de Terraform de la siguiente manera:

```hcl
module "elasticache_redis" {
  source              = "../modules/elasticache-redis"
  redis_cluster_name  = "mi-cluster-redis"
  redis_node_type     = "cache.t3.micro"
  redis_engine_version = "6.x"
  redis_num_nodes     = 1
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
}
```

## Consideraciones

- Asegúrate de que las subredes especificadas sean privadas y estén configuradas para permitir el acceso desde el clúster de EKS.
- Revisa las políticas de seguridad para garantizar que el acceso a Redis esté restringido a las aplicaciones que lo necesiten.

## Licencia

Este módulo se distribuye bajo la Licencia MIT.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Parameter group name | `string` | `"default.redis7"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Parameter group name | `string` | `"default.redis7"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Parameter group name | `string` | `"default.redis7"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.7.1 |
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.redis_slow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_parameter_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.redis_service_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda_redis_rotation_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_redis_rotation_basic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.redis_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.Redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.secrets_manager_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.redis_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.redis_token_rotation](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_limit"></a> [backup\_retention\_limit](#input\_backup\_retention\_limit) | Number of days to retain backups | `number` | `5` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | Daily time range for backups | `string` | `"03:00-05:00"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_enable_encryption_at_rest"></a> [enable\_encryption\_at\_rest](#input\_enable\_encryption\_at\_rest) | Enable encryption at rest | `bool` | `true` | no |
| <a name="input_enable_encryption_in_transit"></a> [enable\_encryption\_in\_transit](#input\_enable\_encryption\_in\_transit) | Enable encryption in transit | `bool` | `true` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Weekly time range for maintenance | `string` | `"sun:05:00-sun:09:00"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type for ElastiCache Redis | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | Number of cache nodes | `number` | `1` | no |
| <a name="input_port"></a> [port](#input\_port) | Port for Redis | `number` | `6379` | no |
| <a name="input_redis_version"></a> [Redis\_version](#input\_redis\_version) | Redis version | `string` | `"7.0"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for ElastiCache | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS Key ARN used for encryption |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS Key ID used for encryption |
| <a name="output_redis_cluster_id"></a> [Redis\_cluster\_id](#output\_redis\_cluster\_id) | ID of the Redis replication group |
| <a name="output_redis_port"></a> [Redis\_port](#output\_redis\_port) | Redis port |
| <a name="output_redis_primary_endpoint"></a> [Redis\_primary\_endpoint](#output\_redis\_primary\_endpoint) | Redis primary endpoint |
| <a name="output_redis_reader_endpoint"></a> [Redis\_reader\_endpoint](#output\_redis\_reader\_endpoint) | Redis reader endpoint |
| <a name="output_redis_replication_group_id"></a> [Redis\_replication\_group\_id](#output\_redis\_replication\_group\_id) | ElastiCache Redis replication group ID |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | ARN of the secret containing Redis credentials |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | Name of the secret containing Redis credentials |
| <a name="output_service_account_role_arn"></a> [service\_account\_role\_arn](#output\_service\_account\_role\_arn) | ARN of the IAM role for the Kubernetes service account |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
