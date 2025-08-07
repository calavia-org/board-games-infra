# Guía de Uso - Board Games Infrastructure 📖

## 🚀 Inicio Rápido

### Prerequisites

Asegúrate de tener instaladas las siguientes herramientas:

```bash
# AWS CLI
aws --version  # >= 2.0

# Terraform
terraform --version  # >= 1.8.5

# kubectl
kubectl version --client  # >= 1.31

# Pre-commit
pre-commit --version  # >= 3.0.0
```

### 1. Configuración Inicial

```bash
# 1. Clonar el repositorio
git clone https://github.com/calavia-org/board-games-infra.git
cd board-games-infra

# 2. Configurar AWS CLI
aws configure
# AWS Access Key ID: [Tu Access Key]
# AWS Secret Access Key: [Tu Secret Key]
# Default region name: us-west-2
# Default output format: json

# 3. Instalar pre-commit hooks optimizados
pip install pre-commit
pre-commit install

# 4. Verificar configuración
pre-commit run --all-files
```

## 🏗️ Despliegue de Infraestructura

### Entorno Staging (Recomendado para empezar)

```bash
# 1. Navegar al entorno staging
cd calavia-eks-infra/environments/staging

# 2. Revisar y personalizar variables
cat variables.tf
# Editar si es necesario: region, cluster_name, etc.

# 3. Inicializar Terraform
terraform init

# 4. Validar configuración
terraform validate

# 5. Revisar plan de despliegue
terraform plan

# 6. Aplicar infraestructura
terraform apply
# Escribir "yes" cuando se solicite confirmación
```

### Entorno Production

```bash
# Solo después de validar staging
cd calavia-eks-infra/environments/production

# Configurar variables específicas de producción
terraform init
terraform plan
terraform apply
```

## ⚙️ Pre-commit Hooks Optimizados

### Hooks Disponibles

| Hook | Propósito | Tiempo Ejecución |
|------|-----------|------------------|
| `terraform-validate-fast` | Validación con caché | ~0.5s |
| `tflint-custom` | Linting personalizado | ~2-3s |
| `trivy-terraform-security` | Escaneo de seguridad | ~5-10s |
| `terraform_fmt` | Formateo automático | ~1-2s |
| `terraform_docs` | Documentación | ~2-3s |

### Uso de Pre-commit

```bash
# Ejecutar todos los hooks
pre-commit run --all-files

# Ejecutar hooks específicos
pre-commit run terraform-validate-fast
pre-commit run trivy-terraform-security

# Saltar hooks específicos en un commit
SKIP=trivy-terraform-security git commit -m "fix: corrección urgente"

# Actualizar hooks a la última versión
pre-commit autoupdate

# Ver hooks disponibles
pre-commit run --help
```

### Configuración de Cache

El hook `terraform-validate-fast` usa un sistema de caché inteligente:

```bash
# Ver estado del caché
cat .terraform-validate-cache

# Limpiar caché (forzar re-validación)
rm .terraform-validate-cache

# El caché se invalida automáticamente cuando cambian archivos .tf
```

## 🔧 Configuración de Archivos

### .tflint-simple.hcl

Configuración simplificada de TFLint que evita reglas problemáticas:

```hcl
# Solo reglas de Terraform core (sin AWS específicas)
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

# Reglas básicas habilitadas
rule "terraform_deprecated_interpolation" { enabled = true }
rule "terraform_unused_declarations" { enabled = true }
# ... más reglas
```

### .trivyignore

Configuración para ignorar warnings menores de seguridad:

```bash
# Ignorar warnings específicos
AVD-AWS-0009  # VPC default security group
AVD-AWS-0018  # Missing description
# ... más reglas ignoradas
```

### .pre-commit-config.YAML

Configuración optimizada con hooks personalizados:

```yaml
# Hooks estándar de Terraform
- repo: https://github.com/antonbabenko/pre-commit-terraform
  hooks:
    - id: terraform_fmt
    - id: terraform_docs

# Hooks personalizados optimizados
- repo: local
  hooks:
    - id: terraform-validate-fast  # 30-60x más rápido
    - id: tflint-custom           # Con configuración personalizada
    - id: trivy-terraform-security # Con .trivyignore
```

## 🎛️ Gestión de Entornos

### Variables por Entorno

```bash
# Staging - Optimizado para costes
cluster_name = "board-games-staging"
instance_types = ["t4g.nano"]
min_size = 1
max_size = 2
desired_size = 1

# Production - Optimizado para rendimiento
cluster_name = "board-games-production"
instance_types = ["t4g.small", "t4g.medium"]
min_size = 2
max_size = 6
desired_size = 3
```

