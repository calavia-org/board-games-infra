# 🏷️ Ejemplos Prácticos del Sistema de Tagging

## 📋 Casos de Uso Comunes

### 1. 🚀 Despliegue de Nueva Infraestructura

#### **Paso 1: Configurar Tags Base**
```hcl
# terraform.tfvars
project_name           = "board-games"
owner_email           = "devops@calavia.org"
cost_center           = "CC-001-GAMING"
business_unit         = "Gaming-Platform"
department            = "Engineering"
infrastructure_version = "1.2.0"
```

#### **Paso 2: Usar Módulo de Tags**
```hcl
# main.tf
module "production_tags" {
  source = "./modules/tags"
  
  environment  = "production"
  owner_email  = "devops@calavia.org"
  component    = "database"
  purpose      = "primary-game-database"
  criticality  = "critical"
  
  additional_tags = {
    Engine          = "postgresql"
    EngineVersion   = "14.9"
    BackupSchedule  = "daily"
    MaintenanceDay  = "sunday"
  }
}
```

#### **Paso 3: Aplicar a Recursos**
```hcl
resource "aws_db_instance" "game_database" {
  identifier = "game-db-production"
  # ... configuración ...
  
  tags = module.production_tags.enriched_tags
}
```

---

### 2. 📊 Análisis de Costes por Tags

#### **Comandos AWS CLI para Cost Explorer**

```bash
# Costes por Environment
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=TAG,Key=Environment \
  --granularity MONTHLY

# Costes por Component
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=TAG,Key=Component \
  --filter-by Tags,Key=Project,Values=board-games

# Costes por Owner (Team)
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=TAG,Key=Owner \
  --metrics BlendedCost,UnblendedCost
```

#### **Script de Análisis Personalizado**
```bash
#!/bin/bash
# cost-analysis-by-tags.sh

# Análisis por Environment
echo "=== COSTES POR ENVIRONMENT ==="
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '1 month ago' +%Y-%m-01),End=$(date +%Y-%m-01) \
  --group-by Type=TAG,Key=Environment \
  --query 'ResultsByTime[0].Groups[*].[Keys[0],Metrics.BlendedCost.Amount]' \
  --output table

# Análisis por Component
echo "=== COSTES POR COMPONENT ==="
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '1 month ago' +%Y-%m-01),End=$(date +%Y-%m-01) \
  --group-by Type=TAG,Key=Component \
  --query 'ResultsByTime[0].Groups[*].[Keys[0],Metrics.BlendedCost.Amount]' \
  --output table
```

---

### 3. 🔍 Auditoría y Compliance

#### **Buscar Recursos Sin Tags Obligatorios**
```bash
# Recursos sin tag Environment
aws resourcegroupstaggingapi get-resources \
  --resource-type-filters "AWS::RDS::DBInstance" "AWS::EKS::Cluster" \
  --query 'ResourceTagMappingList[?!Tags[?Key==`Environment`]].[ResourceARN]' \
  --output table

# Recursos sin tag Owner
aws resourcegroupstaggingapi get-resources \
  --resource-type-filters "AWS::EC2::Instance" \
  --query 'ResourceTagMappingList[?!Tags[?Key==`Owner`]].[ResourceARN]' \
  --output table
```

#### **Generar Reporte de Compliance**
```bash
# Reporte completo HTML
./scripts/tag-compliance-report.sh \
  --format html \
  --output compliance-report-$(date +%Y%m%d).html \
  --email devops@calavia.org

# Reporte JSON para procesamiento
./scripts/tag-compliance-report.sh \
  --format json \
  --output compliance-$(date +%Y%m%d).json

# Reporte filtrado por environment
./scripts/tag-compliance-report.sh \
  --environment production \
  --format table
```

---

### 4. 🏷️ Auto-Tagging de Recursos Existentes

#### **Tagging Masivo por Environment**
```bash
# Dry run para staging
./scripts/auto-tagger.sh \
  --environment staging \
  --owner devops@calavia.org \
  --component database \
  --criticality medium \
  --dry-run

# Aplicar tags reales
./scripts/auto-tagger.sh \
  --environment staging \
  --owner devops@calavia.org \
  --component database \
  --criticality medium \
  --force
```

#### **Tagging de Recurso Específico**
```bash
./scripts/auto-tagger.sh \
  --resource-arn arn:aws:rds:us-west-2:123456789012:db:legacy-db \
  --environment production \
  --owner database@calavia.org \
  --component database \
  --criticality critical
```

#### **Tagging por Tipo de Recurso**
```bash
# Todos los clusters EKS
./scripts/auto-tagger.sh \
  --resource-type "AWS::EKS::Cluster" \
  --environment production \
  --owner platform@calavia.org \
  --component container-orchestration \
  --criticality critical

# Todas las instancias RDS
./scripts/auto-tagger.sh \
  --resource-type "AWS::RDS::DBInstance" \
  --environment production \
  --owner database@calavia.org \
  --component database \
  --criticality high
```

