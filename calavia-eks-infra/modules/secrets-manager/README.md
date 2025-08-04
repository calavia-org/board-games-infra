# AWS Secrets Manager Module

Este módulo implementa una gestión completa y automatizada de rotación de contraseñas y tokens para todos los Service Accounts y servicios de la infraestructura de gaming, utilizando AWS Secrets Manager.

## Características Principales

### 🔐 Gestión Completa de Secretos

- **PostgreSQL**: Credenciales de master y usuarios de aplicación
- **Redis**: Auth tokens con rotación automática
- **Grafana**: Credenciales de administrador
- **Service Accounts**: Tokens de Kubernetes con rotación
- **Cifrado**: KMS encryption para todos los secretos

### 🔄 Rotación Automática

- **PostgreSQL**: Rotación cada 30 días (configurable)
- **Redis**: Rotación cada 30 días (configurable)
- **Grafana**: Rotación cada 90 días (configurable)
- **Service Accounts**: Rotación cada 90 días (configurable)
- **Horario**: Ventana de rotación configurable (2-4 AM por defecto)

### 🛡️ Seguridad Avanzada

- **KMS Encryption**: Cifrado con claves gestionadas
- **Replicación**: Backup cross-region automático
- **Acceso Controlado**: IAM roles con permisos mínimos
- **Auditoría**: Logs detallados en CloudWatch
- **Rollback**: Capacidad de rollback automático

## Arquitectura

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   CloudWatch    │    │  Secrets Manager │    │  Lambda Functions│
│   Events        │───▶│  Automatic       │───▶│  Rotation Logic │
│   (Schedule)    │    │  Rotation        │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   KMS Keys      │    │   PostgreSQL     │    │   Redis/EKS     │
│   Encryption    │    │   RDS            │    │   Services      │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Secretos Gestionados

### 1. PostgreSQL Master Credentials

```json
{
  "username": "master_user",
  "password": "auto_generated_secure_password",  # pragma: allowlist secret
  "engine": "postgres",
  "host": "rds-endpoint.amazonaws.com",
  "port": 5432,
  "dbname": "gamedb"
}
```

### 2. PostgreSQL Application User

```json
{
  "username": "app_user",
  "password": "auto_generated_secure_password",  # pragma: allowlist secret
  "engine": "postgres",
  "host": "rds-endpoint.amazonaws.com",
  "port": 5432,
  "dbname": "gamedb",
  "privileges": ["CONNECT", "CREATE", "TEMPORARY"]
}
```

### 3. Redis Auth Token

```json
{
  "auth_token": "auto_generated_64_char_token",
  "host": "redis-endpoint.cache.amazonaws.com",
  "port": 6379
}
```

### 4. Service Account Tokens

```json
{
  "token": "kubernetes_service_account_token",
  "namespace": "monitoring",
  "service_account": "prometheus",
  "cluster_name": "gaming-cluster",
  "rotation_timestamp": 1234567890
}
```

## Funciones Lambda de Rotación

### PostgreSQL Rotation (`postgres_rotation.py`)

- ✅ Genera nuevas contraseñas seguras
- ✅ Actualiza credenciales en RDS
- ✅ Crea usuarios de aplicación con permisos limitados
- ✅ Valida conectividad antes de finalizar
- ✅ Rollback automático en caso de falla

### Redis Rotation (`redis_rotation.py`)

- ✅ Genera nuevos auth tokens
- ✅ Actualiza ElastiCache con rotación sin downtime
- ✅ Espera confirmación de aplicación
- ✅ Valida conectividad con nuevo token
- ✅ Manejo de timeouts y reintentos

### Service Account Rotation (`sa_token_rotation.py`)

- ✅ Conecta a EKS usando IAM
- ✅ Crea nuevos tokens de Service Account
- ✅ Tokens con expiración de 90 días
- ✅ Valida permisos del nuevo token
- ✅ Soporte para múltiples namespaces

## Configuración

### Variables Principales

