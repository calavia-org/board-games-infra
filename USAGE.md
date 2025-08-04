# Board Games Infrastructure - Guía de Uso Completa 📖

> **Documentación técnica completa** para deployment, configuración y operación de la infraestructura Board Games Platform.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#-requisitos-previos)
- [Instalación y Setup](#-instalación-y-setup)
- [Configuración por Entornos](#-configuración-por-entornos)
- [Deployment](#-deployment)
- [Sistema de Costes](#-sistema-de-costes)
- [Seguridad y Certificados](#-seguridad-y-certificados)
- [Monitoreo y Alertas](#-monitoreo-y-alertas)
- [Troubleshooting](#-troubleshooting)
- [Optimizaciones](#-optimizaciones)
- [Migraciones Realizadas](#-migraciones-realizadas)

## 🔧 Requisitos Previos

### 🛠️ **Herramientas Requeridas**

```bash
# AWS CLI v2.0+
aws --version
aws configure  # Configurar credenciales

# Terraform v1.8.5+
terraform version

# kubectl v1.31+
kubectl version --client

# Infracost v0.10.0+
infracost --version
infracost configure get api_key

# Opcional: GitHub CLI
gh --version
```

### ☁️ **Permisos AWS Requeridos**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "eks:*",
        "ec2:*",
        "rds:*",
        "elasticache:*",
        "iam:*",
        "route53:*",
        "certificatemanager:*",
        "elasticloadbalancing:*",
        "logs:*",
        "budgets:*"
      ],
      "Resource": "*"
    }
  ]
}
```

## � Configuración de Desarrollo

### **Pre-commit Hooks**

El proyecto incluye hooks de pre-commit para mantener calidad de código:

```bash
# Instalar y configurar automáticamente
./scripts/setup-pre-commit.sh

# O instalación manual
pip install pre-commit
pre-commit install
pre-commit install --hook-type commit-msg

# Ejecutar en todos los archivos
pre-commit run --all-files

# Ejecutar hook específico
pre-commit run terraform_fmt --all-files
pre-commit run markdownlint --all-files
```

### **Hooks Configurados**

- **🔧 General**: trailing-whitespace, end-of-file-fixer, check-YAML, check-JSON
- **🏗️ Terraform**: Terraform_fmt, Terraform_validate, Terraform_docs, Terraform_tflint, Terraform_tfsec
- **📝 Documentación**: markdownlint, yamllint, actionlint
- **🔒 Seguridad**: detect-secrets, shellcheck, hadolint-docker

### **Configuración de IDE**

Para VS Code, instalar extensiones recomendadas:

```bash
# Terraform
code --install-extension hashicorp.terraform

# YAML
code --install-extension redhat.vscode-yaml

# Markdown
code --install-extension DavidAnson.vscode-markdownlint

# Pre-commit
code --install-extension elagil.pre-commit-helper
```

## 🚀 Despliegue de Infraestructura

### 1. **Clone y Configuración Inicial**

```bash
# Clonar repositorio
git clone https://github.com/calavia-org/board-games-infra.git
cd board-games-infra

# Configurar variables de entorno
export AWS_REGION=us-west-2
export TF_VAR_owner_email="tu-email@empresa.com"
export INFRACOST_API_KEY="tu-infracost-api-key"

# Verificar configuración
aws sts get-caller-identity
```

### 2. **Configuración de Secrets**

```bash
# GitHub Secrets necesarios (configurar en repo settings)
INFRACOST_API_KEY       # Tu API key de Infracost
SLACK_WEBHOOK_URL       # URL webhook de Slack (opcional)
AWS_ACCESS_KEY_ID       # Credenciales AWS para CI/CD
AWS_SECRET_ACCESS_KEY   # Credenciales AWS para CI/CD
```

## 🏗️ Configuración por Entornos

### 📁 **Estructura del Proyecto**

```
board-games-infra/
├── calavia-eks-infra/
│   ├── environments/
│   │   ├── staging/          # Entorno de desarrollo
│   │   │   ├── main.tf       # Recursos staging (optimizado costes)
│   │   │   ├── variables.tf  # Variables específicas staging
│   │   │   └── providers.tf  # Backend Terraform
│   │   └── production/       # Entorno producción
│   │       ├── main.tf       # Recursos production (HA)
│   │       ├── variables.tf  # Variables específicas production
│   │       └── providers.tf  # Backend Terraform
│   └── modules/              # Módulos reutilizables
│       ├── eks/              # Cluster EKS + node groups
│       ├── vpc/              # Red y subnets
│       ├── rds-postgres/     # Base de datos PostgreSQL
│       ├── elasticache-redis/# Cache Redis
│       ├── security/         # Security Groups + WAF
│       ├── tags/             # Sistema etiquetado centralizado
│       └── cert-manager/     # Certificados SSL automáticos
├── .github/workflows/
│   └── infracost.yml         # CI/CD con análisis costes
└── .infracost/
    ├── usage-staging.yml     # Patrones uso staging
    └── usage-production.yml  # Patrones uso production
```

### ⚙️ **Variables Principales por Entorno**

#### **Staging Environment**

```hcl
# calavia-eks-infra/environments/staging/variables.tf
variable "node_instance_type" {
  default = "t4g.nano"        # ARM64 Graviton2 - optimizado costes
}

variable "postgres_instance_type" {
  default = "db.t4g.micro"    # ARM64 RDS - minimal para desarrollo
}

variable "redis_instance_type" {
  default = "cache.t4g.micro" # ARM64 Redis - cache básico
}

variable "desired_capacity" {
  default = 1                 # Solo 1 nodo para minimizar costes
}

variable "backup_retention_period" {
  default = 1                 # Backup mínimo para staging
}
```

#### **Production Environment**

```hcl
# calavia-eks-infra/environments/production/variables.tf
variable "on_demand_instance_type" {
  default = "t4g.small"       # ARM64 Graviton2 - balanceado
}

variable "spot_instance_types" {
  default = ["t4g.small", "t4g.medium"]  # Spot instances para ahorro
}

variable "postgres_instance_type" {
  default = "db.t4g.small"    # ARM64 RDS - rendimiento production
}

variable "enable_spot_instances" {
  default = true              # 50% spot para ahorro costes
}

variable "backup_retention_period" {
  default = 7                 # 7 días backup para compliance
}
```

## 📦 Deployment

### 🎯 **Deployment Staging (Desarrollo)**

```bash
cd calavia-eks-infra/environments/staging

# 1. Inicializar Terraform
terraform init

# 2. Validar configuración
terraform validate
terraform fmt -check

# 3. Planificar cambios
terraform plan -out=staging.tfplan

# 4. Analizar costes ANTES del deploy
infracost breakdown --path . --usage-file ../../.infracost/usage-staging.yml

# 5. Aplicar cambios
terraform apply staging.tfplan

# 6. Configurar kubectl
aws eks update-kubeconfig --region us-west-2 --name board-games-staging

# 7. Verificar deployment
kubectl get nodes -o wide
kubectl get pods --all-namespaces
```

### 🏭 **Deployment Production (Crítico)**

```bash
cd calavia-eks-infra/environments/production

# 1. Pre-deployment checks
terraform init
terraform validate
terraform plan -out=production.tfplan

# 2. Cost analysis con comparación
infracost diff --path . \
  --usage-file ../../.infracost/usage-production.yml \
  --compare-to ../../.infracost/staging-baseline.json

# 3. Staging verification REQUIRED
echo "⚠️  VERIFY STAGING FIRST before production deployment"
kubectl config use-context staging
kubectl get all --all-namespaces

# 4. Production deployment
terraform apply production.tfplan

# 5. Post-deployment verification
aws eks update-kubeconfig --region us-west-2 --name board-games-production
kubectl get nodes -o wide
kubectl get pods --all-namespaces --field-selector=status.phase!=Running
```

## 💰 Sistema de Costes

### 📊 **Infracost - Análisis Automático**

#### **Configuración Local**

```bash
# Setup Infracost
infracost configure set api_key YOUR_API_KEY

# Análisis rápido staging
infracost breakdown --path calavia-eks-infra/environments/staging

# Análisis con patrones de uso realistas
infracost breakdown --path calavia-eks-infra/environments/staging \
  --usage-file .infracost/usage-staging.yml \
  --format table

# Comparación entre entornos
infracost diff --path calavia-eks-infra/environments/production \
  --compare-to calavia-eks-infra/environments/staging \
  --format html --out-file cost-comparison.html
```

#### **Patrones de Uso Configurados**

```yaml
# .infracost/usage-staging.yml - Patrones desarrollo
version: 0.1
resource_usage:
  aws_eks_node_group.main:
    vcpu_hours: 24          # 1 vCPU x 24h (minimal usage)
  aws_db_instance.postgres:
    backup_storage_gb: 5    # Backup mínimo
    additional_iops: 0      # Sin IOPS adicionales
  aws_elasticache_replication_group.redis:
    requests: 1000000       # 1M requests/mes (desarrollo)

# .infracost/usage-production.yml - Patrones producción
version: 0.1
resource_usage:
  aws_eks_node_group.on_demand:
    vcpu_hours: 1440        # 2 vCPUs x 24h x 30d
  aws_eks_node_group.spot:
    vcpu_hours: 1440        # 2 vCPUs x 24h x 30d (spot)
  aws_db_instance.postgres:
    backup_storage_gb: 50   # Backup completo
    additional_iops: 1000   # IOPS performance
  aws_elasticache_replication_group.redis:
    requests: 10000000      # 10M requests/mes (producción)
```

### 🎯 **Budget Monitoring**

```bash
# Ver presupuestos configurados
aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text)

# Alertas de presupuesto actuales
aws budgets describe-budget --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget-name "board-games-staging-budget"

# Cost Explorer por tags
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=DIMENSION,Key=SERVICE \
  --filter '{"Tags":{"Key":"Environment","Values":["staging"]}}'
```

### 📈 **Cost Optimization Implementada**

| Optimización | Staging | Production | Ahorro Estimado |
|--------------|---------|------------|-----------------|
| **Graviton ARM64** | t3→t4g | t3→t4g | ~20% compute costs |
| **Spot Instances** | No | 50% spot | ~35% on spot compute |
| **Right-sizing** | nano/micro | small | ~50% vs medium/large |
| **Storage gp3** | gp2→gp3 | gp2→gp3 | ~20% storage costs |
| **Backup Optimized** | 1 day | 7 days | ~75% vs 30 days |
| **Auto-shutdown** | Enabled | No | ~65% staging non-hours |

## 🔒 Seguridad y Certificados

### 🎫 **Certificate Manager + Let's Encrypt**

#### **Configuración Automática**

```yaml
# cert-manager configurado automáticamente con:
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: devops@calavia.org
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - dns01:
        route53:
          region: us-west-2
          # IAM role configurado automáticamente
```

#### **Uso en Aplicaciones**

```yaml
# Ejemplo Ingress con certificado automático
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: board-games-app
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    cert-manager.io/cluster-issuer: letsencrypt-prod
    external-dns.alpha.kubernetes.io/hostname: api.boardgames.calavia.org
spec:
  tls:
  - hosts:
    - api.boardgames.calavia.org
    secretName: api-boardgames-tls
  rules:
  - host: api.boardgames.calavia.org
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: board-games-service
            port:
              number: 80
```

### 🌐 **External-DNS + Route53**

```bash
# Verificar External-DNS funcionando
kubectl logs -n external-dns deployment/external-dns

# Ver records DNS creados automáticamente
aws route53 list-resource-record-sets --hosted-zone-id YOUR_ZONE_ID \
  --query 'ResourceRecordSets[?Type==`A`]'

# Test de resolución DNS
nslookup api.boardgames.calavia.org
dig +short api.boardgames.calavia.org
```

### 🛡️ **Security Groups y RBAC**

```bash
# Ver Security Groups creados
aws ec2 describe-security-groups \
  --filters "Name=tag:Project,Values=board-games" \
  --query 'SecurityGroups[*].{Name:GroupName,Id:GroupId,Rules:IpPermissions}'

# RBAC configurado automáticamente
kubectl get clusterroles | grep board-games
kubectl get rolebindings --all-namespaces
kubectl auth can-i create pods --as=system:serviceaccount:default:board-games-sa
```

## 📊 Monitoreo y Alertas

### 📈 **CloudWatch Metrics**

```bash
# Métricas EKS cluster
aws cloudwatch get-metric-statistics \
  --namespace AWS/EKS \
  --metric-name cluster_failed_request_count \
  --dimensions Name=ClusterName,Value=board-games-production \
  --start-time 2025-08-01T00:00:00Z \
  --end-time 2025-08-31T23:59:59Z \
  --period 3600 \
  --statistics Sum

# Métricas RDS
aws cloudwatch get-metric-statistics \
  --namespace AWS/RDS \
  --metric-name CPUUtilization \
  --dimensions Name=DBInstanceIdentifier,Value=calavia-postgres-production \
  --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%SZ) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ) \
  --period 300 \
  --statistics Average,Maximum
```

### 🚨 **Alertas Configuradas**

| Métrica | Threshold | Acción | Notificación |
|---------|-----------|---------|--------------|
| **EKS CPU** | >80% por 10min | Scale up nodes | Slack + Email |
| **RDS CPU** | >85% por 5min | Alert DBA | Email |
| **Disk Usage** | >90% | Alert Ops | Slack |
| **Failed Pods** | >5 en 10min | Restart pods | Slack |
| **Budget** | >80% monthly | Cost review | Slack + Email |

### 📱 **Slack Integration**

```bash
# Test Slack webhook
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"🚀 Board Games Infrastructure - Test Alert"}' \
  $SLACK_WEBHOOK_URL

# Ejemplo payload budget alert
{
  "text": "🚨 BUDGET ALERT - Production Environment",
  "blocks": [
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": "💰 Budget Alert - 80% Threshold Reached"
      }
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "*Environment:* Production\\n*Current Spend:* $1,200\\n*Budget:* $1,500\\n*Percentage:* 80%"
      }
    }
  ]
}
```

## 🔧 Troubleshooting

### 🐛 **Problemas Comunes**

#### **1. Terraform Init Fallos**

```bash
# Error: "backend configuration changed"
terraform init -reconfigure

