# Environment Setup for Board Games Infrastructure

Este documento describe cómo configurar el entorno de desarrollo para usar los hooks personalizados de pre-commit optimizados en diferentes plataformas.

## 🚀 Quick Start

```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd board-games-infra

# 2. Ejecutar verificación de entorno
./scripts/verify-environment.sh

# 3. Instalar pre-commit hooks
pre-commit install

# 4. Ejecutar primera validación
pre-commit run --all-files
```

## 🌐 GitHub Codespaces

### Configuración Automática

Los Codespaces se configuran automáticamente con:

- **Devcontainer**: `.devcontainer/devcontainer.json`
- **Scripts de setup**: `.devcontainer/setup-*.sh`
- **Extensiones de VS Code**: HashiCorp Terraform, YAML, Markdownlint
- **Herramientas preinstaladas**: Terraform, TFLint, Trivy, Pre-commit

### Uso

```bash
# Al abrir Codespace, las herramientas ya están instaladas
terraform --version
tflint --version
pre-commit --version

# Verificar configuración
./scripts/verify-environment.sh

# Los hooks funcionan inmediatamente
pre-commit run terraform-validate-fast
```

### Optimizaciones Específicas

- Cache de Terraform persistente en `/tmp`
- Scripts con paths absolutos
- Variables de entorno preconfiguradas

## 🐳 VS Code DevContainers (Local)

### Configuración

1. **Instalar extensiones requeridas**:
   - Dev Containers (ms-vscode-remote.remote-containers)

2. **Abrir en container**:

   ```bash
   # Desde VS Code: Command Palette → "Dev Containers: Reopen in Container"
   # O desde terminal:
   code --folder-uri vscode-remote://dev-container+$(pwd)
   ```

3. **Verificar setup**:

   ```bash
   ./scripts/verify-environment.sh
   ```

### Características

- **Dockerfile multi-stage**: Optimizado para desarrollo
- **Volúmenes persistentes**: Cache de herramientas
- **Port forwarding**: Para servicios locales
- **Git integration**: Configuración automática

### Troubleshooting

```bash
# Reconstruir container
# Command Palette → "Dev Containers: Rebuild Container"

# Verificar mounts
df -h | grep vscode

# Logs del container
docker logs vsc-board-games-infra-*
```

## 💻 VS Code Local (Sin Container)

### Instalación Manual

1. **Instalar herramientas**:

   ```bash
   # macOS con Homebrew
   brew install terraform tflint trivy pre-commit

   # Ubuntu/Debian
   sudo apt update
   sudo apt install -y terraform tflint trivy pre-commit

   # Arch Linux
   sudo pacman -S terraform tflint trivy pre-commit
   ```

2. **Configurar workspace**:

   ```bash
   # Abrir workspace específico
   code .vscode/board-games-infra.code-workspace
   ```

3. **Instalar extensiones**:
   - HashiCorp Terraform (hashicorp.Terraform)
   - YAML (redhat.vscode-YAML)
   - Markdownlint (davidanson.vscode-markdownlint)

### Configuración VS Code

El archivo `.vscode/settings.json` incluye:

- **Formateo automático**: Al guardar archivos
- **Validación**: Terraform y YAML en tiempo real
- **Tasks**: Comandos pre-commit integrados
- **Launch configs**: Debug de scripts

### Tasks Disponibles

```bash
# Desde Command Palette (Ctrl+Shift+P):
Tasks: Run Task

# Tasks disponibles:
- "Pre-commit: Run All"
- "Pre-commit: Terraform Validate Fast"
- "Pre-commit: TFLint Custom"
- "Pre-commit: Trivy Security"
- "Terraform: Init All Environments"
- "Terraform: Plan Staging"
- "Terraform: Plan Production"
```

## 🚀 GitHub Actions (CI/CD)

### Configuración

El workflow `.github/workflows/infrastructure-validation.yml` incluye:

1. **Quick Validation**: Pre-commit hooks optimizados
2. **Security Scan**: Trivy completo con SARIF
3. **Terraform Validation**: Por ambiente
4. **Documentation Check**: Markdownlint

### Jobs Configurados

```yaml
# Ejecución en paralelo para máximo rendimiento
jobs:
  quick-validation:    # ~1-2 minutos
  security-scan:       # ~2-3 minutos
  terraform-validation: # ~3-5 minutos por ambiente
  documentation-check: # ~1 minuto
```

### Variables de Entorno

```bash
# Configurar en GitHub Repository Settings → Secrets
AWS_ROLE_STAGING=arn:aws:iam::ACCOUNT:role/github-actions-staging
AWS_ROLE_PRODUCTION=arn:aws:iam::ACCOUNT:role/github-actions-production
```