| Variable | Descripción | Valor Por Defecto |
|----------|-------------|-------------------|
| `postgres_rotation_days` | Días entre rotaciones PostgreSQL | 30 |
| `redis_rotation_days` | Días entre rotaciones Redis | 30 |
| `grafana_rotation_days` | Días entre rotaciones Grafana | 90 |
| `sa_token_rotation_days` | Días entre rotaciones SA tokens | 90 |
| `enable_secret_replication` | Habilitar replicación cross-region | true |
| `backup_region` | Región de backup | us-west-2 |

### Horarios de Rotación

```hcl
allowed_rotation_window = {
  start_hour = 2  # 2 AM
  end_hour   = 4  # 4 AM
}
```

### Configuración Personalizada por Ambiente

```hcl
custom_rotation_schedules = {
  database_credentials    = 30  # Production: 30 días
  cache_credentials      = 30  # Production: 30 días
  admin_credentials      = 90  # Production: 90 días
  service_account_tokens = 90  # Production: 90 días
  api_keys              = 60  # Production: 60 días
}
```

## Uso en Terraform

### Configuración Básica

```hcl
module "secrets_manager" {
  source = "./modules/secrets-manager"

  cluster_name            = "gaming-cluster"
  region                  = "us-east-1"
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr               = "10.0.0.0/16"
  private_subnet_ids     = module.vpc.private_subnet_ids

  # PostgreSQL Configuration
  postgres_endpoint      = module.rds.endpoint
  postgres_database      = "gamedb"
  postgres_username      = "master"
  postgres_password      = random_password.db_password.result

  # Redis Configuration
  redis_endpoint         = module.elasticache.primary_endpoint
  redis_auth_token       = random_password.redis_token.result

  # Grafana Configuration
  grafana_admin_password = random_password.grafana_password.result
  grafana_url           = "https://grafana.gaming.com"

  # EKS Configuration
  eks_cluster_endpoint   = module.eks.cluster_endpoint

  tags = local.tags
}
```

### Configuración Avanzada

```hcl
module "secrets_manager" {
  source = "./modules/secrets-manager"

  # ... configuración básica ...

  # Rotación personalizada
  postgres_rotation_days = 15  # Cada 15 días
  redis_rotation_days   = 7   # Cada semana

  # Notificaciones
  enable_rotation_notifications = true
  notification_email           = "devops@gaming.com"
  slack_webhook_url           = var.slack_webhook

  # Seguridad avanzada
  require_approval_for_rotation = true
  enable_secret_replication    = true
  backup_region               = "eu-west-1"

  # Ventana de rotación
  allowed_rotation_window = {
    start_hour = 1
    end_hour   = 3
  }
}
```

## Integración con Otros Módulos

### RDS PostgreSQL

```hcl
# En el módulo RDS
resource "aws_db_instance" "postgres" {
  # ... configuración ...

  manage_master_user_password = true
  master_user_secret_kms_key_id = module.secrets_manager.secrets_kms_key_id
}
```

### ElastiCache Redis

```hcl
# En el módulo ElastiCache
resource "aws_elasticache_replication_group" "redis" {
  # ... configuración ...

  auth_token = data.aws_secretsmanager_secret_version.redis_auth.secret_string
}

data "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id = module.secrets_manager.redis_auth_secret_arn
}
```

### Kubernetes Service Accounts

```hcl
# En los módulos de K8s services
resource "kubernetes_secret" "prometheus_token" {
  metadata {
    name      = "prometheus-token"
    namespace = "monitoring"
  }

  data = {
    token = data.aws_secretsmanager_secret_version.prometheus_sa.secret_string
  }
}

data "aws_secretsmanager_secret_version" "prometheus_sa" {
  secret_id = module.secrets_manager.prometheus_sa_secret_arn
}
```

## Monitoreo y Alertas

### CloudWatch Metrics

- `SecretRotation/Success` - Rotaciones exitosas
- `SecretRotation/Failure` - Rotaciones fallidas
- `SecretRotation/Duration` - Tiempo de rotación
- `SecretAccess/Count` - Accesos a secretos

### Alertas Configuradas