---

### 5. 💰 Configuración de Presupuestos por Tags

#### **Budget por Environment**
```bash
# Crear budget para producción
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget '{
    "BudgetName": "production-environment-budget",
    "BudgetLimit": {
      "Amount": "1500",
      "Unit": "USD"
    },
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST",
    "CostFilters": {
      "TagKey": ["Environment"],
      "TagValue": ["production"]
    }
  }'
```

#### **Budget por Component**
```bash
# Budget para bases de datos
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget '{
    "BudgetName": "database-components-budget",
    "BudgetLimit": {
      "Amount": "400",
      "Unit": "USD"
    },
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST",
    "CostFilters": {
      "TagKey": ["Component"],
      "TagValue": ["database"]
    }
  }'
```

---

### 6. 📈 Integración con Infracost

#### **Configuración con Tags**
```yaml
# .infracost/config.yml
version: 0.1
projects:
  - path: calavia-eks-infra/environments/production
    name: production-environment
    tags:
      environment: production
      team: platform
      
  - path: calavia-eks-infra/environments/staging  
    name: staging-environment
    tags:
      environment: staging
      team: development
```

#### **Análisis con Filtros de Tags**
```bash
# Análisis de costes con tags
infracost breakdown \
  --path calavia-eks-infra/environments/production \
  --format json \
  --out-file production-costs.json

# Procesar resultados por tags
jq '.projects[].breakdown.resources[] | select(.tags.Component == "database")' \
   production-costs.json
```

---

### 7. 🤖 Automatización en CI/CD

#### **GitHub Actions Workflow**
```yaml
# .github/workflows/tag-validation.yml
name: Tag Validation

on:
  pull_request:
    paths:
      - 'calavia-eks-infra/**/*.tf'

jobs:
  validate-tags:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Validate Terraform Tags
        run: |
          # Verificar que todos los recursos tengan module.tags
          if grep -r "resource \"aws_" calavia-eks-infra/ | grep -v "tags = module.tags"; then
            echo "❌ Found resources without proper tagging module"
            exit 1
          fi
          echo "✅ All resources use tagging module"
          
      - name: Check Tag Compliance
        run: |
          ./scripts/tag-compliance-report.sh --format json --output compliance.json
          COMPLIANCE=$(jq -r '.metadata.compliancePercentage' compliance.json)
          if [ "$COMPLIANCE" -lt 95 ]; then
            echo "❌ Tag compliance below 95%: $COMPLIANCE%"
            exit 1
          fi
          echo "✅ Tag compliance: $COMPLIANCE%"
```

#### **Pre-commit Hook**
```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔍 Validating Terraform tags..."

# Verificar uso del módulo de tags
if git diff --cached --name-only | grep -E "\.tf$" | xargs grep -l "resource \"aws_" | xargs grep -L "module.tags"; then
    echo "❌ Found Terraform files with AWS resources not using tagging module"
    echo "Please ensure all AWS resources use: tags = module.tags.tags"
    exit 1
fi

echo "✅ Tag validation passed"
```

---

### 8. 📊 Dashboards y Reportes

#### **Script de Reporte Ejecutivo**
```bash
#!/bin/bash
# executive-tag-report.sh

echo "📊 EXECUTIVE TAGGING REPORT - $(date)"
echo "=================================="

# Compliance general
COMPLIANCE=$(aws resourcegroupstaggingapi get-compliance-summary \
  --query 'SummaryList[0].ComplianceByConfigRule.CompliantResourceCount.CappedCount' \
  --output text)

echo "Overall Compliance: $COMPLIANCE%"

# Costes por environment
echo -e "\n💰 COSTS BY ENVIRONMENT:"
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '1 month ago' +%Y-%m-01),End=$(date +%Y-%m-01) \
  --group-by Type=TAG,Key=Environment \
  --query 'ResultsByTime[0].Groups[*].[Keys[0],Metrics.BlendedCost.Amount]' \
  --output table

# Top recursos más costosos
echo -e "\n🏆 TOP COST RESOURCES:"
aws ce get-cost-and-usage \
  --time-period Start=$(date -d '1 month ago' +%Y-%m-01),End=$(date +%Y-%m-01) \
  --group-by Type=DIMENSION,Key=RESOURCE_ID \
  --query 'ResultsByTime[0].Groups[:5].[Keys[0],Metrics.BlendedCost.Amount]' \
  --output table
```

