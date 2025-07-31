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
  "password": "auto_generated_secure_password",
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
  "password": "auto_generated_secure_password",
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