- 🚨 **Rotación Fallida**: Alerta inmediata
- ⚠️ **Rotación Pendiente**: 24h antes del vencimiento
- 📊 **Uso Anómalo**: Acceso inusual a secretos
- 🔍 **Auditoría**: Cambios no autorizados

### Dashboards

- Secret Rotation Status
- Access Patterns
- Security Events
- Performance Metrics

## Outputs

### Principales

```hcl
output "secret_arns" {
  description = "ARNs de todos los secretos"
  value = {
    postgres_master = module.secrets_manager.postgres_master_secret_arn
    postgres_app   = module.secrets_manager.postgres_app_secret_arn
    redis_auth     = module.secrets_manager.redis_auth_secret_arn
    # ... más secretos
  }
}
```

### Para IAM Policies

```hcl
output "secrets_kms_key_arn" {
  description = "ARN de la clave KMS para políticas IAM"
  value = module.secrets_manager.secrets_kms_key_arn
}
```

## Troubleshooting

### Rotación Fallida

```bash
# Verificar logs de Lambda
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/gaming-postgres-rotation"

# Verificar estado del secreto
aws secretsmanager describe-secret --secret-id gaming-postgres-master-credentials

# Verificar última rotación
aws secretsmanager get-secret-value --secret-id gaming-postgres-master-credentials --version-stage AWSCURRENT
```

### Problemas de Conectividad

```bash
# Verificar security groups de Lambda
aws ec2 describe-security-groups --group-ids sg-lambda-rotation

# Verificar endpoints VPC
aws ec2 describe-vpc-endpoints --filters "Name=service-name,Values=com.amazonaws.us-east-1.secretsmanager"
```

### Validar Configuración

```bash
# Test manual de rotación
aws secretsmanager rotate-secret --secret-id gaming-postgres-master-credentials

# Verificar permisos Lambda
aws iam simulate-principal-policy --policy-source-arn arn:aws:iam::123456789012:role/gaming-secrets-rotation-lambda-role
```

## Mantenimiento

### Actualización de Funciones Lambda

1. Modificar código en `lambda_functions/`
2. Ejecutar `terraform apply`
3. Verificar deployment con logs

### Cambio de Horarios de Rotación

1. Actualizar `allowed_rotation_window`
2. Aplicar cambios con `terraform apply`
3. Verificar nueva programación

### Backup y Recovery

- Secretos replicados automáticamente
- Versiones históricas mantenidas
- Recovery point objetivo: < 1 hora

## Seguridad y Compliance

### Cifrado

- ✅ KMS encryption at rest
- ✅ TLS encryption in transit
- ✅ Envelope encryption para secretos

### Acceso

- ✅ IAM roles con least privilege
- ✅ VPC endpoints para tráfico privado
- ✅ Security groups restrictivos

### Auditoría

- ✅ CloudTrail logging
- ✅ CloudWatch metrics
- ✅ Access logging detallado

### Compliance

- ✅ SOC 2 Type II ready
- ✅ GDPR compliance
- ✅ PCI DSS alignment
- ✅ HIPAA ready (si requerido)

## Costos Estimados

### Por Mes (us-east-1)

- **Secrets Manager**: ~$0.40 por secreto/mes
- **KMS**: ~$1.00 por clave/mes
- **Lambda**: ~$0.01 por rotación
- **CloudWatch**: ~$0.50 logs/mes

### Total Estimado: ~$15-20/mes