# Error: "state lock"
terraform force-unlock LOCK_ID

# Error: "backend.tf conflicts"
# Solución: Usar providers.tf único con backend integrado
```

#### **2. EKS Node Groups Issues**

```bash
# Nodes en NotReady
kubectl describe nodes
kubectl get events --sort-by=.metadata.creationTimestamp

# Pod failures por recursos
kubectl top nodes
kubectl describe pod FAILING_POD

# ARM64 compatibility issues
kubectl get pods -o wide
# Verificar que images soportan ARM64
docker manifest inspect nginx:latest
```

#### **3. Certificate Issues**

```bash
# Cert-manager no provisiona certificados
kubectl describe certificate api-boardgames-tls
kubectl logs -n cert-manager deployment/cert-manager

# Let's Encrypt rate limits
kubectl describe clusterissuer letsencrypt-prod
# Usar letsencrypt-staging para testing

# DNS01 challenge failures
kubectl describe challenge
aws route53 list-resource-record-sets --hosted-zone-id YOUR_ZONE_ID
```

#### **4. Cost Analysis Issues**

```bash
# Infracost command failures
infracost configure get api_key
infracost breakdown --path . --debug

# GitHub Actions workflow fails
# Check secrets configuration
gh secret list

# Artifact sharing issues entre jobs
# Verificar unique file naming en workflow
```

### 🔍 **Comandos de Debugging**

```bash
# Health check completo
kubectl get nodes,pods,services,ingress --all-namespaces
kubectl get events --sort-by=.metadata.creationTimestamp --all-namespaces

