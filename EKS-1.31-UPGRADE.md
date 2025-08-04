# Actualización EKS a Versión 1.31

## Resumen de la Actualización
Migración de EKS desde la versión 1.28 a la versión **1.31** (la más reciente disponible en Agosto 2025) para evitar la necesidad de soporte extendido y obtener las últimas características de seguridad y rendimiento.

## Motivación
- **🔒 Soporte Completo**: Versión 1.31 tiene soporte completo de AWS sin necesidad de soporte extendido
- **🛡️ Seguridad**: Últimas correcciones de seguridad y vulnerabilidades patcheadas
- **⚡ Rendimiento**: Mejoras de rendimiento y optimizaciones más recientes
- **🔧 Características**: Acceso a las últimas características de Kubernetes

## Cambios Realizados

### 1. Versión del Cluster EKS
```hcl
# Antes
kubernetes_version = "1.28"

# Después  
kubernetes_version = "1.31"  # Latest stable version (August 2025)
```

### 2. Addons de EKS Actualizados

| Addon | Versión Anterior | Nueva Versión | Beneficios |
|-------|------------------|---------------|------------|
| **kube-proxy** | `v1.28.2-eksbuild.2` | `v1.31.0-eksbuild.3` | Mejor networking, bug fixes |
| **vpc-cni** | `v1.15.1-eksbuild.1` | `v1.18.1-eksbuild.1` | Mejor gestión de IPs, IPv6 support |
| **aws-ebs-csi-driver** | `v1.25.0-eksbuild.1` | `v1.32.0-eksbuild.1` | Mejor gestión de volumes, snapshots |

### 3. Infraestructura Versioning
```hcl
# Actualizada versión de infraestructura
infrastructure_version = "2.0.0"  # EKS 1.31 + Graviton migration
```

### 4. Tags de Arquitectura
```hcl
# Actualizado para reflejar migración a Graviton
Architecture = "arm64"  # Updated from x86_64
```

## Nuevas Características de EKS 1.31

### 🚀 Kubernetes 1.31 Features
- **AppArmor Support**: Mejor aislamiento de contenedores
- **CEL for Admission Control**: Validación más potente
- **Persistent Volume Last Phase Transition Time**: Mejor debugging de volúmenes
- **Recursive Read-only Mounts**: Mejor gestión de seguridad
- **Service Account Token Node Binding**: Seguridad mejorada

### 🔧 AWS EKS Específico
- **Enhanced Cluster Logging**: Mejor observabilidad
- **Improved IRSA (IAM Roles for Service Accounts)**: Mejor integración con IAM
- **Updated AL2023 Node AMIs**: Mejor seguridad y rendimiento en nodos
- **IPv6 Support Improvements**: Mejor soporte para redes IPv6

## Compatibilidad y Consideraciones

### ✅ Compatibilidad Asegurada
- **Graviton2/3**: EKS 1.31 totalmente compatible con ARM64
- **Container Images**: Todas las imágenes base soportan Kubernetes 1.31
- **Helm Charts**: Charts populares compatibles con K8s 1.31
- **Operators**: Operators comunes actualizados para 1.31

### ⚠️ Consideraciones de Migración
1. **Application Compatibility**: Verificar que aplicaciones funcionen con K8s 1.31
2. **API Deprecations**: Revisar APIs depreciadas que podrían afectar workloads
3. **RBAC Changes**: Posibles cambios en permisos por defecto
4. **Network Policies**: Posibles cambios en comportamiento de red

## Ciclo de Vida de Versiones EKS

### Versiones Soportadas (Agosto 2025)
| Versión | Estado | Fin de Soporte | Recomendación |
|---------|--------|----------------|---------------|
| **1.31** | ✅ Actual | ~Feb 2026 | **RECOMENDADA** |
| **1.30** | ✅ Soportada | ~Nov 2025 | OK |
| **1.29** | ✅ Soportada | ~Ago 2025 | Actualizar pronto |
| **1.28** | ⚠️ Deprecada | ~Mayo 2025 | **ACTUALIZAR** |

### Beneficios de Estar en Versión Actual
- **🆓 Sin coste de soporte extendido**
- **🔄 Actualizaciones automáticas de AMI**
- **🛡️ Parches de seguridad más recientes**
- **📞 Soporte completo de AWS**

## Validación Post-Actualización

### 1. Verificación del Cluster
```bash
# Verificar versión del cluster
kubectl version --short

# Verificar nodos
kubectl get nodes -o wide

# Verificar addons
kubectl get pods -n kube-system
```

### 2. Testing de Aplicaciones
```bash
# Verificar deployments
kubectl get deployments --all-namespaces

# Verificar servicios
kubectl get services --all-namespaces

# Verificar ingresses
kubectl get ingress --all-namespaces
```

### 3. Monitoreo
- **CloudWatch Metrics**: Verificar métricas del cluster
- **Node Health**: Confirmar que todos los nodos están Ready
- **Pod Status**: Asegurar que pods están funcionando correctamente

## Rollback Plan

### Si hay problemas:
1. **Immediate Rollback**: Terraform permite rollback a versión anterior
2. **Node Group Strategy**: Rollback gradual por node groups
3. **Application First**: Verificar aplicaciones antes que infraestructura

### Comando de Rollback
```bash
# En caso de emergencia - rollback a 1.30
terraform apply -var="kubernetes_version=1.30"
```

## Cronograma de Implementación

### Fase 1: Staging (Semana 1)
- [ ] Deploy EKS 1.31 en staging
- [ ] Testing completo de aplicaciones
- [ ] Validación de monitoreo

### Fase 2: Production (Semana 2)
- [ ] Deploy gradual en producción
- [ ] Monitoreo 24/7 durante rollout
- [ ] Validación de performance

### Fase 3: Optimización (Semana 3)
- [ ] Tuning de performance
- [ ] Review de métricas
- [ ] Documentación de lessons learned

## Referencias
- [EKS Version Support Policy](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)
- [Kubernetes 1.31 Release Notes](https://kubernetes.io/blog/2024/08/13/kubernetes-v1-31-release/)
- [EKS Add-ons Versions](https://docs.aws.amazon.com/eks/latest/userguide/managing-add-ons.html)

---
**Nota Importante**: Esta actualización requiere testing completo en staging antes del deployment en producción debido a los cambios significativos entre K8s 1.28 y 1.31.
