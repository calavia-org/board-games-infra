# Monitoring Module

Este módulo despliega un stack completo de monitoreo para la infraestructura de gaming en Kubernetes, incluyendo Prometheus, Grafana, AlertManager y integración con AWS Managed Grafana.

## Componentes

### 1. Kube-Prometheus-Stack
- **Prometheus**: Servidor de métricas con retención configurable
- **Grafana**: Dashboards para visualización de métricas
- **AlertManager**: Gestión de alertas y notificaciones
- **Node Exporter**: Métricas de nodos del cluster
- **Kube State Metrics**: Métricas del estado de Kubernetes

### 2. AWS Managed Grafana
- Workspace de Grafana completamente gestionado
- Integración con CloudWatch y Prometheus
- Acceso SSO y gestión de usuarios

### 3. CloudWatch Integration
- Log groups para almacenamiento de logs
- Métricas de AWS services
- Dashboards nativos de AWS

### 4. Alerting & Notifications
- Reglas de alertas personalizadas para gaming
- Notificaciones por email y Slack
- Integración con SNS para alertas críticas

## Características

### Seguridad
- IRSA (IAM Roles for Service Accounts) para acceso seguro a AWS
- Encryption at rest para almacenamiento
- Network policies para aislamiento

### Escalabilidad
- Configuración de recursos ajustable por ambiente
- Retención de datos configurable
- Storage classes optimizadas

### Observabilidad
- Métricas de infraestructura (EKS, RDS, Redis)
- Métricas de aplicación (game servers)
- Métricas de red y storage
- Trazabilidad completa

## Configuración

### Variables de Entrada

| Variable | Descripción | Tipo | Requerida |
|----------|-------------|------|-----------|
| `cluster_name` | Nombre del cluster EKS | string | ✅ |
| `namespace` | Namespace para desplegar monitoring | string | ✅ |
| `environment` | Ambiente (staging/production) | string | ✅ |
| `retention_days` | Días de retención de métricas | number | ✅ |
| `prometheus_role_arn` | ARN del rol IAM para Prometheus | string | ✅ |
| `grafana_admin_password` | Password de admin para Grafana | string | ✅ |
| `email_notifications` | Email para notificaciones | string | ✅ |
| `slack_webhook_url` | URL de webhook para Slack | string | ❌ |
| `prometheus_storage` | Tamaño de storage para Prometheus | string | ❌ |
| `grafana_storage` | Tamaño de storage para Grafana | string | ❌ |
| `alertmanager_storage` | Tamaño de storage para AlertManager | string | ❌ |

### Configuración por Ambiente

#### Production
- Retención: 3 días
- Storage Prometheus: 50Gi
- Storage Grafana: 10Gi
- Réplicas: Alta disponibilidad

#### Staging
- Retención: 1 día
- Storage Prometheus: 20Gi
- Storage Grafana: 5Gi
- Réplicas: Configuración mínima

## Despliegue

### Prerrequisitos
1. Cluster EKS funcionando
2. Helm 3.x instalado
3. Rol IAM configurado para IRSA
4. Storage classes disponibles

### Comandos
```bash
# Aplicar la configuración de Terraform
terraform apply

# Verificar el despliegue
kubectl get pods -n monitoring

# Acceder a Grafana
kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80
```

## Monitoreo Incluido

### Infraestructura EKS
- Estado del cluster y nodos
- Utilización de CPU y memoria
- Capacidad de pods
- Estado de servicios del sistema

### Bases de Datos
- **PostgreSQL (RDS)**:
  - Conexiones activas
  - Consultas lentas
  - Replicación lag
  - Métricas de rendimiento

- **Redis (ElastiCache)**:
  - Uso de memoria
  - Conexiones
  - Comandos por segundo
  - Slow log

### Game Servers
- Latencia de requests HTTP
- Rate de errores
- Pods crash looping
- Throughput de requests

### Load Balancer (ALB)
- Tiempo de respuesta
- Targets saludables
- Rate de errores HTTP
- Distribución de tráfico

### Storage
- Utilización de PVCs
- IOPS y throughput
- Espacio disponible

## Alertas Configuradas

### Críticas
- **EKSClusterDown**: API server no disponible
- **GameServerHighErrorRate**: > 10% errores HTTP
- **DatabaseReplicationLag**: > 30s lag
- **ALBUnhealthyTargets**: Targets no saludables
- **RedisDown**: Instancia Redis no disponible

### Warnings
- **EKSHighNodeCPU**: > 90% CPU por 10 min
- **EKSHighNodeMemory**: > 90% memoria por 10 min
- **GameServerHighLatency**: > 500ms p95
- **PVCStorageUsageHigh**: > 85% storage

## Dashboards Incluidos

### Por Defecto
1. **Kubernetes Cluster Monitoring** (GrafanaLabs 7249)
2. **Kubernetes Pod Monitoring** (GrafanaLabs 6417)
3. **Node Exporter Full** (GrafanaLabs 1860)
4. **Kubernetes Ingress** (GrafanaLabs 9614)

### Personalizados
- Game Server Performance
- Database Monitoring
- Infrastructure Overview
- Alert Summary

## Outputs

| Output | Descripción |
|--------|-------------|
| `prometheus_role_arn` | ARN del rol IAM de Prometheus |
| `grafana_workspace_id` | ID del workspace de AWS Managed Grafana |
| `grafana_workspace_url` | URL del workspace de Grafana |
| `sns_topic_arn` | ARN del topic SNS para alertas |
| `cloudwatch_log_group_name` | Nombre del log group de CloudWatch |

## Troubleshooting

### Prometheus no scrapeando métricas
```bash
# Verificar ServiceMonitors
kubectl get servicemonitors -n monitoring

# Verificar configuración de Prometheus
kubectl get prometheus -n monitoring -o yaml
```

### Grafana no accessible
```bash
# Verificar pod status
kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana

# Verificar logs
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana
```

### Alertas no llegando
```bash
# Verificar configuración de AlertManager
kubectl get alertmanager -n monitoring -o yaml

# Verificar secret de configuración
kubectl get secret -n monitoring alertmanager-kube-prometheus-stack-alertmanager
```

## Mantenimiento

### Actualización de Dashboards
1. Editar archivos en `dashboards/` 
2. Aplicar cambios con `terraform apply`

### Actualización de Reglas de Alertas
1. Modificar `prometheus-rules.yml`
2. Aplicar con `terraform apply`
3. Recargar configuración de Prometheus

### Backup y Restore
- Los datos se almacenan en PVCs
- Backup automático con AWS EBS snapshots
- Restore manual desde snapshots

## Enlaces Útiles

- [Prometheus Operator](https://prometheus-operator.dev/)
- [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [AWS Managed Grafana](https://docs.aws.amazon.com/grafana/)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)