# Resource usage
kubectl top nodes
kubectl top pods --all-namespaces --sort-by=cpu
kubectl top pods --all-namespaces --sort-by=memory

# Network debugging
kubectl get networkpolicies --all-namespaces
kubectl describe ingress --all-namespaces
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].{Name:LoadBalancerName,DNS:DNSName,State:State.Code}'

# Security debugging
kubectl auth can-i --list --as=system:serviceaccount:default:default
aws iam list-roles --query 'Roles[?contains(RoleName,`board-games`)].{Role:RoleName,Arn:Arn}'
```

## ⚡ Optimizaciones

### 🚀 **Performance Optimization**

#### **Graviton2/3 ARM64 Benefits**

```bash
# Verificar arquitectura nodes
kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.architecture}'

# Performance comparison (ARM64 vs x86)
# - CPU: 40% better price/performance
# - Memory: 20% better price/performance
# - Network: Up to 20% improved networking performance
# - Energy: 60% lower power consumption
```

#### **Storage Optimization**

```bash
# gp3 volumes configurados automáticamente
aws ec2 describe-volumes --filters "Name=tag:Project,Values=board-games" \
  --query 'Volumes[*].{Id:VolumeId,Type:VolumeType,Size:Size,IOPS:Iops}'

# EBS CSI driver v1.32.0 con snapshots
kubectl get storageclass
kubectl get volumesnapshots --all-namespaces
```

### 💸 **Cost Optimization Strategies**

#### **1. Spot Instance Strategy**

```hcl
# 50% Spot / 50% On-Demand en production
resource "aws_eks_node_group" "spot" {
  capacity_type = "SPOT"
  instance_types = ["t4g.small", "t4g.medium"]  # Multiple types for availability

  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 0  # Can scale to 0 for cost savings
  }
}
```

#### **2. Auto-Scaling Configuration**

```yaml
# Cluster Autoscaler configurado
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      containers:
      - image: k8s.gcr.io/autoscaling/cluster-autoscaler:v1.31.0
        name: cluster-autoscaler
        command:
        - ./cluster-autoscaler
        - --v=4
        - --stderrthreshold=info
        - --cloud-provider=aws
        - --skip-nodes-with-local-storage=false
        - --expander=least-waste
        - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/board-games-production
        - --balance-similar-node-groups
        - --scale-down-enabled=true
        - --scale-down-delay-after-add=10m
        - --scale-down-unneeded-time=10m