#### **Dashboard con Grafana (Query Examples)**
```sql
-- Compliance por tiempo
SELECT 
  time,
  compliant_resources,
  total_resources,
  (compliant_resources::float / total_resources::float * 100) as compliance_percentage
FROM tag_compliance_metrics
WHERE time > now() - interval '30 days'

-- Costes por tag
SELECT 
  environment,
  component,
  owner,
  sum(cost) as total_cost
FROM aws_cost_data 
WHERE date >= date_trunc('month', current_date)
GROUP BY environment, component, owner
ORDER BY total_cost DESC
```

---

### 9. 🚨 Alertas y Notificaciones

#### **CloudWatch Alarm para Compliance**
```bash
# Crear alarma para compliance bajo
aws cloudwatch put-metric-alarm \
  --alarm-name "tag-compliance-low" \
  --alarm-description "Tag compliance below 95%" \
  --metric-name CompliancePercentage \
  --namespace "CustomMetrics/Tagging" \
  --statistic Average \
  --period 3600 \
  --threshold 95 \
  --comparison-operator LessThanThreshold \
  --evaluation-periods 1
```

#### **Lambda para Notificaciones Slack**
```python
import json
import boto3
import urllib3

def lambda_handler(event, context):
    """
    Envía notificaciones de compliance de tags a Slack
    """
    
    # Obtener métricas de compliance
    compliance_percentage = get_tag_compliance()
    
    if compliance_percentage < 95:
        message = {
            "text": f"⚠️ Tag Compliance Alert: {compliance_percentage}%",
            "attachments": [
                {
                    "color": "warning",
                    "fields": [
                        {
                            "title": "Current Compliance",
                            "value": f"{compliance_percentage}%",
                            "short": True
                        },
                        {
                            "title": "Target",
                            "value": "95%",
                            "short": True
                        }
                    ]
                }
            ]
        }
        
        send_slack_notification(message)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Notification sent')
    }
```

---

### 10. 🔧 Mantenimiento y Limpieza

#### **Script de Limpieza de Tags Obsoletos**
```bash
#!/bin/bash
# cleanup-obsolete-tags.sh

echo "🧹 Cleaning up obsolete tags..."

# Tags obsoletos a eliminar
OBSOLETE_TAGS=("OldProject" "LegacyOwner" "DeprecatedComponent")

for tag in "${OBSOLETE_TAGS[@]}"; do
    echo "Removing tag: $tag"
    
    # Buscar recursos con el tag obsoleto
    aws resourcegroupstaggingapi get-resources \
      --tag-filters Key="$tag" \
      --query 'ResourceTagMappingList[].ResourceARN' \
      --output text | while read -r arn; do
        
        # Determinar servicio y eliminar tag
        service=$(echo "$arn" | cut -d':' -f3)
        case "$service" in
            "rds")
                aws rds remove-tags-from-resource \
                  --resource-name "$arn" \
                  --tag-keys "$tag"
                ;;
            "ec2")
                resource_id=$(echo "$arn" | rev | cut -d'/' -f1 | rev)
                aws ec2 delete-tags \
                  --resources "$resource_id" \
                  --tags Key="$tag"
                ;;
        esac
        
        echo "  ✅ Removed $tag from $arn"
    done
done

echo "🎉 Cleanup completed"
```

#### **Migración de Tags Schema**
```bash
#!/bin/bash
# migrate-tag-schema.sh

echo "🔄 Migrating tag schema..."

# Migrar Owner -> ResponsibleTeam
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key="Owner" \
  --query 'ResourceTagMappingList[].[ResourceARN,Tags[?Key==`Owner`].Value]' \
  --output text | while read -r arn owner; do
    
    # Agregar nuevo tag
    ./scripts/auto-tagger.sh \
      --resource-arn "$arn" \
      --additional-tags "ResponsibleTeam=$owner"
    
    echo "  ✅ Migrated Owner to ResponsibleTeam for $arn"
done
```

---

## 📚 Recursos Adicionales

### **Documentación**
- [TAGGING.md](./TAGGING.md) - Documentación completa del sistema
- [módulo tags README](./calavia-eks-infra/modules/tags/README.md) - Documentación del módulo
- [scripts README](./scripts/README.md) - Documentación de scripts

### **Scripts Disponibles**
- `tag-compliance-report.sh` - Reportes de compliance
- `auto-tagger.sh` - Tagging automático
- `demo-tagging-system.sh` - Demo del sistema
- `cleanup-obsolete-tags.sh` - Limpieza de tags

### **Integración con Otras Herramientas**
- **Infracost**: Análisis de costes con tags
- **AWS Budgets**: Presupuestos por tags
- **CloudWatch**: Métricas de compliance
- **Grafana**: Dashboards de tagging
- **Slack**: Notificaciones automáticas

---

*Este documento se actualiza regularmente. Última actualización: Agosto 2025*
