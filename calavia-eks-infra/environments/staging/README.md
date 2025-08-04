# staging

<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | ../../modules/tags | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster - reducidas para staging | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups - reducido para staging | `number` | `1` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-staging"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_db"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster - mínimo para staging | `number` | `1` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS - deshabilitado en staging | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Habilitar NAT Gateway - deshabilitado en staging para ahorrar costes | `bool` | `false` | no |
| <a name="input_external_dns_zone"></a> [external\_DNS\_zone](#input\_external\_dns\_zone) | Zona de Route 53 para gestionar DNS | `string` | `"calavia.example.com"` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email para el registro de Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster - limitado para staging | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster - mínimo absoluto | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `1` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Tipo de instancia para los nodos del clúster - usando Graviton2 ARM64 para staging | `string` | `"t4g.nano"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 para mejor rendimiento por euro | `string` | `"db.t4g.micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_instance_type"></a> [Redis\_instance\_type](#input\_redis\_instance\_type) | Tipo de instancia para Redis - Graviton2 ARM64 para mejor eficiencia | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - mínimo para staging | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS - más económico para staging | `string` | `"gp2"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | Lista de CIDRs para las subredes - optimizado para staging | `list(string)` | <pre>[<br>  "10.0.0.0/20",<br>  "10.0.16.0/20"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subredes a crear - reducido para staging | `number` | `2` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | n/a |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | n/a |
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
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | ../../modules/tags | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.redis_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.eks_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster - reducidas para staging | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups - reducido para staging | `number` | `1` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-staging"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_db"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster - mínimo para staging | `number` | `1` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS - deshabilitado en staging | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Habilitar NAT Gateway - deshabilitado en staging para ahorrar costes | `bool` | `false` | no |
| <a name="input_external_dns_zone"></a> [external\_DNS\_zone](#input\_external\_dns\_zone) | Zona de Route 53 para gestionar DNS | `string` | `"calavia.example.com"` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | Email para el registro de Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster - limitado para staging | `number` | `2` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster - mínimo absoluto | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `1` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Tipo de instancia para los nodos del clúster - usando Graviton2 ARM64 para staging | `string` | `"t4g.nano"` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 para mejor rendimiento por euro | `string` | `"db.t4g.micro"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_instance_type"></a> [Redis\_instance\_type](#input\_redis\_instance\_type) | Tipo de instancia para Redis - Graviton2 ARM64 para mejor eficiencia | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - mínimo para staging | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS - más económico para staging | `string` | `"gp2"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | Lista de CIDRs para las subredes - optimizado para staging | `list(string)` | <pre>[<br>  "10.0.0.0/20",<br>  "10.0.16.0/20"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subredes a crear - reducido para staging | `number` | `2` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | n/a |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | n/a |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
