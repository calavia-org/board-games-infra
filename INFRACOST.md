# 💰 INFRACOST - Sistema de Control de Costes

## 📋 Índice

- [Introducción](#introducción)
- [Configuración Inicial](#configuración-inicial)
- [Herramientas Disponibles](#herramientas-disponibles)
- [Uso Diario](#uso-diario)
- [Automatización](#automatización)
- [Monitoreo y Alertas](#monitoreo-y-alertas)
- [Reportes](#reportes)
- [Optimización de Costes](#optimización-de-costes)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## 🎯 Introducción

El sistema de control de costes de **Board Games Infrastructure** utiliza **Infracost** junto con herramientas nativas de AWS para proporcionar:

- **Análisis proactivo** de costes antes de aplicar cambios
- **Presupuestos automáticos** con alertas configurables
- **Reportes periódicos** con recomendaciones de optimización
- **Monitoreo continuo** 24/7 con detección de anomalías
- **Integración CI/CD** para análisis automático en Pull Requests

### 🏗️ Arquitectura del Sistema

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Infracost     │    │   AWS Budgets    │    │  GitHub Actions │
│  (Estimaciones) │◄──►│   (Alertas)      │◄──►│   (CI/CD)       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Cost Control Dashboard                        │
│  • Reportes HTML  • Análisis de Tendencias  • Recomendaciones  │
└─────────────────────────────────────────────────────────────────┘
```

### 💵 Presupuestos Configurados

| Entorno | Presupuesto Mensual | Alerta 80% | Alerta 100% | Coste Estimado |
|---------|---------------------|-------------|--------------|----------------|
| **Staging** | $500 USD | $400 USD | $500 USD | ~$308 USD |
| **Production** | $1,500 USD | $1,200 USD | $1,500 USD | ~$1,006 USD |
| **Total** | $2,000 USD | $1,600 USD | $2,000 USD | ~$1,314 USD |

---

## ⚙️ Configuración Inicial

### 1. 🔑 Configurar Infracost API Key

Obtén tu API key gratuita desde [dashboard.infracost.io](https://dashboard.infracost.io):

```bash
# Configurar API key (requerido)
export INFRACOST_API_KEY="ico-xxxxxxxxxxxxxxxxxxxxxxxxx"

# Verificar configuración
infracost configure get api_key
```

### 2. 📧 Configurar Notificaciones

```bash
# Emails para reportes y alertas
export EMAIL_RECIPIENTS="devops@calavia.org,finance@calavia.org"

# Webhook de Slack (opcional)
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"
```

### 3. 🔧 Instalar Dependencias

```bash
# macOS con Homebrew
brew install infracost

# Linux
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Verificar instalación
infracost --version
```

### 4. ☁️ Configurar AWS CLI

Asegúrate de que AWS CLI esté configurado con permisos para:

```bash
# Permisos requeridos:
# - Cost Explorer (ce:*)
# - Budgets (budgets:*)
# - Support (support:*) - para Trusted Advisor
# - CloudWatch (cloudwatch:*)

# Verificar configuración
aws sts get-caller-identity
aws ce get-cost-and-usage --help > /dev/null && echo "✅ Cost Explorer OK"
aws budgets describe-budgets --account-id $(aws sts get-caller-identity --query Account --output text) > /dev/null && echo "✅ Budgets OK"
```

---

## 🛠️ Herramientas Disponibles

### 📊 cost-analysis.sh

**Propósito**: Análisis de costes con Infracost

```bash
# Analizar ambos entornos
./scripts/cost-analysis.sh both

# Analizar solo staging
./scripts/cost-analysis.sh staging

# Analizar con comparación vs main branch
./scripts/cost-analysis.sh production --compare

# Generar reporte HTML y guardarlo
./scripts/cost-analysis.sh both --output html --save

# Ver ayuda completa
./scripts/cost-analysis.sh --help
```

**Salidas disponibles**:
- `table` (por defecto): Tabla en terminal
- `json`: Formato JSON para procesamiento
- `html`: Reporte HTML visual

### 💰 setup-aws-budgets.sh

**Propósito**: Configuración de presupuestos y alertas AWS

```bash
# Configurar todos los budgets y alertas
./scripts/setup-aws-budgets.sh

# Listar budgets existentes
./scripts/setup-aws-budgets.sh --list

# Eliminar budgets existentes
./scripts/setup-aws-budgets.sh --delete

# Configurar con email personalizado
./scripts/setup-aws-budgets.sh --email "tu-email@empresa.com"
```

**Qué configura**:
- Budgets mensuales por entorno
- Alertas por email al 80% y 100%
- Detector de anomalías de costes
- Suscripciones a notificaciones

### 📈 generate-cost-report.sh

**Propósito**: Generación de reportes periódicos

```bash
# Reporte semanal básico
./scripts/generate-cost-report.sh -f weekly

# Reporte completo con análisis y envío
./scripts/generate-cost-report.sh -f monthly -o html -s --trend-analysis --cost-optimization

# Reporte diario solo para staging
./scripts/generate-cost-report.sh -f daily -e "staging-team@empresa.com"
```

**Opciones disponibles**:
- `-f, --frequency`: daily, weekly, monthly
- `-o, --output`: html, json, csv
- `-s, --send`: Enviar por email/Slack
- `--trend-analysis`: Incluir análisis de tendencias
- `--cost-optimization`: Incluir recomendaciones

### 🎮 demo-cost-system.sh

**Propósito**: Demostración del sistema completo

```bash
# Demo completa del sistema
./scripts/demo-cost-system.sh

# Demo interactiva (pausa entre secciones)
./scripts/demo-cost-system.sh --interactive
```

---

## 📅 Uso Diario

### 🌅 Rutina Matutina (Recomendada)

```bash
# 1. Verificar estado de presupuestos
./scripts/setup-aws-budgets.sh --list

# 2. Análisis rápido de costes actuales
./scripts/cost-analysis.sh both

# 3. Si hay cambios pendientes, compararlos
./scripts/cost-analysis.sh both --compare --output table
```

### 🔄 Antes de Aplicar Cambios

```bash
# 1. Crear branch para cambios
git checkout -b feature/new-infrastructure

# 2. Realizar cambios en Terraform
# ... editar archivos .tf ...

# 3. Analizar impacto en costes
./scripts/cost-analysis.sh both --compare --output html --save

# 4. Revisar reporte generado en reports/
# 5. Si todo OK, crear Pull Request
```

### 🚨 Respuesta a Alertas

**Alerta de Presupuesto (80%)**:
```bash
# 1. Análisis inmediato
./scripts/cost-analysis.sh both --output json > /tmp/current-costs.json

# 2. Generar reporte con recomendaciones
./scripts/generate-cost-report.sh -f daily --cost-optimization

# 3. Revisar recomendaciones y actuar
```

**Alerta de Anomalía**:
```bash
# 1. Verificar anomalías en AWS
aws ce get-anomalies --date-interval Start=$(date -d '1 day ago' +%Y-%m-%d),End=$(date +%Y-%m-%d)

# 2. Análisis detallado por servicio
./scripts/cost-analysis.sh both --output html --save

# 3. Investigar servicios con incrementos inusuales
```

---

## 🤖 Automatización

### 🔄 GitHub Actions

El sistema incluye workflows automáticos en `.github/workflows/infracost.yml`:

**Triggers automáticos**:
- ✅ **Pull Request**: Análisis de costes de cambios
- ✅ **Push a main**: Reporte mensual
- ✅ **Schedule**: Verificación de presupuestos cada 6h

**Configurar secretos en GitHub**:
```bash
# En GitHub Settings > Secrets and variables > Actions:
INFRACOST_API_KEY: "ico-xxxxxxxxx"
SLACK_WEBHOOK_URL: "https://hooks.slack.com/services/..."
EMAIL_RECIPIENTS: "devops@empresa.com"
```

### ⏰ Cron Jobs (Recomendado)

```bash
# 1. Copiar configuración de ejemplo
cp scripts/crontab.example /tmp/cost-monitoring-cron

# 2. Editar rutas absolutas en el archivo
nano /tmp/cost-monitoring-cron
# Cambiar /path/to/board-games-infra por la ruta real

# 3. Instalar cron jobs
crontab /tmp/cost-monitoring-cron

# 4. Verificar instalación
crontab -l
```

**Programación automática instalada**:
- 📊 **Diario**: L-V 9:00 AM - Reporte diario
- 📈 **Semanal**: Lunes 8:00 AM - Reporte completo
- 📅 **Mensual**: 1er día 7:00 AM - Reporte ejecutivo
- 🚨 **Alertas**: Cada 6h - Verificación de anomalías

---

## 🚨 Monitoreo y Alertas

### 📊 Dashboards Disponibles

1. **Infracost Dashboard**: [dashboard.infracost.io](https://dashboard.infracost.io)
2. **AWS Cost Explorer**: Consola AWS > Cost Management
3. **Reportes HTML**: Carpeta `reports/` local

### 🔔 Tipos de Alertas

| Tipo | Trigger | Frecuencia | Acción |
|------|---------|------------|---------|
| **Presupuesto 80%** | Coste > 80% del límite | Diaria | Email + Análisis |
| **Presupuesto 100%** | Coste > 100% del límite | Inmediata | Email + Escalación |
| **Anomalía** | Incremento > 50% | Cada 6h | Email + Investigación |
| **Tendencia** | Incremento > 20% semanal | Semanal | Reporte + Recomendaciones |

### 📱 Configurar Notificaciones Slack

```bash
# 1. Crear Incoming Webhook en Slack
# 2. Configurar variable de entorno
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"

# 3. Probar notificación
curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"🧪 Test: Sistema de costes configurado correctamente"}' \
    "$SLACK_WEBHOOK_URL"
```

---

## 📊 Reportes

### 📈 Tipos de Reportes

#### 1. **Reporte Diario** (Lunes a Viernes)
```bash
./scripts/generate-cost-report.sh -f daily -s
```
- Costes actuales vs presupuesto
- Tendencia últimos 7 días
- Alertas activas

#### 2. **Reporte Semanal** (Lunes)
```bash
./scripts/generate-cost-report.sh -f weekly -s --trend-analysis
```
- Análisis de tendencias semanal
- Comparación vs semana anterior
- Top 5 servicios más costosos

#### 3. **Reporte Mensual** (1er día del mes)
```bash
./scripts/generate-cost-report.sh -f monthly -s --trend-analysis --cost-optimization
```
- Resumen ejecutivo completo
- Análisis de tendencias mensual
- Recomendaciones de optimización detalladas
- Proyección siguiente mes

### 📂 Ubicación de Reportes

```
reports/
├── daily/
│   ├── cost-report-20250803-090000.html
│   └── infracost-staging-20250803-090000.json
├── weekly/
│   ├── cost-report-20250801-080000.html
│   └── trend-analysis.json
├── monthly/
│   ├── cost-report-20250801-070000.html
│   └── optimization-recommendations.json
└── trends/
    └── historical-data.json
```

### 🎨 Interpretación de Reportes HTML

Los reportes HTML incluyen:

- **🟢 Verde**: Costes normales (< 70% del presupuesto)
- **🟡 Amarillo**: Atención requerida (70-90% del presupuesto)  
- **🔴 Rojo**: Acción inmediata (> 90% del presupuesto)

**Secciones principales**:
1. **Resumen Ejecutivo**: Costes totales y estado de presupuestos
2. **Desglose por Servicio**: Costes detallados por recurso AWS
3. **Análisis de Tendencias**: Gráficos de evolución temporal
4. **Recomendaciones**: Acciones específicas para optimizar costes

---

## 💡 Optimización de Costes

### 🎯 Recomendaciones Automáticas

El sistema genera recomendaciones específicas basadas en el análisis:

#### **Staging** (Ahorro potencial: ~$75/mes)
- ✅ **Instancias Spot**: Migrar desarrollo a instancias spot (~$25/mes)
- ✅ **Scheduling**: Shutdown nocturno y fines de semana (~$25/mes)
- ✅ **Storage**: Optimizar tamaños de volúmenes EBS (~$15/mes)
- ✅ **Logs**: Reducir retención de CloudWatch logs (~$10/mes)

#### **Production** (Ahorro potencial: ~$200/mes)
- ✅ **Reserved Instances**: RDS y EC2 para cargas estables (~$140/mes)
- ✅ **Auto-scaling**: Políticas más agresivas (~$35/mes)
- ✅ **VPC Endpoints**: Reducir transferencia de datos (~$25/mes)

### 🔧 Implementar Optimizaciones

#### 1. **Configurar Instancias Spot**
```bash
# Editar configuración de node groups
nano calavia-eks-infra/modules/eks/main.tf

# Incrementar proporción de instancias spot
# spot_instances = {
#   desired_size = 4  # Incrementar
#   max_size     = 8  # Incrementar  
#   min_size     = 2  # Mantener
# }
```

#### 2. **Implementar Scheduling**
```bash
# Crear script de scheduling para staging
cat > scripts/schedule-staging.sh << 'EOF'
#!/bin/bash
# Parar instancias staging fuera de horario laboral
aws ec2 describe-instances --filters "Name=tag:Environment,Values=staging" \
  --query 'Reservations[*].Instances[*].InstanceId' --output text | \
  xargs aws ec2 stop-instances --instance-ids
EOF

# Cron job: Parar a las 7 PM, iniciar a las 8 AM
0 19 * * 1-5 /path/to/scripts/schedule-staging.sh stop
0 8 * * 1-5 /path/to/scripts/schedule-staging.sh start
```

#### 3. **Reserved Instances**
```bash
# Analizar recomendaciones de RI
aws ce get-reservation-recommendations \
  --service EC2-Instance \
  --account-scope PAYER

# Analizar recomendaciones de RDS
aws ce get-reservation-recommendations \
  --service Amazon RDS \
  --account-scope PAYER
```

### 📊 Seguimiento de Optimizaciones

```bash
# 1. Baseline antes de optimización
./scripts/cost-analysis.sh both --output json > baseline-costs.json

# 2. Aplicar cambios de optimización
# ... implementar cambios ...

# 3. Medir impacto después de 1 semana
./scripts/cost-analysis.sh both --output json > optimized-costs.json

# 4. Calcular savings
python3 -c "
import json
with open('baseline-costs.json') as f: baseline = json.load(f)
with open('optimized-costs.json') as f: optimized = json.load(f)
savings = float(baseline['totalMonthlyCost']) - float(optimized['totalMonthlyCost'])
print(f'Ahorro mensual: ${savings:.2f} ({savings/float(baseline[\"totalMonthlyCost\"])*100:.1f}%)')
"
```

---

## 🔧 Troubleshooting

### ❌ Problemas Comunes

#### **Error: "API key not configured"**
```bash
# Verificar configuración
infracost configure get api_key

# Si está vacía, configurar
export INFRACOST_API_KEY="ico-xxxxxxxxx"
infracost configure set api_key $INFRACOST_API_KEY
```

#### **Error: "AWS credentials not found"**
```bash
# Verificar configuración AWS
aws sts get-caller-identity

# Si falla, configurar
aws configure
# O usar variables de entorno:
export AWS_ACCESS_KEY_ID="tu-access-key"
export AWS_SECRET_ACCESS_KEY="tu-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

#### **Error: "Permission denied" en scripts**
```bash
# Hacer ejecutables los scripts
chmod +x scripts/*.sh

# Verificar permisos
ls -la scripts/
```

#### **Error: "Command not found: infracost"**
```bash
# Reinstalar Infracost
curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Verificar PATH
echo $PATH
which infracost
```

### 🩺 Diagnóstico del Sistema

```bash
# Script de diagnóstico completo
cat > scripts/diagnose-cost-system.sh << 'EOF'
#!/bin/bash
echo "🔍 Diagnóstico del Sistema de Costes"
echo "=================================="

echo "1. Verificando Infracost..."
if command -v infracost &> /dev/null; then
    echo "✅ Infracost instalado: $(infracost --version)"
    if infracost configure get api_key > /dev/null 2>&1; then
        echo "✅ API key configurada"
    else
        echo "❌ API key NO configurada"
    fi
else
    echo "❌ Infracost NO instalado"
fi

echo -e "\n2. Verificando AWS CLI..."
if aws sts get-caller-identity > /dev/null 2>&1; then
    echo "✅ AWS CLI configurado"
    echo "   Account: $(aws sts get-caller-identity --query Account --output text)"
else
    echo "❌ AWS CLI NO configurado"
fi

echo -e "\n3. Verificando scripts..."
for script in cost-analysis.sh setup-aws-budgets.sh generate-cost-report.sh; do
    if [ -x "scripts/$script" ]; then
        echo "✅ $script executable"
    else
        echo "❌ $script no encontrado o no ejecutable"
    fi
done

echo -e "\n4. Verificando variables de entorno..."
[ -n "$INFRACOST_API_KEY" ] && echo "✅ INFRACOST_API_KEY configurada" || echo "❌ INFRACOST_API_KEY no configurada"
[ -n "$EMAIL_RECIPIENTS" ] && echo "✅ EMAIL_RECIPIENTS configurada" || echo "⚠️  EMAIL_RECIPIENTS no configurada"
[ -n "$SLACK_WEBHOOK_URL" ] && echo "✅ SLACK_WEBHOOK_URL configurada" || echo "⚠️  SLACK_WEBHOOK_URL no configurada"

echo -e "\n5. Test de conectividad..."
if curl -s --head https://pricing.api.infracost.io > /dev/null; then
    echo "✅ Conexión a Infracost API OK"
else
    echo "❌ No se puede conectar a Infracost API"
fi
EOF

chmod +x scripts/diagnose-cost-system.sh
./scripts/diagnose-cost-system.sh
```

### 📞 Soporte

Si encuentras problemas:

1. **Ejecuta el diagnóstico**: `./scripts/diagnose-cost-system.sh`
2. **Revisa los logs**: `tail -f /var/log/cron` (para cron jobs)
3. **Verifica GitHub Actions**: En la pestaña Actions del repositorio
4. **Consulta documentación**: [docs.infracost.io](https://www.infracost.io/docs/)

---

## ❓ FAQ

### **P: ¿Con qué frecuencia se actualizan los precios de AWS?**
**R**: Infracost actualiza los precios semanalmente. Los costes mostrados son estimaciones basadas en los precios públicos de AWS.

### **P: ¿Los análisis de Infracost afectan la facturación real?**
**R**: No. Infracost solo hace estimaciones basadas en la configuración de Terraform. No interactúa con recursos reales de AWS.

### **P: ¿Cómo se calculan las estimaciones de uso?**
**R**: Se usan los archivos `.infracost/usage-*.yml` que definen patrones de uso realistas basados en métricas históricas y proyecciones.

### **P: ¿Puedo personalizar los umbrales de alerta?**
**R**: Sí. Edita los valores en `scripts/setup-aws-budgets.sh` y re-ejecuta el script para actualizar los presupuestos.

### **P: ¿Qué hacer si los costes reales difieren mucho de las estimaciones?**
**R**: 
1. Actualiza los archivos de uso en `.infracost/usage-*.yml`
2. Compara con AWS Cost Explorer para identificar discrepancias
3. Ajusta los patrones de uso basándote en métricas reales

### **P: ¿Cómo excluir recursos del análisis?**
**R**: Usa comentarios especiales en Terraform:
```hcl
resource "aws_instance" "example" {
  # infracost:skip - Razón para excluir
  # ... configuración ...
}
```

### **P: ¿El sistema funciona con otros proveedores cloud?**
**R**: Este sistema está optimizado para AWS. Infracost soporta Azure y GCP, pero requeriría adaptación de los scripts.

### **P: ¿Cómo acceder a reportes históricos?**
**R**: Los reportes se guardan en `reports/` con timestamp. Para análisis histórico, usa:
```bash
# Ver evolución de costes
find reports/ -name "*.json" -exec echo {} \; -exec jq -r '.totalMonthlyCost' {} \;
```

### **P: ¿Puedo integrar con otras herramientas de monitoreo?**
**R**: Sí. Los reportes en JSON pueden integrarse con:
- Grafana (importar métricas)
- DataDog (custom metrics)
- New Relic (custom events)
- Cualquier sistema que consuma JSON/REST APIs

---

## 🚀 Próximos Pasos

### 📈 Mejoras Planificadas

1. **Dashboard Web**: Interfaz web para visualización interactiva
2. **Machine Learning**: Predicciones de costes basadas en tendencias
3. **Integración Multi-Cloud**: Soporte para Azure y GCP
4. **API REST**: Endpoint para integración con sistemas externos
5. **Mobile App**: Notificaciones push y visualización móvil

### 🎯 Roadmap 2025

- **Q3 2025**: Dashboard web completo
- **Q4 2025**: Predicciones ML y recomendaciones avanzadas
- **Q1 2026**: Integración multi-cloud completa

---

## 📞 Contacto y Soporte

**Equipo DevOps**: devops@calavia.org  
**Finanzas**: finance@calavia.org  
**Slack**: #infrastructure-costs  

**Documentación adicional**:
- [Infracost Docs](https://www.infracost.io/docs/)
- [AWS Cost Management](https://docs.aws.amazon.com/cost-management/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

*Última actualización: Agosto 2025*  
*Versión: 1.0*  
*Mantenido por: Team DevOps - Board Games Infrastructure* 🎮
