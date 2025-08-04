# production

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
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage_max"></a> [allocated\_storage\_max](#input\_allocated\_storage\_max) | Máximo storage auto-scaling para RDS | `number` | `100` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster - optimizado | `number` | `2` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_enable_performance_insights"></a> [enable\_performance\_insights](#input\_enable\_performance\_insights) | Habilitar Performance Insights (tiene coste adicional) | `bool` | `false` | no |
| <a name="input_enable_spot_instances"></a> [enable\_spot\_instances](#input\_enable\_spot\_instances) | Habilitar instancias spot para ahorrar costes | `bool` | `true` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster - controlado | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster - mínimo para HA | `number` | `2` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en producción | `number` | `3` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Tipo de instancia para los nodos del clúster - Graviton2 ARM64 optimizado para producción | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_instance_type"></a> [Redis\_instance\_type](#input\_redis\_instance\_type) | Tipo de instancia para Redis - Graviton2 ARM64 optimizado para producción | `string` | `"cache.t4g.micro"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_percentage"></a> [spot\_instance\_percentage](#input\_spot\_instance\_percentage) | Porcentaje de instancias spot en el node group | `number` | `50` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage_max"></a> [allocated\_storage\_max](#input\_allocated\_storage\_max) | Máximo storage auto-scaling para RDS | `number` | `100` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster - optimizado | `number` | `2` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_enable_performance_insights"></a> [enable\_performance\_insights](#input\_enable\_performance\_insights) | Habilitar Performance Insights (tiene coste adicional) | `bool` | `false` | no |
| <a name="input_enable_spot_instances"></a> [enable\_spot\_instances](#input\_enable\_spot\_instances) | Habilitar instancias spot para ahorrar costes | `bool` | `true` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster - controlado | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster - mínimo para HA | `number` | `2` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en producción | `number` | `3` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Tipo de instancia para los nodos del clúster - Graviton2 ARM64 optimizado para producción | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_instance_type"></a> [Redis\_instance\_type](#input\_redis\_instance\_type) | Tipo de instancia para Redis - Graviton2 ARM64 optimizado para producción | `string` | `"cache.t4g.micro"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_percentage"></a> [spot\_instance\_percentage](#input\_spot\_instance\_percentage) | Porcentaje de instancias spot en el node group | `number` | `50` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage_max"></a> [allocated\_storage\_max](#input\_allocated\_storage\_max) | Máximo storage auto-scaling para RDS | `number` | `100` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster - optimizado | `number` | `2` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_enable_performance_insights"></a> [enable\_performance\_insights](#input\_enable\_performance\_insights) | Habilitar Performance Insights (tiene coste adicional) | `bool` | `false` | no |
| <a name="input_enable_spot_instances"></a> [enable\_spot\_instances](#input\_enable\_spot\_instances) | Habilitar instancias spot para ahorrar costes | `bool` | `true` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster - controlado | `number` | `4` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster - mínimo para HA | `number` | `2` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en producción | `number` | `3` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | Tipo de instancia para los nodos del clúster - Graviton2 ARM64 optimizado para producción | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_instance_type"></a> [Redis\_instance\_type](#input\_redis\_instance\_type) | Tipo de instancia para Redis - Graviton2 ARM64 optimizado para producción | `string` | `"cache.t4g.micro"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_percentage"></a> [spot\_instance\_percentage](#input\_spot\_instance\_percentage) | Porcentaje de instancias spot en el node group | `number` | `50` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
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
| [aws_cloudwatch_log_group.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.calavia_postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_eks_cluster.calavia_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.calavia_on_demand](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_node_group.calavia_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_elasticache_cluster.calavia_redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_flow_log.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.flow_logs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.flow_logs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.eks_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.registry_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.rds_encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.db_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.redis_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.calavia_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.calavia_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Período de retención de backups en días | `number` | `7` | no |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Unidad de negocio | `string` | `"Gaming-Platform"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | `"calavia-eks-cluster"` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Centro de coste para facturación | `string` | `"CC-001-GAMING"` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Nombre de la base de datos | `string` | `"calavia_production"` | no |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | n/a | yes |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"admin"` | no |
| <a name="input_department"></a> [department](#input\_department) | Departamento responsable | `string` | `"Engineering"` | no |
| <a name="input_enable_multi_az"></a> [enable\_multi\_az](#input\_enable\_multi\_az) | Habilitar Multi-AZ para RDS | `bool` | `false` | no |
| <a name="input_infrastructure_version"></a> [infrastructure\_version](#input\_infrastructure\_version) | Versión de la infraestructura | `string` | `"1.0.0"` | no |
| <a name="input_on_demand_desired_size"></a> [on\_demand\_desired\_size](#input\_on\_demand\_desired\_size) | Número deseado de nodos on-demand | `number` | `1` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Tipo de instancia para nodos on-demand - Graviton2 ARM64 | `string` | `"t4g.small"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Número máximo de nodos on-demand | `number` | `3` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Número mínimo de nodos on-demand | `number` | `1` | no |
| <a name="input_owner_email"></a> [owner\_email](#input\_owner\_email) | Email del equipo/persona responsable | `string` | `"devops@calavia.org"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 optimizado para producción | `string` | `"db.t4g.small"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Nombre del proyecto | `string` | `"board-games"` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de instancia para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Número deseado de nodos spot | `number` | `1` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | Tipos de instancia para nodos spot - Graviton2 ARM64 | `list(string)` | <pre>[<br>  "t4g.small",<br>  "t4g.medium"<br>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Número máximo de nodos spot | `number` | `4` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Número mínimo de nodos spot | `number` | `0` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | Tamaño de almacenamiento RDS en GB - optimizado | `number` | `20` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | Tipo de almacenamiento RDS | `string` | `"gp3"` | no |
| <a name="input_subnet_cidrs"></a> [subnet\_cidrs](#input\_subnet\_cidrs) | CIDR blocks para las subnets | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24",<br>  "10.0.3.0/24"<br>]</pre> | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Número de subnets a crear | `number` | `3` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR block para la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
