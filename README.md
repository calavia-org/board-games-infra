# board-gamesComo requisito de seguridad, se requiere implementar políticas de seguridad fuertes dentro de la red interna del cluster. También es obligatorio que el clúster disponga de un proveedor de certificados gratuito, que me permita que cada vez que despliegue una aplicación con un Ingress Controler basado en AWS ALB , se registre en el servicio de DNS de AWS (Route 53) el FQDN y se provisione un certificado valido con auto renovación y con un Cluster Issuer para Let's Encrypt + DNS-01 challenge haciendo uso ademas de External DNS. Por tanto tambíén necesito el codigo necesario para configurar toda esta funcionalidad, incluida la configuración inicial del servicio DNS y las demás piezas mencionadas

Para el control de costes quiro incluir algun tipo de herramienta que me calcule automaticamente los costes estimdos de la  infraestrutura al estilo de infra-cost

```

## 💰 Sistema de Control de Costes

### 🎯 Características Implementadas

La infraestructura incluye un **sistema completo de control y monitoreo de costes** usando **Infracost** y herramientas de AWS:

#### 🔧 **Herramientas de Análisis de Costes**

1. **Infracost Integration**
   - Análisis automático en Pull Requests
   - Comparación de costes antes/después de cambios
   - Reportes detallados por entorno (staging/production)
   - Configuración personalizada para patrones de uso realistas

2. **AWS Budgets & Alertas**
   - Presupuestos automáticos por entorno
   - Alertas por email al 80% y 100% del presupuesto
   - Detección de anomalías de costes
   - Integración con Slack para notificaciones

3. **Reportes Automáticos**
   - Reportes diarios, semanales y mensuales
   - Análisis de tendencias de costes
   - Recomendaciones de optimización
   - Distribución por servicio y zona de disponibilidad

#### 📊 **Presupuestos Configurados**

| Entorno | Presupuesto Mensual | Alerta 80% | Alerta 100% |
|---------|---------------------|-------------|--------------|
| Staging | $500 USD | $400 USD | $500 USD |
| Production | $1,500 USD | $1,200 USD | $1,500 USD |

### 🚀 **Uso de las Herramientas**

#### **1. Análisis Local de Costes**
```bash
# Analizar ambos entornos
./scripts/cost-analysis.sh both

# Analizar solo staging con comparación
./scripts/cost-analysis.sh staging --compare --output html --save

# Analizar producción y guardar en JSON
./scripts/cost-analysis.sh production --output json --save
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