```

#### **3. Resource Requests Optimization**

```yaml
# Right-sizing pods para mejor bin packing
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: app
    resources:
      requests:
        cpu: 100m      # Minimal para mejor packing
        memory: 128Mi  # ARM64 optimized
      limits:
        cpu: 500m
        memory: 512Mi
```

## 📋 Migraciones Realizadas

### 🔄 **Historial de Upgrades**

#### **1. EKS 1.28 → 1.31 (Agosto 2025)**

```
Motivación: Evitar soporte extendido, últimas features seguridad
Componentes actualizados:
- kubernetes_version: 1.28 → 1.31
- kube-proxy: v1.28.2-eksbuild.2 → v1.31.0-eksbuild.3
- vpc-cni: v1.15.1-eksbuild.1 → v1.18.1-eksbuild.1
- aws-ebs-csi-driver: v1.25.0-eksbuild.1 → v1.32.0-eksbuild.1

Benefits:
✅ Soporte completo AWS sin extensiones
✅ Últimas features seguridad K8s 1.31
✅ Mejor compatibilidad con ARM64
✅ Performance improvements
```

#### **2. x86 → ARM64 Graviton Migration**

```
Motivación: 40% ahorro costes + mejor rendimiento
Instancias migradas:

Staging:
- t3.nano → t4g.nano (EKS nodes)
- db.t3.micro → db.t4g.micro (PostgreSQL)
- cache.t2.micro → cache.t4g.micro (Redis)