Para 7 secretos con rotación mensual
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_rotation_window"></a> [allowed\_rotation\_window](#input\_allowed\_rotation\_window) | Time window when rotations are allowed (24h format) | <pre>object({<br>    start_hour = number<br>    end_hour   = number<br>  })</pre> | <pre>{<br>  "end_hour": 4,<br>  "start_hour": 2<br>}</pre> | no |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_rotation_schedules"></a> [custom\_rotation\_schedules](#input\_custom\_rotation\_schedules) | Custom rotation schedules for different services | <pre>object({<br>    database_credentials   = optional(number, 30)<br>    cache_credentials      = optional(number, 30)<br>    admin_credentials      = optional(number, 90)<br>    service_account_tokens = optional(number, 90)<br>    API_keys               = optional(number, 60)<br>  })</pre> | <pre>{<br>  "admin_credentials": 90,<br>  "API_keys": 60,<br>  "cache_credentials": 30,<br>  "database_credentials": 30,<br>  "service_account_tokens": 90<br>}</pre> | no |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable SNS notifications for rotation events | `bool` | `true` | no |
| <a name="input_enable_secret_replication"></a> [enable\_secret\_replication](#input\_enable\_secret\_replication) | Enable cross-region secret replication | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (staging, production) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_require_approval_for_rotation"></a> [require\_approval\_for\_rotation](#input\_require\_approval\_for\_rotation) | Require manual approval for critical secret rotations | `bool` | `false` | no |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for rotation notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_rotation_window"></a> [allowed\_rotation\_window](#input\_allowed\_rotation\_window) | Time window when rotations are allowed (24h format) | <pre>object({<br>    start_hour = number<br>    end_hour   = number<br>  })</pre> | <pre>{<br>  "end_hour": 4,<br>  "start_hour": 2<br>}</pre> | no |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_rotation_schedules"></a> [custom\_rotation\_schedules](#input\_custom\_rotation\_schedules) | Custom rotation schedules for different services | <pre>object({<br>    database_credentials   = optional(number, 30)<br>    cache_credentials      = optional(number, 30)<br>    admin_credentials      = optional(number, 90)<br>    service_account_tokens = optional(number, 90)<br>    API_keys               = optional(number, 60)<br>  })</pre> | <pre>{<br>  "admin_credentials": 90,<br>  "API_keys": 60,<br>  "cache_credentials": 30,<br>  "database_credentials": 30,<br>  "service_account_tokens": 90<br>}</pre> | no |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable SNS notifications for rotation events | `bool` | `true` | no |
| <a name="input_enable_secret_replication"></a> [enable\_secret\_replication](#input\_enable\_secret\_replication) | Enable cross-region secret replication | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (staging, production) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_require_approval_for_rotation"></a> [require\_approval\_for\_rotation](#input\_require\_approval\_for\_rotation) | Require manual approval for critical secret rotations | `bool` | `false` | no |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for rotation notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_rotation_window"></a> [allowed\_rotation\_window](#input\_allowed\_rotation\_window) | Time window when rotations are allowed (24h format) | <pre>object({<br>    start_hour = number<br>    end_hour   = number<br>  })</pre> | <pre>{<br>  "end_hour": 4,<br>  "start_hour": 2<br>}</pre> | no |
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_custom_rotation_schedules"></a> [custom\_rotation\_schedules](#input\_custom\_rotation\_schedules) | Custom rotation schedules for different services | <pre>object({<br>    database_credentials   = optional(number, 30)<br>    cache_credentials      = optional(number, 30)<br>    admin_credentials      = optional(number, 90)<br>    service_account_tokens = optional(number, 90)<br>    API_keys               = optional(number, 60)<br>  })</pre> | <pre>{<br>  "admin_credentials": 90,<br>  "API_keys": 60,<br>  "cache_credentials": 30,<br>  "database_credentials": 30,<br>  "service_account_tokens": 90<br>}</pre> | no |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable SNS notifications for rotation events | `bool` | `true` | no |
| <a name="input_enable_secret_replication"></a> [enable\_secret\_replication](#input\_enable\_secret\_replication) | Enable cross-region secret replication | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (staging, production) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_require_approval_for_rotation"></a> [require\_approval\_for\_rotation](#input\_require\_approval\_for\_rotation) | Require manual approval for critical secret rotations | `bool` | `false` | no |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for rotation notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
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
| [aws_cloudwatch_log_group.postgres_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.redis_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.sa_rotation_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.secrets_rotation_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.secrets_rotation_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.secrets_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.secrets_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.postgres_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.sa_token_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.postgres_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.redis_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.sa_rotation_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_secretsmanager_secret.cert_manager_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.external_dns_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.prometheus_sa_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.cert_manager_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.external_dns_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.grafana_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_app_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.postgres_master_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.prometheus_sa_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_rotation.redis_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.grafana_admin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_app_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.postgres_master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.redis_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.lambda_rotation_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.postgres_app_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [archive_file.postgres_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.redis_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.sa_rotation_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_region"></a> [backup\_region](#input\_backup\_region) | AWS backup region for secret replication | `string` | `"us-west-2"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [EKS\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS cluster endpoint | `string` | n/a | yes |
| <a name="input_enable_rotation_notifications"></a> [enable\_rotation\_notifications](#input\_enable\_rotation\_notifications) | Enable notifications for secret rotations | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (production, staging, development) | `string` | n/a | yes |
| <a name="input_grafana_admin_password"></a> [Grafana\_admin\_password](#input\_grafana\_admin\_password) | Grafana admin password | `string` | n/a | yes |
| <a name="input_grafana_rotation_days"></a> [Grafana\_rotation\_days](#input\_grafana\_rotation\_days) | Number of days between Grafana password rotations | `number` | `90` | no |
| <a name="input_grafana_url"></a> [Grafana\_url](#input\_grafana\_url) | Grafana URL | `string` | `""` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | CloudWatch log retention in days | `number` | `14` | no |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address for rotation notifications | `string` | `""` | no |
| <a name="input_postgres_database"></a> [postgres\_database](#input\_postgres\_database) | PostgreSQL database name | `string` | n/a | yes |
| <a name="input_postgres_endpoint"></a> [postgres\_endpoint](#input\_postgres\_endpoint) | PostgreSQL RDS endpoint | `string` | n/a | yes |
| <a name="input_postgres_password"></a> [postgres\_password](#input\_postgres\_password) | PostgreSQL master password | `string` | n/a | yes |
| <a name="input_postgres_port"></a> [postgres\_port](#input\_postgres\_port) | PostgreSQL port | `number` | `5432` | no |
| <a name="input_postgres_rotation_days"></a> [postgres\_rotation\_days](#input\_postgres\_rotation\_days) | Number of days between PostgreSQL password rotations | `number` | `30` | no |
| <a name="input_postgres_username"></a> [postgres\_username](#input\_postgres\_username) | PostgreSQL master username | `string` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | Private subnet IDs for Lambda functions | `list(string)` | n/a | yes |
| <a name="input_redis_auth_token"></a> [Redis\_auth\_token](#input\_redis\_auth\_token) | Redis auth token | `string` | n/a | yes |
| <a name="input_redis_endpoint"></a> [Redis\_endpoint](#input\_redis\_endpoint) | Redis ElastiCache endpoint | `string` | n/a | yes |
| <a name="input_redis_port"></a> [Redis\_port](#input\_redis\_port) | Redis port | `number` | `6379` | no |
| <a name="input_redis_rotation_days"></a> [Redis\_rotation\_days](#input\_redis\_rotation\_days) | Number of days between Redis auth token rotations | `number` | `30` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_sa_token_rotation_days"></a> [sa\_token\_rotation\_days](#input\_sa\_token\_rotation\_days) | Number of days between Service Account token rotations | `number` | `90` | no |
| <a name="input_slack_webhook_url"></a> [slack\_webhook\_url](#input\_slack\_webhook\_url) | Slack webhook URL for notifications | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [VPC\_cidr](#input\_vpc\_cidr) | VPC CIDR block | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [VPC\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cert_manager_sa_secret_arn"></a> [cert\_manager\_sa\_secret\_arn](#output\_cert\_manager\_sa\_secret\_arn) | ARN of Cert Manager service account token secret |
| <a name="output_cert_manager_sa_secret_name"></a> [cert\_manager\_sa\_secret\_name](#output\_cert\_manager\_sa\_secret\_name) | Name of Cert Manager service account token secret |
| <a name="output_external_dns_sa_secret_arn"></a> [external\_DNS\_sa\_secret\_arn](#output\_external\_dns\_sa\_secret\_arn) | ARN of External DNS service account token secret |
| <a name="output_external_dns_sa_secret_name"></a> [external\_DNS\_sa\_secret\_name](#output\_external\_dns\_sa\_secret\_name) | Name of External DNS service account token secret |
| <a name="output_grafana_admin_secret_arn"></a> [Grafana\_admin\_secret\_arn](#output\_grafana\_admin\_secret\_arn) | ARN of Grafana admin credentials secret |
| <a name="output_grafana_admin_secret_name"></a> [Grafana\_admin\_secret\_name](#output\_grafana\_admin\_secret\_name) | Name of Grafana admin credentials secret |
| <a name="output_lambda_security_group_id"></a> [lambda\_security\_group\_id](#output\_lambda\_security\_group\_id) | Security group ID for Lambda rotation functions |
| <a name="output_postgres_app_secret_arn"></a> [postgres\_app\_secret\_arn](#output\_postgres\_app\_secret\_arn) | ARN of PostgreSQL application user credentials secret |
| <a name="output_postgres_app_secret_name"></a> [postgres\_app\_secret\_name](#output\_postgres\_app\_secret\_name) | Name of PostgreSQL application user credentials secret |
| <a name="output_postgres_master_secret_arn"></a> [postgres\_master\_secret\_arn](#output\_postgres\_master\_secret\_arn) | ARN of PostgreSQL master credentials secret |
| <a name="output_postgres_master_secret_name"></a> [postgres\_master\_secret\_name](#output\_postgres\_master\_secret\_name) | Name of PostgreSQL master credentials secret |
| <a name="output_postgres_rotation_lambda_arn"></a> [postgres\_rotation\_lambda\_arn](#output\_postgres\_rotation\_lambda\_arn) | ARN of PostgreSQL rotation Lambda function |
| <a name="output_prometheus_sa_secret_arn"></a> [Prometheus\_sa\_secret\_arn](#output\_prometheus\_sa\_secret\_arn) | ARN of Prometheus service account token secret |
| <a name="output_prometheus_sa_secret_name"></a> [Prometheus\_sa\_secret\_name](#output\_prometheus\_sa\_secret\_name) | Name of Prometheus service account token secret |
| <a name="output_redis_auth_secret_arn"></a> [Redis\_auth\_secret\_arn](#output\_redis\_auth\_secret\_arn) | ARN of Redis auth token secret |
| <a name="output_redis_auth_secret_name"></a> [Redis\_auth\_secret\_name](#output\_redis\_auth\_secret\_name) | Name of Redis auth token secret |
| <a name="output_redis_rotation_lambda_arn"></a> [Redis\_rotation\_lambda\_arn](#output\_redis\_rotation\_lambda\_arn) | ARN of Redis rotation Lambda function |
| <a name="output_rotation_lambda_role_arn"></a> [rotation\_lambda\_role\_arn](#output\_rotation\_lambda\_role\_arn) | ARN of the IAM role for rotation Lambda functions |
| <a name="output_rotation_schedules"></a> [rotation\_schedules](#output\_rotation\_schedules) | Information about configured rotation schedules |
| <a name="output_sa_token_rotation_lambda_arn"></a> [sa\_token\_rotation\_lambda\_arn](#output\_sa\_token\_rotation\_lambda\_arn) | ARN of Service Account token rotation Lambda function |
| <a name="output_secret_arns"></a> [secret\_arns](#output\_secret\_arns) | Map of secret ARNs for IAM policy references |
| <a name="output_secret_names"></a> [secret\_names](#output\_secret\_names) | Map of secret names for external reference |
| <a name="output_secrets_kms_alias_name"></a> [secrets\_kms\_alias\_name](#output\_secrets\_kms\_alias\_name) | KMS key alias name |
| <a name="output_secrets_kms_key_arn"></a> [secrets\_kms\_key\_arn](#output\_secrets\_kms\_key\_arn) | KMS key ARN for secrets encryption |
| <a name="output_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#output\_secrets\_kms\_key\_id) | KMS key ID for secrets encryption |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
