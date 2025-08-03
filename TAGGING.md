# Sistema de Tagging Completo y Profesional

## 🏷️ Estrategia de Tags

Este sistema implementa una estrategia de tagging completa y consistente para todos los recursos de AWS, permitiendo:

- **Control de costes detallado** por proyecto, entorno, centro de coste y propietario
- **Gestión de lifecycle** automatizada con fechas de creación y vencimiento
- **Compliance y auditoría** con tags obligatorios y opcionales
- **Automatización** de labores de mantenimiento
- **Reporting** y facturación granular

## 📋 Taxonomía de Tags

### 🔴 **Tags Obligatorios** (Required)
Todos los recursos DEBEN tener estos tags:

| Tag | Descripción | Valores Permitidos | Ejemplo |
|-----|-------------|-------------------|---------|
| `Environment` | Entorno de despliegue | `production`, `staging`, `development`, `testing` | `production` |
| `Project` | Nombre del proyecto | Nombre del proyecto | `board-games` |
| `Owner` | Equipo/persona responsable | Email o nombre del equipo | `devops@calavia.org` |
| `CostCenter` | Centro de coste para facturación | Código de centro de coste | `CC-001-GAMING` |
| `ManagedBy` | Herramienta de gestión | `terraform`, `manual`, `k8s` | `terraform` |

### 🟡 **Tags de Negocio** (Business)
Tags relacionados con el negocio y la organización:

| Tag | Descripción | Valores | Ejemplo |
|-----|-------------|---------|---------|
| `BusinessUnit` | Unidad de negocio | Nombre de la unidad | `Gaming-Platform` |
| `Department` | Departamento | `Engineering`, `DevOps`, `QA` | `Engineering` |
| `Purpose` | Propósito del recurso | Descripción breve | `game-server-database` |
| `Criticality` | Criticidad del recurso | `critical`, `high`, `medium`, `low` | `critical` |

### 🟢 **Tags Técnicos** (Technical)
Tags relacionados con aspectos técnicos:

| Tag | Descripción | Valores | Ejemplo |
|-----|-------------|---------|---------|
| `Component` | Componente de la arquitectura | Nombre del componente | `database`, `load-balancer` |
| `Service` | Servicio AWS | Nombre del servicio | `RDS`, `EKS`, `ElastiCache` |
| `Version` | Versión del recurso | Versión semántica | `1.2.3` |
| `Architecture` | Arquitectura del sistema | `x86_64`, `arm64` | `x86_64` |

### 🔵 **Tags de Lifecycle** (Lifecycle)
Tags para gestión del ciclo de vida:

| Tag | Descripción | Formato | Ejemplo |
|-----|-------------|---------|---------|
| `CreatedBy` | Usuario/proceso que creó | Email o sistema | `terraform-ci` |
| `CreatedDate` | Fecha de creación | `YYYY-MM-DD` | `2025-08-03` |
| `ExpiryDate` | Fecha de vencimiento | `YYYY-MM-DD` | `2026-08-03` |
| `MaintenanceWindow` | Ventana de mantenimiento | `WEEKDAY-HH:MM` | `Sunday-03:00` |

### 🟣 **Tags de Costes** (Cost Management)
Tags específicos para control de costes:

| Tag | Descripción | Valores | Ejemplo |
|-----|-------------|---------|---------|
| `BillingProject` | Proyecto de facturación | Código de proyecto | `BG-2025-Q3` |
| `BudgetAlerts` | Habilitar alertas de presupuesto | `enabled`, `disabled` | `enabled` |
| `CostOptimization` | Candidato para optimización | `candidate`, `optimized`, `excluded` | `candidate` |
| `ReservedInstance` | Candidato para RI | `yes`, `no`, `purchased` | `candidate` |

## 🎯 **Tags por Tipo de Recurso**

### **Base de Datos (RDS)**
```hcl
tags = merge(local.common_tags, {
  Component        = "database"
  Service          = "RDS"
  Purpose          = "game-data-storage"
  Criticality      = "critical"
  MaintenanceWindow = "Sunday-03:00"
  BackupRetention  = "30-days"
  ReservedInstance = "candidate"
})
```

### **Clúster EKS**
```hcl
tags = merge(local.common_tags, {
  Component       = "container-orchestration"
  Service         = "EKS"
  Purpose         = "game-server-runtime"
  Criticality     = "critical"
  AutoScaling     = "enabled"
  NodeCount       = "3-10"
})
```

### **Cache (ElastiCache)**
```hcl
tags = merge(local.common_tags, {
  Component       = "cache"
  Service         = "ElastiCache"
  Purpose         = "session-cache"
  Criticality     = "high"
  EngineType      = "redis"
  ReservedInstance = "candidate"
})
```

