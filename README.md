# Board Games Infrastructure 🎮

[![Infrastructure](https://img.shields.io/badge/Infrastructure-v2.0.0-blue.svg)](./docs/USAGE.md)
[![Terraform](https://img.shields.io/badge/Terraform-1.8.5-purple.svg)](https://terraform.io/)
[![EKS](https://img.shields.io/badge/EKS-v1.31-orange.svg)](https://aws.amazon.com/eks/)
[![Security](https://img.shields.io/badge/Security-Compliant-green.svg)](./docs/SECURITY.md)
[![Pre-commit](https://img.shields.io/badge/Pre--commit-Enabled-brightgreen.svg)](https://pre-commit.com/)

> **Infraestructura moderna, segura y optimizada** diseñada para aplicaciones de gaming escalables con arquitectura multi-jugador en tiempo real. Incluye pre-commit hooks optimizados para máxima productividad.

## 🏗️ Arquitectura

### 🔧 **Stack Tecnológico**

- **☸️ Kubernetes**: Amazon EKS v1.31
- **⚡ Compute**: AWS Graviton2/3 (ARM64) con Spot Instances
- **🌐 Networking**: VPC multi-AZ con subnets públicas/privadas/database
- **💾 Database**: PostgreSQL 14.9 en RDS con backup automatizado
- **🔄 Cache**: Redis 7.0 en ElastiCache con snapshots
- **🔒 Security**: WAF, VPC Flow Logs, Security Groups restrictivos
- **📊 Monitoring**: CloudWatch + Prometheus + Grafana
- **🔑 Secrets**: AWS Secrets Manager con rotación automática
- **🌍 DNS**: Route53 + External DNS + cert-manager
- **💰 Cost Control**: Infracost + AWS Budgets

### 🏢 **Entornos**

| Entorno | EKS Nodes | RDS | ElastiCache | Presupuesto |
|---------|-----------|-----|-------------|-------------|
| **Production** | t4g.small (2-4 nodes) | db.t4g.small | cache.t4g.micro | $1,500/mes |
| **Staging** | t4g.nano (1 node) | db.t4g.micro | cache.t4g.micro | $500/mes |

## 🚀 Quick Start

### Prerequisites

```bash
# Herramientas requeridas
aws-cli >= 2.0
terraform >= 1.8.5
kubectl >= 1.31
pre-commit >= 3.0.0
```

### 1. Configuración Inicial

```bash
# Clonar repositorio
git clone https://github.com/calavia-org/board-games-infra.git
cd board-games-infra

# Instalar pre-commit hooks
pip install pre-commit
pre-commit install

# Configurar AWS CLI
aws configure
```

### 2. Deploy Infrastructure

```bash
# Cambiar al directorio de infraestructura
cd calavia-eks-infra/environments/staging

# Inicializar Terraform
terraform init

# Planificar cambios
terraform plan

# Aplicar infraestructura
terraform apply
```

### 3. Configurar kubectl

```bash
# Configurar acceso al cluster
aws eks update-kubeconfig --region us-west-2 --name board-games-staging
```

## 🛠️ Pre-commit Hooks Optimizados

Esta configuración incluye **hooks optimizados de alta velocidad** para mejorar la productividad:

### 🚀 **Hooks Terraform Optimizados**

| Hook | Descripción | Mejora |
|------|-------------|---------|
| `terraform-validate-fast` | Validación con caché inteligente | **30-60x más rápido** |
| `tflint-custom` | Linting con configuración personalizada | Usa `.tflint-simple.hcl` |
| `trivy-terraform-security` | Escaneo de seguridad con ignores | Respeta `.trivyignore` |

### ⚡ **Rendimiento**

- **terraform_validate**: ~0.5s (vs 10-30s original)
- **tflint**: Configuración simplificada sin reglas problemáticas
- **trivy**: Ignora warnings menores configurables

### 🔧 **Configuración de Hooks**

```bash
# Ejecutar todos los hooks
pre-commit run --all-files

# Ejecutar hooks específicos
pre-commit run terraform-validate-fast
pre-commit run trivy-terraform-security
pre-commit run tflint-custom

# Actualizar hooks
pre-commit autoupdate
```

## 📁 Estructura del Proyecto

```
board-games-infra/
├── 📂 calavia-eks-infra/          # Infraestructura principal
│   ├── 📂 environments/           # Configuraciones por entorno
│   │   ├── production/            # Entorno de producción
│   │   └── staging/               # Entorno de staging
│   ├── 📂 modules/                # Módulos reutilizables
│   │   ├── eks/                   # Cluster Kubernetes
│   │   ├── vpc/                   # Red y subnets
│   │   ├── rds-postgres/          # Base de datos
│   │   ├── elasticache-redis/     # Cache distribuido
│   │   ├── security/              # Security groups
│   │   ├── monitoring/            # Observabilidad
│   │   └── cert-manager/          # Certificados SSL
│   └── 📂 scripts/                # Scripts de utilidad
├── 📂 scripts/                    # Scripts optimizados
│   ├── terraform-validate-wrapper.sh  # Validación rápida
│   ├── tflint-wrapper.sh         # TFLint configurado
│   └── trivy-wrapper.sh          # Trivy con ignores
├── 📂 docs/                       # Documentación
└── 📄 Archivos de configuración
    ├── .pre-commit-config.yaml   # Hooks optimizados
    ├── .tflint-simple.hcl        # TFLint simplificado
    ├── .trivyignore              # Ignores de seguridad
    └── .terraform-validate-cache # Cache de validación
```

## 🔒 Seguridad

### ✅ **Implementado**

- ✅ VPC Flow Logs habilitados
- ✅ Security groups con reglas restrictivas
- ✅ RDS con backup retention de 7 días
- ✅ ElastiCache con snapshots automáticos
- ✅ EKS con acceso privado únicamente
- ✅ Lambda permissions con source ARN específico
- ✅ KMS key rotation habilitado
- ✅ Secrets Manager con rotación automática

### 🛡️ **Compliance**

- **Trivy**: 0 problemas CRÍTICOS/HIGH/MEDIUM
- **TFLint**: Configuración validada
- **Pre-commit**: Validación automática en cada commit

## 🚦 Comandos Comunes

### Terraform

```bash
# Validación rápida (con caché)
./scripts/terraform-validate-wrapper.sh

# Formateo de código
terraform fmt -recursive

# Plan con análisis de costes
terraform plan | tee plan.out && infracost breakdown --path plan.out
```

### Pre-commit

```bash
# Instalar y configurar
pre-commit install --install-hooks

# Ejecutar en archivos modificados
pre-commit run

# Ejecutar en todos los archivos
pre-commit run --all-files

# Saltar hooks específicos
SKIP=trivy-terraform-security git commit -m "mensaje"
```

### Kubernetes

```bash
# Configurar contexto
aws eks update-kubeconfig --region us-west-2 --name board-games-staging

# Verificar conexión
kubectl get nodes

# Ver pods del sistema
kubectl get pods -A
```

## 📖 Documentación

- 📘 [**Guía de Uso**](./docs/USAGE.md) - Instrucciones detalladas
- 🔒 [**Seguridad**](./docs/SECURITY.md) - Políticas y compliance
- 💰 [**Costes**](./docs/COSTS.md) - Monitoreo y optimización
- ⚡ [**Pre-commit**](./docs/PRECOMMIT.md) - Hooks optimizados
- 🏗️ [**Arquitectura**](./docs/ARCHITECTURE.md) - Diseño del sistema

## 🤝 Contribuir

1. **Fork** el repositorio
2. **Instalar** pre-commit: `pre-commit install`
3. **Crear** branch: `git checkout -b feature/nueva-funcionalidad`
4. **Commit** con hooks: `git commit -m "feat: nueva funcionalidad"`
5. **Push** y crear **Pull Request**

## 📄 Licencia

Este proyecto está bajo la licencia [MIT](LICENSE).

---

**Desarrollado con ❤️ por el equipo de Calavia Gaming Infrastructure**
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.



<!-- BEGIN_TF_DOCS -->
## Requirements

## Requirements

No requirements.
## Providers

## Providers

No providers.
## Modules

## Modules

No modules.
## Resources

## Resources

No resources.
## Inputs

## Inputs

No inputs.
## Outputs

## Outputs

No outputs.
<!-- END_TF_DOCS -->