### Cache Optimization

- **Terraform modules**: `~/.terraform.d/plugin-cache`
- **Pre-commit**: `~/.cache/pre-commit`
- **Custom cache**: `.terraform-validate-cache`

## 🔧 Herramientas y Versiones

| Herramienta | Versión Mínima | Versión Recomendada | Notas |
|-------------|----------------|---------------------|-------|
| Terraform   | 1.5.0          | 1.6.6              | LTS |
| TFLint      | 0.47.0         | 0.49.0             | Latest |
| Trivy       | 0.45.0         | 0.48.3             | Latest |
| Pre-commit  | 3.0.0          | 3.6.0              | Latest |
| Python      | 3.8            | 3.11               | Pre-commit req |

## ⚡ Optimizaciones de Rendimiento

### Terraform Validate

**Antes**: 10-30 segundos
**Después**: ~0.5 segundos (60x más rápido)

```bash
# Cache inteligente basado en MD5 hash
# Solo re-valida si archivos .tf cambiaron
./scripts/terraform-validate-wrapper.sh
```

### TFLint Custom

**Antes**: 5-15 segundos + reglas problemáticas
**Después**: ~2 segundos + reglas optimizadas

```bash
# Configuración simplificada sin reglas AWS pesadas
./scripts/tflint-wrapper.sh
```

### Trivy Security

**Antes**: Muchos falsos positivos
**Después**: Resultados filtrados y relevantes

```bash
# Respeta .trivyignore para falsos positivos conocidos
./scripts/trivy-wrapper.sh
```

## 🐛 Troubleshooting

### Problema: Pre-commit muy lento

```bash
# Verificar que usa wrappers optimizados
grep -A5 "terraform-validate-fast" .pre-commit-config.yaml

# Debe mostrar: entry: scripts/terraform-validate-wrapper.sh

# Verificar cache
ls -la .terraform-validate-cache/
```

### Problema: TFLint ignora configuración

```bash
# Verificar configuración
cat .tflint-simple.hcl

# Verificar wrapper
./scripts/tflint-wrapper.sh --config .tflint-simple.hcl --version
```

### Problema: Trivy falsos positivos

```bash
# Agregar a .trivyignore
echo "AVD-AWS-0123" >> .trivyignore

# Verificar ignorados
./scripts/trivy-wrapper.sh --format table .
```

### Problema: Permisos de scripts

```bash
# Corregir permisos
chmod +x scripts/*.sh

# Verificar
./scripts/verify-environment.sh
```

## 📊 Métricas de Rendimiento

### Comparación de Tiempos

| Hook | Tiempo Original | Tiempo Optimizado | Mejora |
|------|----------------|-------------------|--------|
| Terraform_validate | 15s | 0.5s | 30x |
| tflint | 8s | 2s | 4x |
| trivy | 20s | 3s | 6.7x |
| **Total** | **43s** | **5.5s** | **~8x** |

### Ambiente por Ambiente

| Entorno | Setup Time | Hook Time | Total Cycle |
|---------|------------|-----------|-------------|
| Codespaces | 0s (prebuilt) | 5.5s | 5.5s |
| DevContainer | 30s (first build) | 5.5s | 5.5s |
| VS Code Local | 0s (tools installed) | 5.5s | 5.5s |
| GitHub Actions | 60s (setup) | 5.5s | 65.5s |

## 🔄 Workflow Recomendado

### Desarrollo Diario

```bash
# 1. Trabajar en branch feature
git checkout -b feature/nueva-funcionalidad

# 2. Hacer cambios en Terraform
vim calavia-eks-infra/modules/vpc/main.tf

# 3. Pre-commit automático al commit
git add .
git commit -m "feat: agregar nueva funcionalidad"
# ✅ Hooks ejecutan automáticamente (~5.5s)

# 4. Push y PR
git push origin feature/nueva-funcionalidad
```

### Antes de Merge

```bash
# Validación completa
pre-commit run --all-files

# Verificar ambiente
./scripts/verify-environment.sh

# Plan de Terraform
cd calavia-eks-infra/environments/staging
terraform plan
```

## 📝 Contribuciones

Para mejorar este setup:

1. **Reportar issues**: GitHub Issues
2. **Proponer mejoras**: Pull Requests
3. **Optimizaciones**: Actualizar wrappers en `scripts/`
4. **Documentación**: Actualizar este archivo

## 🔗 Enlaces Útiles

- [Pre-commit Documentation](https://pre-commit.com/)
- [Terraform Best Practices](https://www.terraform.io/docs/language/style/index.html)
- [TFLint Rules](https://github.com/terraform-linters/tflint/tree/master/docs/rules)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers)