## 🔧 **Implementación Técnica**

### **Variables Centralizadas**
```hcl
variable "common_tags" {
  description = "Tags comunes aplicados a todos los recursos"
  type        = map(string)
  default     = {}
}

variable "environment_specific_tags" {
  description = "Tags específicos del entorno"
  type        = map(string)
  default     = {}
}
```

### **Locals de Tagging**
```hcl
locals {
  # Tags obligatorios base
  mandatory_tags = {
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner_email
    CostCenter  = var.cost_center
    ManagedBy   = "terraform"
  }

  # Tags de negocio
  business_tags = {
    BusinessUnit = var.business_unit
    Department   = var.department
    Criticality  = var.criticality
  }

  # Tags técnicos
  technical_tags = {
    CreatedBy     = "terraform"
    CreatedDate   = formatdate("YYYY-MM-DD", timestamp())
    Version       = var.infrastructure_version
    Architecture  = "x86_64"
  }

  # Tags de costes
  cost_tags = {
    BillingProject    = var.billing_project
    BudgetAlerts      = "enabled"
    CostOptimization  = "candidate"
  }

  # Combinación de todos los tags
  common_tags = merge(
    local.mandatory_tags,
    local.business_tags,
    local.technical_tags,
    local.cost_tags,
    var.common_tags
  )
}
```

## 📊 **Uso para Control de Costes**

### **Filtros de Cost Explorer**
```bash
# Costes por Environment
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=DIMENSION,Key=LINKED_ACCOUNT \
  --group-by Type=TAG,Key=Environment

# Costes por Project
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=TAG,Key=Project \
  --group-by Type=TAG,Key=Component

# Costes por Cost Center
aws ce get-cost-and-usage \
  --time-period Start=2025-08-01,End=2025-08-31 \
  --group-by Type=TAG,Key=CostCenter \
  --filter-by Dimensions,Key=SERVICE,Values=AmazonRDS,AmazonEKS
```

### **Presupuestos por Tags**
```bash
# Budget por Environment
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget BudgetName=staging-environment,BudgetLimit=Amount=500,Unit=USD,TimeUnit=MONTHLY \
  --cost-filters TagKey=Environment,Values=staging
```

## 🔍 **Auditoría y Compliance**

### **Validación de Tags Obligatorios**
```bash
# Script para verificar recursos sin tags obligatorios
aws resourcegroupstaggingapi get-resources \
  --resource-type-filters "AWS::RDS::DBInstance" "AWS::EKS::Cluster" \
  --tag-filters Key=Environment \
  --query 'ResourceTagMappingList[?length(Tags) == `0`]'
```

### **Reportes de Compliance**
```bash
# Generar reporte de compliance de tags
./scripts/tag-compliance-report.sh --format html --email devops@calavia.org
```

## 🤖 **Automatización**

### **Tag Policies (AWS Organizations)**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireMandatoryTags",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "rds:CreateDBInstance",
        "eks:CreateCluster"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestedRegion": "false",
          "aws:RequestTag/Environment": "true",
          "aws:RequestTag/Project": "true",
          "aws:RequestTag/Owner": "true",
          "aws:RequestTag/CostCenter": "true"
        }
      }
    }
  ]
}
```

### **Lambda para Auto-Tagging**
```python
import boto3
import json
from datetime import datetime

def lambda_handler(event, context):
    """Auto-tag recursos nuevos con tags obligatorios"""
    
    # Tags base automáticos
    auto_tags = {
        'CreatedBy': 'auto-tagger-lambda',
        'CreatedDate': datetime.now().strftime('%Y-%m-%d'),
        'ManagedBy': 'lambda-auto-tagger'
    }
    
    # Procesar eventos de CloudTrail
    for record in event['Records']:
        # Lógica de auto-tagging basada en eventos
        pass
    
    return {
        'statusCode': 200,
        'body': json.dumps('Auto-tagging completado')
    }
```

## 📈 **Métricas y KPIs**

### **KPIs de Tagging**
- **Compliance Rate**: % de recursos con tags obligatorios
- **Cost Allocation**: % de costes asignados correctamente
- **Automation Rate**: % de recursos taggeados automáticamente
- **Lifecycle Management**: % de recursos con fechas de vencimiento

### **Alertas Configuradas**
- ⚠️  **Compliance < 95%**: Recursos sin tags obligatorios
- 🚨 **Cost Allocation < 90%**: Costes no asignados
- 📊 **New Resources**: Recursos creados sin tags automáticos

---

*Última actualización: Agosto 2025*  
*Versión: 2.0*  
*Mantenido por: DevOps Team - Calavia Gaming Platform*