Production:
- t3.small → t4g.small (EKS nodes)
- [t3.small, t3.medium] → [t4g.small, t4g.medium] (Spot)
- db.t3.small → db.t4g.small (PostgreSQL)
- cache.t3.micro → cache.t4g.micro (Redis)

Root config:
- [m5.large, m5.xlarge, m4.large] → [m7g.large, m7g.xlarge, m6g.large]

Benefits:
✅ ~20% reducción costes compute
✅ Hasta 40% mejor rendimiento
✅ 60% menor consumo energético
✅ Mejor price/performance ratio
```

#### **3. Infrastructure Versioning**

```
v1.0.0 → v2.0.0
- Baseline: x86 + EKS 1.28
- Current: ARM64 Graviton + EKS 1.31 + Sistema costes completo

Tags actualizados:
- Architecture: x86_64 → arm64
- Version: 1.0.0 → 2.0.0
- Service: Added service-specific tagging
```

### 🎯 **Resultados de Optimización**

| Métrica | Antes (v1.0.0) | Después (v2.0.0) | Mejora |
|---------|-----------------|-------------------|---------|
| **Cost/Month Staging** | ~$125-150 | ~$75-100 | **~40% ahorro** |
| **Cost/Month Production** | ~$400-500 | ~$250-350 | **~35% ahorro** |
| **Performance/$ (CPU)** | Baseline | +40% | **40% mejor** |
| **Energy Efficiency** | Baseline | +60% | **60% menos consumo** |
| **EKS Support** | Extended needed | Full support | **Sin coste extra** |
| **Security Updates** | K8s 1.28 | K8s 1.31 | **Latest patches** |

---

## 📞 Soporte y Recursos

### 🆘 **Getting Help**

- **Issues**: [GitHub Issues](https://github.com/calavia-org/board-games-infra/issues)
- **Discussions**: [GitHub Discussions](https://github.com/calavia-org/board-games-infra/discussions)
- **Email**: devops@calavia.org
- **Slack**: #board-games-infra

### 📚 **Referencias Adicionales**

- [AWS EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)
- [Infracost Docs](https://www.infracost.io/docs/)
- [AWS Graviton Guide](https://github.com/aws/aws-graviton-getting-started)
- [Kubernetes ARM64 Support](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-runtime)

---

> **📝 Nota**: Esta documentación se actualiza con cada release. Para la versión más reciente, consulta siempre el repositorio principal.
>
> **🔄 Última actualización**: Infraestructura v2.0.0 - EKS 1.31 + Graviton ARM64
