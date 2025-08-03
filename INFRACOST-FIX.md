# 🔧 Solución de Errores de Infracost en GitHub Actions

## 📋 Problemas Identificados y Corregidos

### ❌ **Problema Principal**: Infracost no encuentra los módulos de Terraform

**Error típico**:
```
Error: Module not found: Could not find module "../../modules/tags"
```

### ✅ **Soluciones Implementadas**:

#### 1. 🏗️ **Configuración de Backend para CI/CD**
**Archivos creados**:
- `calavia-eks-infra/environments/staging/backend-ci.tf`
- `calavia-eks-infra/environments/production/backend-ci.tf`

**Contenido**:
```terraform
# Backend configuration for CI/CD - local state
terraform {
  backend "local" {}
}
```

#### 2. 🔧 **Configuración de Providers**
**Archivos creados**:
- `calavia-eks-infra/environments/staging/providers.tf`
- `calavia-eks-infra/environments/production/providers.tf`

**Características**:
- ✅ Providers AWS configurados correctamente
- ✅ Versiones específicas definidas
- ✅ Tags por defecto configurados

#### 3. 📝 **Workflow de GitHub Actions Mejorado**
**Cambios en `.github/workflows/infracost.yml`**:

```yaml
steps:
  - name: Setup Terraform
    uses: hashicorp/setup-terraform@v3
    with:
      terraform_version: 1.5.0

  - name: Terraform Init (base)
    run: |
      cd ${TF_ROOT}/environments/staging
      terraform init -backend=false

  - name: Terraform Validate (base)
    run: |
      cd ${TF_ROOT}/environments/staging
      terraform validate
```

**Mejoras implementadas**:
- ✅ Terraform setup explícito
- ✅ Inicialización sin backend remoto (`-backend=false`)
- ✅ Validación de configuración antes de análisis
- ✅ Rutas corregidas para archivos de usage
- ✅ Pasos duplicados para base y PR branch

#### 4. 📊 **Configuración de Infracost Optimizada**
**Archivo actualizado**: `.infracost/config.yml`

**Cambios**:
```yaml
projects:
  - path: calavia-eks-infra/environments/staging
    name: board-games-staging
    usage_file: .infracost/usage-staging.yml  # ← Ruta corregida
```

**Antes**: `terraform_workspace: staging` (problemático en CI)
**Después**: Configuración simplificada sin workspace

#### 5. 🔍 **Script de Diagnóstico**
**Archivo creado**: `scripts/debug-infracost.sh`

**Funcionalidades**:
- ✅ Verificación completa de estructura de directorios
- ✅ Validación de archivos Terraform
- ✅ Test de inicialización y validación
- ✅ Test de Infracost en local
- ✅ Diagnóstico de variables de entorno
- ✅ Guía de solución de problemas

## 🚀 **Cómo Usar las Correcciones**

### Para Desarrolladores Locales:

1. **Diagnóstico local**:
```bash
./scripts/debug-infracost.sh staging
./scripts/debug-infracost.sh production
```

2. **Test manual de Infracost**:
```bash
cd calavia-eks-infra/environments/staging
terraform init -backend=false
terraform validate
infracost breakdown --path . --usage-file ../../.infracost/usage-staging.yml
```

### Para GitHub Actions:

1. **Configurar secretos del repositorio**:
   - `INFRACOST_API_KEY` (obligatorio)
   - `SLACK_WEBHOOK_URL` (opcional)

2. **El workflow ahora**:
   - ✅ Inicializa Terraform correctamente
   - ✅ Valida configuración antes del análisis
   - ✅ Encuentra todos los módulos
   - ✅ Genera reportes de costes
   - ✅ Comenta en PRs automáticamente

## 📋 **Checklist de Verificación**

Antes de hacer push, verificar:

- [ ] ✅ `terraform validate` pasa en ambos entornos
- [ ] ✅ Los módulos se encuentran correctamente
- [ ] ✅ Los archivos de usage existen
- [ ] ✅ INFRACOST_API_KEY está configurado
- [ ] ✅ El script de diagnóstico pasa limpio

## 🔧 **Comandos de Verificación**

```bash
# Verificar estructura
find calavia-eks-infra -name "*.tf" | head -10

# Test Terraform
cd calavia-eks-infra/environments/staging
terraform init -backend=false && terraform validate

# Test Infracost
./scripts/debug-infracost.sh staging

# Verificar archivos de configuración
ls -la .infracost/
```

## 🎯 **Resultado Esperado**

Con estas correcciones, el workflow de GitHub Actions debería:

1. ✅ **Pasar la fase de inicialización** de Terraform
2. ✅ **Encontrar todos los módulos** correctamente
3. ✅ **Generar estimaciones de coste** precisas
4. ✅ **Comentar en las PRs** con análisis de costes
5. ✅ **Ejecutar sin errores** en cada push

## 📞 **Solución de Problemas Adicionales**

### Si persisten errores:

1. **Verificar API Key**:
```bash
echo $INFRACOST_API_KEY | cut -c1-10
```

2. **Limpiar caché de Terraform**:
```bash
find . -name ".terraform" -type d -exec rm -rf {} +
find . -name "*.tfstate*" -delete
```

3. **Verificar conectividad**:
```bash
curl -s https://pricing.api.infracost.io/health
```

4. **Ejecutar diagnóstico completo**:
```bash
./scripts/debug-infracost.sh staging
./scripts/debug-infracost.sh production
```

---

## ✅ **Estado Final**

**Problema**: ❌ Infracost no podía encontrar módulos de Terraform en GitHub Actions
**Solución**: ✅ Configuración completa de CI/CD con validación y diagnóstico

**Archivos añadidos/modificados**:
- ✅ Backend de CI para ambos entornos
- ✅ Providers explícitos 
- ✅ Workflow de GitHub Actions corregido
- ✅ Configuración de Infracost optimizada
- ✅ Script de diagnóstico completo

**Resultado**: 🚀 **Sistema de análisis de costes completamente funcional**