### Configuración de kubectl

```bash
# Staging
aws eks update-kubeconfig --region us-west-2 --name board-games-staging

# Production
aws eks update-kubeconfig --region us-west-2 --name board-games-production

# Verificar contexto actual
kubectl config current-context

# Cambiar entre contextos
kubectl config use-context arn:aws:eks:us-west-2:ACCOUNT:cluster/board-games-staging
```

## 🚦 Comandos de Desarrollo

### Terraform

```bash
# Formatear código
terraform fmt -recursive

# Validación completa
terraform validate

# Plan con análisis de costes
terraform plan -out=tfplan
infracost breakdown --path tfplan

# Aplicar cambios específicos
terraform apply -target=module.eks

# Ver estado actual
terraform show

# Destruir recursos (¡CUIDADO!)
terraform destroy
```

### Debugging

```bash
# Logs detallados de Terraform
export TF_LOG=DEBUG
terraform apply

# Ver configuración de pre-commit
pre-commit sample-config

# Verificar hooks instalados
pre-commit run --help

# Debug específico de hooks
./scripts/terraform-validate-wrapper.sh
./scripts/tflint-wrapper.sh
./scripts/trivy-wrapper.sh
```

### Monitoreo

```bash
# Verificar cluster EKS
kubectl get nodes -o wide

# Ver pods del sistema
kubectl get pods -A

# Logs de control plane
aws eks describe-cluster --name board-games-staging

# Métricas de costes
aws ce get-cost-and-usage --time-period Start=2025-08-01,End=2025-08-04 --granularity DAILY --metrics BlendedCost
```

## 🔒 Seguridad y Compliance

### Validación de Seguridad

```bash
# Escaneo completo con Trivy
trivy config calavia-eks-infra/ --severity CRITICAL,HIGH,MEDIUM

# Usando nuestro wrapper optimizado
./scripts/trivy-wrapper.sh

# Verificar compliance
pre-commit run trivy-terraform-security --all-files
```

### Gestión de Secretos

```bash
# Ver secretos en AWS Secrets Manager
aws secretsmanager list-secrets

# Rotar secretos manualmente
aws secretsmanager rotate-secret --secret-id arn:aws:secretsmanager:us-west-2:ACCOUNT:secret:rds-credentials

# Verificar rotación automática
aws secretsmanager describe-secret --secret-id rds-credentials
```

## 📊 Monitoreo de Costes

### Infracost

```bash
# Instalar Infracost
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Configurar API key (gratis)
infracost auth login

# Análisis de costes
cd calavia-eks-infra/environments/staging
terraform plan -out=tfplan
infracost breakdown --path tfplan

# Comparación de entornos
infracost diff --path tfplan
```

### AWS Cost Explorer

```bash
# Ver costes del último mes
aws ce get-cost-and-usage \
  --time-period Start=2025-07-01,End=2025-08-01 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE

# Alertas de presupuesto
aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text)
```

## 🛠️ Troubleshooting

### Problemas Comunes

#### Pre-commit Lento

```bash
# Problema: terraform_validate tarda mucho
# Solución: Usar nuestro hook optimizado
pre-commit run terraform-validate-fast

# Verificar que el caché funciona
ls -la .terraform-validate-cache
```

#### TFLint Errores

```bash
# Problema: Reglas AWS no encontradas
# Solución: Usar configuración simplificada
./scripts/tflint-wrapper.sh

# Verificar configuración
cat .tflint-simple.hcl
```

#### Trivy Falsos Positivos

```bash
# Problema: Demasiados warnings
# Solución: Configurar .trivyignore
echo "AVD-AWS-0123" >> .trivyignore

# Verificar ignores actuales
cat .trivyignore
```

### Logs y Debugging

```bash
# Logs de pre-commit
pre-commit run --verbose terraform-validate-fast

# Logs de scripts personalizados
./scripts/terraform-validate-wrapper.sh

# Debug de Terraform
export TF_LOG=DEBUG
terraform plan

# Verificar permisos AWS
aws sts get-caller-identity
aws iam list-attached-user-policies --user-name $(aws sts get-caller-identity --query Arn --output text | cut -d'/' -f2)
```

## 📚 Recursos Adicionales

- 🔗 [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- 🔗 [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- 🔗 [Pre-commit Hooks](https://pre-commit.com/hooks.html)
- 🔗 [Trivy Documentation](https://trivy.dev/)
- 🔗 [TFLint Rules](https://github.com/terraform-linters/tflint-ruleset-terraform)
- 🔗 [Infracost](https://www.infracost.io/docs/)

---

¿Problemas? Crear un [issue](https://github.com/calavia-org/board-games-infra/issues) 🐛
