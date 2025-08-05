# Calavia EKS Infrastructure 🎮

[![Terraform](https://img.shields.io/badge/Terraform-1.8.5-purple.svg)](https://terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EKS_1.31-orange.svg)](https://aws.amazon.com/eks/)
[![Cost](https://img.shields.io/badge/Cost-Optimized-green.svg)](../CHANGELOG.md)

> **Infraestructura Terraform para clúster EKS** diseñada para partidas distribuidas multijugador en tiempo real. Optimizada para costes, seguridad y escalabilidad.

## 🏗️ Arquitectura de Infraestructura

### 📦 Módulos Principales

| Módulo | Propósito | Recursos Clave |
|--------|-----------|----------------|
| **🌐 VPC** | Red base multi-AZ | Subnets públicas/privadas/database |
| **☸️ EKS** | Cluster Kubernetes | Worker nodes ARM64, Auto-scaling |
| **🗄️ RDS PostgreSQL** | Base de datos principal | Backup automático, Multi-AZ |
| **🔄 ElastiCache Redis** | Cache en memoria | Session store, Game state |
| **🔒 Security** | Políticas y permisos | IAM roles, Security groups |
| **📊 Monitoring** | Observabilidad | CloudWatch, Alertas |
| **🌍 External DNS** | Gestión DNS | Route53 automático |
| **🔐 Cert Manager** | Certificados SSL | Let's Encrypt automático |
| **⚖️ ALB Ingress** | Load balancer | Application Load Balancer |

### 🏢 Entornos

| Entorno | Configuración | Presupuesto Mensual | Estado |
|---------|---------------|---------------------|--------|
| **🟡 Staging** | t4g.nano (1 nodo) | ~$55/mes | ✅ Activo |
| **🟢 Production** | t4g.small (2-4 nodos) | ~$320/mes | ✅ Activo |

## Requisitos

- Tener una cuenta de AWS con permisos adecuados para crear recursos.
- Tener instalado Terraform y configurado para usar AWS.
- Acceso a Terraform Cloud para aplicar los planes de infraestructura.

## Uso

1. Clona el repositorio.
2. Navega a la carpeta del entorno deseado (`production` o `staging`).
3. Configura las variables necesarias en los archivos `variables.tf`.
4. Inicializa Terraform:

   ```
   terraform init
   ```

5. Aplica la configuración:

   ```
   terraform apply
   ```

## Monitoreo y Alertas

El clúster está configurado con kube-Prometheus stack para monitoreo y alertas, con retención de datos de 3 días en producción y 1 día en staging.

## Seguridad

Se implementan políticas de seguridad estrictas y se utiliza Cert-Manager para la gestión de certificados, asegurando que todas las aplicaciones desplegadas tengan certificados válidos y auto-renovables.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request para discutir cambios o mejoras.

## Licencia

Este proyecto está bajo la licencia MIT.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | n/a |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | n/a |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | n/a |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [Terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [AWS](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [Kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [TLS](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [ALB\_Ingress](#module\_alb\_ingress) | ./modules/ALB-Ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [EKS](#module\_eks) | ./modules/EKS | n/a |
| <a name="module_elasticache_redis"></a> [ElastiCache\_Redis](#module\_elasticache\_redis) | ./modules/ElastiCache-Redis | n/a |
| <a name="module_external_dns"></a> [external\_DNS](#module\_external\_dns) | ./modules/external-DNS | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [RDS\_postgres](#module\_rds\_postgres) | ./modules/RDS-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [VPC](#module\_vpc) | ./modules/VPC | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [AWS\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_DNS](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [Redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [EKS\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [EKS\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [RDS\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [Redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [VPC\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.24 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_ingress"></a> [alb\_ingress](#module\_alb\_ingress) | ./modules/alb-ingress | n/a |
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./modules/cert-manager | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/eks | n/a |
| <a name="module_elasticache_redis"></a> [elasticache\_redis](#module\_elasticache\_redis) | ./modules/elasticache-redis | n/a |
| <a name="module_external_dns"></a> [external\_dns](#module\_external\_dns) | ./modules/external-dns | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_rds_postgres"></a> [rds\_postgres](#module\_rds\_postgres) | ./modules/rds-postgres | n/a |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | ./modules/secrets-manager | n/a |
| <a name="module_security"></a> [security](#module\_security) | ./modules/security | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.grafana_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.postgres_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.redis_auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Lista de zonas de disponibilidad para el clúster | `list(string)` | <pre>[<br>  "us-west-2a",<br>  "us-west-2b",<br>  "us-west-2c"<br>]</pre> | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Región de AWS donde se desplegará el clúster | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Nombre del clúster EKS | `string` | n/a | yes |
| <a name="input_db_password"></a> [db\_password](#input\_db\_password) | Contraseña para la base de datos | `string` | `null` | no |
| <a name="input_db_username"></a> [db\_username](#input\_db\_username) | Nombre de usuario para la base de datos | `string` | `"postgres"` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Número deseado de nodos en el clúster | `number` | `3` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Nombre de dominio principal para la aplicación | `string` | `"boardgames.example.com"` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Habilitar Cert-Manager | `bool` | `true` | no |
| <a name="input_enable_external_dns"></a> [enable\_external\_dns](#input\_enable\_external\_dns) | Habilitar External DNS | `bool` | `true` | no |
| <a name="input_enable_notifications"></a> [enable\_notifications](#input\_enable\_notifications) | Habilitar notificaciones para rotación de secretos | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Entorno de despliegue (staging/production) | `string` | n/a | yes |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Tipos de instancia para los nodos del clúster - Graviton3 ARM64 | `list(string)` | <pre>[<br>  "m7g.large",<br>  "m7g.xlarge",<br>  "m6g.large"<br>]</pre> | no |
| <a name="input_lets_encrypt_email"></a> [lets\_encrypt\_email](#input\_lets\_encrypt\_email) | Email para certificados Let's Encrypt | `string` | `"admin@example.com"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Número máximo de nodos en el clúster | `number` | `10` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Número mínimo de nodos en el clúster | `number` | `1` | no |
| <a name="input_monitoring_retention_days"></a> [monitoring\_retention\_days](#input\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo | `number` | `3` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address para notificaciones de rotación | `string` | `"devops@example.com"` | no |
| <a name="input_postgres_db_name"></a> [postgres\_db\_name](#input\_postgres\_db\_name) | Nombre de la base de datos PostgreSQL | `string` | `"boardgames"` | no |
| <a name="input_postgres_instance_type"></a> [postgres\_instance\_type](#input\_postgres\_instance\_type) | Tipo de instancia para PostgreSQL - Graviton2 ARM64 | `string` | `"db.t4g.micro"` | no |
| <a name="input_postgres_storage_size"></a> [postgres\_storage\_size](#input\_postgres\_storage\_size) | Tamaño de almacenamiento para PostgreSQL en GB | `number` | `20` | no |
| <a name="input_redis_node_type"></a> [redis\_node\_type](#input\_redis\_node\_type) | Tipo de nodo para Redis - Graviton2 ARM64 | `string` | `"cache.t4g.micro"` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | URL del webhook de Slack para notificaciones | `string` | `""` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Indica si se deben usar instancias spot | `bool` | `true` | no |
| <a name="input_staging_monitoring_retention_days"></a> [staging\_monitoring\_retention\_days](#input\_staging\_monitoring\_retention\_days) | Días de retención para las métricas de monitoreo en staging | `number` | `1` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR de la VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#output\_eks\_cluster\_certificate\_authority\_data) | Certificate authority data for the EKS cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | Endpoint URL of the EKS cluster |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Name of the EKS cluster |
| <a name="output_grafana_admin_secret_arn"></a> [grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnet IDs |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnet IDs |
| <a name="output_rds_postgres_endpoint"></a> [rds\_postgres\_endpoint](#output\_rds\_postgres\_endpoint) | RDS PostgreSQL endpoint |
| <a name="output_redis_auth_secret_arn"></a> [redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of all secret names for reference |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | ARN of the KMS key used for secrets encryption |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | ID of the VPC |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
