# Board Games Infrastructure 🎮

[![Infrastructure Version](https://img.shields.io/badge/Infrastructure-v2.0.0-blue.svg)](./USAGE.md)
[![Terraform](https://img.shields.io/badge/Terraform-1.8.5-purple.svg)](https://terraform.io/)
[![EKS](https://img.shields.io/badge/EKS-v1.31-orange.svg)](https://aws.amazon.com/eks/)
[![Architecture](https://img.shields.io/badge/Architecture-ARM64%20Graviton-green.svg)](./GRAVITON-MIGRATION.md)

> **Infraestructura moderna, segura y optimizada para costes** diseñada para aplicaciones de gaming escalables con arquitectura ARM64 Graviton y las últimas versiones de Kubernetes.

## 🏗️ Arquitectura de la Infraestructura

### 🔧 **Stack Tecnológico**

- **☸️ Kubernetes**: EKS v1.31 (última versión estable)
- **⚡ Compute**: AWS Graviton2/3 (ARM64) - 40% mejor rendimiento/coste
- **🌐 Networking**: VPC multi-AZ con subnets públicas/privadas
- **💾 Database**: PostgreSQL 14.9 en RDS con optimización de costes
- **🔄 Cache**: Redis 7.0 en ElastiCache para sesiones y cache
- **🔒 Security**: WAF, Security Groups, IAM roles con RBAC
- **📊 Monitoring**: CloudWatch, Prometheus, Grafana
- **💰 Cost Control**: Infracost + AWS Budgets + alertas automatizadas

### 🏢 **Entornos**

```
┌─ Production ──────────────────────────┐  ┌─ Staging ─────────────────────────────┐
│ • EKS v1.31 (t4g.small x2-4 nodes)   │  │ • EKS v1.31 (t4g.nano x1 node)       │
│ • RDS PostgreSQL (db.t4g.small)      │  │ • RDS PostgreSQL (db.t4g.micro)      │
│ • ElastiCache Redis (t4g.micro)      │  │ • ElastiCache Redis (t4g.micro)      │
│ • Multi-AZ + High Availability       │  │ • Single-AZ + Cost Optimized         │
│ • Budget: $1,500/mes                 │  │ • Budget: $500/mes                   │
└───────────────────────────────────────┘  └───────────────────────────────────────┘
```

## 🚀 Quick Start

### 1. **Prerequisites**

```bash
# Required tools
aws-cli >= 2.0
terraform >= 1.8.5
kubectl >= 1.31
infracost >= 0.10.0
```

### 2. **Deploy Infrastructure**

```bash
# Clone repository
git clone https://github.com/calavia-org/board-games-infra.git
cd board-games-infra

# Deploy staging environment
cd calavia-eks-infra/environments/staging
terraform init
terraform plan
terraform apply

# Deploy production environment
cd ../production
terraform init
terraform plan
terraform apply
```

### 3. **Verify Deployment**

```bash
# Connect to EKS cluster
aws eks update-kubeconfig --region us-west-2 --name board-games-staging
kubectl get nodes -o wide

# Check infrastructure costs
infracost breakdown --path ./calavia-eks-infra/environments/staging
```

## 💰 Sistema de Control de Costes

### 🎯 **Características Implementadas**

#### 🔧 **Herramientas de Análisis**

- **Infracost Integration**: Análisis automático en PRs con comparación antes/después
- **AWS Budgets**: Presupuestos automáticos con alertas al 80% y 100%
- **GitHub Actions**: Workflow completo de análisis de costes en CI/CD
- **Slack Integration**: Notificaciones automáticas de presupuesto y reportes mensuales

#### � **Presupuestos por Entorno**

| Entorno | Presupuesto | EKS Nodes | Database | Cache | Estimado Real |
|---------|-------------|-----------|----------|-------|---------------|
| **Staging** | $500/mes | t4g.nano x1 | db.t4g.micro | t4g.micro | ~$75-100/mes |
| **Production** | $1,500/mes | t4g.small x2-4 | db.t4g.small | t4g.micro | ~$250-350/mes |

### 💡 **Optimizaciones Implementadas**

- **🔋 Graviton ARM64**: ~40% ahorro vs x86 (t3→t4g migration)
- **📦 Spot Instances**: 50% spot/50% on-demand en producción
- **🔄 Auto-Scaling**: Escalado automático basado en métricas
- **⏰ Scheduled Shutdown**: Auto-apagado en staging fuera de horario
- **💾 Storage Optimization**: gp3 volumes con auto-scaling limitado

## 🔒 Seguridad y Compliance

### 🛡️ **Características de Seguridad**

- **🔐 Network Security**: VPC aislada, Security Groups restrictivos, NACLs
- **🎫 Certificate Management**: Let's Encrypt con DNS-01 challenge auto-renewal
- **🌐 DNS Integration**: External-DNS con Route53 para registro automático de FQDNs
- **🔑 IAM Security**: Roles IAM específicos, IRSA para pods, principio de menor privilegio
- **📋 Compliance**: Tagging completo para auditoría, encryption at rest/transit

### 🏷️ **Sistema de Etiquetado Centralizado**

```hcl
Tags aplicados automáticamente:
- Environment: production|staging
- Service: board-games-platform
- Component: database|cache|compute|networking
- Architecture: arm64
- CostCenter: CC-001-GAMING
- ManagedBy: terraform
```

## 📈 Monitoreo y Observabilidad

### 📊 **Stack de Monitoreo**

- **☁️ CloudWatch**: Métricas nativas de AWS, logs centralizados
- **🔍 Container Insights**: Visibilidad completa de EKS
- **📢 Alertas**: Notificaciones automáticas vía Slack/Email
- **💸 Cost Monitoring**: Dashboards de costes en tiempo real

### 🚨 **Alertas Configuradas**

- CPU > 80% en nodos EKS
- Memoria > 85% en pods
- Disk usage > 90%
- Presupuesto > 80% mensual
- Failed pods > 5 en 10 minutos

## 🔄 CI/CD y Automatización

### 🤖 **GitHub Actions Workflows**

- **💰 Cost Analysis**: Análisis automático de costes en PRs
- **🧪 Terraform Validation**: Lint, format, validate en cada commit
- **� Pre-commit Checks**: Linting automático de código, documentación y seguridad
- **�🚀 Multi-Environment**: Deploy automático staging → production
- **📊 Reporting**: Reportes mensuales automatizados

### 📋 **Workflow Features**

```yaml
✅ Pre-commit hooks con auto-formateo
✅ Terraform validation y security scan
✅ Markdown/YAML linting automático
✅ Detección de secretos y vulnerabilidades
✅ Infracost analysis con comparación
✅ Empty base branch handling
✅ Multi-environment deployment
✅ Slack notifications
✅ Budget monitoring y alertas
```

### 🔧 **Pre-commit Integration**

- **Formateo automático**: Terraform, Markdown, YAML
- **Validación**: Sintaxis, seguridad, best practices
- **Detección**: Secretos, vulnerabilidades, errores comunes
- **Documentación**: Auto-generación de docs de módulos

## 📚 Documentación Adicional

### 📖 **Guías Disponibles**

- **[USAGE.md](./USAGE.md)** - Guía completa de uso y configuración
- **Arquitectura Detallada** - Diagramas y explicaciones técnicas
- **Troubleshooting** - Solución de problemas comunes
- **Best Practices** - Recomendaciones y patrones

### � **Enlaces Útiles**

- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [AWS Graviton Performance Guide](https://github.com/aws/aws-graviton-getting-started)

## 🤝 Contribución

### 🛠️ **Development Workflow**

1. Fork el repositorio
2. Crear feature branch: `git checkout -b feature/amazing-feature`
3. Commit cambios: `git commit -m 'Add amazing feature'`
4. Push branch: `git push origin feature/amazing-feature`
5. Abrir Pull Request

### � **Guidelines**

- Seguir convenciones de Terraform
- Incluir tests y documentación
- Mantener compatibilidad ARM64
- Optimizar costes en todas las decisiones

## 📄 Licencia

Este proyecto está licenciado bajo MIT License - ver [LICENSE](LICENSE) para detalles.

## 📞 Soporte

- **👨‍💻 Owner**: [Jorge Calavia](mailto:1184336+jcalavia@users.noreply.github.com)
- **🏢 Organization**: Calavia Gaming Platform
- **💼 Cost Center**: CC-001-GAMING
- **🔗 Repository**: [board-games-infra](https://github.com/calavia-org/board-games-infra)

---

> **🚀 Versión 2.0.0** - EKS 1.31 + Graviton ARM64 + Infracost Integration
>
> **💰 ROI**: ~40% ahorro en costes compute + soporte EKS sin extensiones
>
> **🌱 Sustainability**: 60% menos consumo energético con Graviton
./scripts/cost-analysis.sh production --output JSON --save

```

#### **2. Configurar AWS Budgets**
```bash
# Configurar budgets y alertas
./scripts/setup-aws-budgets.sh

# Listar budgets existentes
./scripts/setup-aws-budgets.sh --list

# Eliminar budgets (para reconfigurar)
./scripts/setup-aws-budgets.sh --delete
```

#### **3. Generar Reportes**

```bash
# Reporte semanal completo con recomendaciones
./scripts/generate-cost-report.sh -f weekly -o html -s --trend-analysis --cost-optimization

# Reporte mensual y envío automático
./scripts/generate-cost-report.sh -f monthly -o html --send --trend-analysis
```

#### **4. Configurar Reportes Automáticos**

```bash
# Instalar cron jobs para reportes automáticos
cp scripts/crontab.example /tmp/cost-monitoring-cron
# Editar rutas en el archivo
crontab /tmp/cost-monitoring-cron
```

### 📁 **Estructura de Archivos de Costes**

```
.infracost/
├── config.yml                    # Configuración principal de Infracost
├── usage-staging.yml             # Patrones de uso para staging
└── usage-production.yml          # Patrones de uso para producción

scripts/
├── cost-analysis.sh              # Análisis local con Infracost
├── setup-aws-budgets.sh          # Configuración de AWS Budgets
├── generate-cost-report.sh       # Generador de reportes
└── crontab.example               # Configuración para cron jobs

.github/workflows/
└── infracost.yml                 # CI/CD con análisis automático

reports/                          # Reportes generados
├── daily/
├── weekly/
├── monthly/
└── trends/
```

### ⚙️ **Variables de Entorno Requeridas**

```bash
# Infracost API Key (obtener gratis en dashboard.infracost.io)
export INFRACOST_API_KEY="your-api-key"

# Notificaciones por email
export EMAIL_RECIPIENTS="devops@calavia.org,finance@calavia.org"

# Integración con Slack
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"

# AWS CLI debe estar configurado con permisos para:
# - Cost Explorer
# - Budgets
# - Support (para Trusted Advisor)
```

### 🎛️ **GitHub Actions - Análisis Automático**

El workflow de GitHub Actions ejecuta automáticamente:

- **En Pull Requests**: Compara costes de los cambios propuestos
- **En Push a main**: Genera reportes de resumen mensual
- **Alertas de presupuesto**: Verifica umbrales y envía notificaciones

### 💡 **Optimizaciones de Costes Incluidas**

1. **Instancias Spot**: Configuradas para cargas de trabajo no críticas
2. **Auto-scaling**: Políticas agresivas para optimizar recursos
3. **Storage optimization**: Recomendaciones para volúmenes EBS
4. **VPC Endpoints**: Reducción de costes de transferencia de datos
5. **Reserved Instances**: Sugerencias para cargas estables

### 📈 **Monitoreo Continuo**

- **Alertas en tiempo real** para anomalías de costes
- **Comparación histórica** de tendencias
- **Desglose detallado** por servicio y recurso
- **Proyecciones** de costes mensuales basadas en uso actuala
Manage infrastructure to run game server

## Setup instructions

```promptql

Como ingeniero de infraestructura, quiero implementar el código para desplegar la infraestructura basada en kubernetes que me permita alojar un servicio de genración de partidas distribuidas multi jugador en tiempo real. Debe estar definida en Terraform y el objetivo del despliegue es un Clúster EKS en AWS con maquinas spot que sirva para controlar el estado dos entornos: staging y producción. Además se debe utiliza el servicio Terraform Cloud para almacenar el estado.

Para la persistencia se requiere provisionar un servicio gestionado tipo Redis para caché y un servicio gestionado tipo PostgreSQL, los cuales solamente deben ser accesibles desde el cluster de aplicaciones definido anteriormente. Para la gestion de las credenciales de uso de los servicios gestionados se debe integrar algun mecanismo de actualización de secretos en el cluster, implementando ademas un rotado automático mensual de las contraseñas. La solución requerida es IAM Service Account (IMSA) y además quiero que las políticas de rotación de contraseñas para las soluciones basadas en Service Accounts sea totalmente gestionada por ejemplo con AWS Secrets Manager.

El clúster se debe desplegar en tres zonas de disponibilidad parametrizables y con requisitos fuertes de seguridad, impidiendo los accesos no autorizados desde el exterior del mismo. Además el cluster debe estar monitorizado y con alertado basado en kube-prometheus stack con el Alert Manager con 3 días de retención de información para el entorno de producción y de un día para el entorno de stagging. Al necesitar el acceso para un único usuario también quiero incluir AWS Managed Grafana para visualizar los datos de modo que también quiero un conjunto de dashboards que me permitan visualizar los datos que proveé el stack kube-prometheus.

Como requisito de seguridad, se requiere implementar políticas de seguridad fuertes dentro de la red interna del cluster. También es obligatorio que el clúster disponga de un proveedor de certificados gratuito, que me permita que cada vez que despliegue una aplicación con un Ingress Controler basado en AWS ALB , se registre en el servicio de DNS de AWS (Route 53) el FQDN y se provisione un certificado valido con auto renovación y con un Cluster Issuer para Let’s Encrypt + DNS-01 challenge haciendo uso ademas de External DNS. Por tanto tambíén necesito el codigo necesario para configurar toda esta funcionalidad, incluida la configuración inicial del servicio DNS y las demás piezas mencionadas

 Para el control de costes quiro incluir algun tipo de herramienta que me calcule automaticamente los costes estimdos de la  infraestrutura al estilo de infra-cost

```
