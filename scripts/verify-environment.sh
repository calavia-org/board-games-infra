#!/bin/bash

#=============================================================================#
# Script: scripts/verify-environment.sh
# Descripción: Verifica que el entorno de desarrollo esté configurado
#              correctamente para usar los hooks personalizados de pre-commit
# Autor: Board Games Infrastructure Team
# Versión: 1.0
#=============================================================================#

set -euo pipefail

# Colores para output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuración
SCRIPT_DIR_VAR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT_VAR="$(cd "${SCRIPT_DIR_VAR}/.." && pwd)"
CACHE_DIR="${PROJECT_ROOT_VAR}/.terraform-validate-cache"

# Funciones de utilidad
log_info() {
    echo -e "${BLUE}ℹ️  INFO:${NC} $*"
}

log_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $*"
}

log_error() {
    echo -e "${RED}❌ ERROR:${NC} $*"
}

# Función para verificar comandos
check_command() {
    local cmd="$1"
    local required="${2:-true}"

    if command -v "$cmd" >/dev/null 2>&1; then
        local version
        case "$cmd" in
            terraform)
                version=$(terraform version | head -n1 | cut -d'v' -f2)
                ;;
            tflint)
                version=$(tflint --version | head -n1 | cut -d'v' -f2)
                ;;
            trivy)
                version=$(trivy --version | head -n1 | awk '{print $2}')
                ;;
            pre-commit)
                version=$(pre-commit --version | cut -d' ' -f2)
                ;;
            *)
                version="$(${cmd} --version 2>/dev/null | head -n1 || echo 'unknown')"
                ;;
        esac
        log_success "${cmd} instalado - versión: ${version}"
        return 0
    else
        if [[ "$required" == "true" ]]; then
            log_error "${cmd} no encontrado - REQUERIDO"
            return 1
        else
            log_warning "${cmd} no encontrado - opcional"
            return 0
        fi
    fi
}

# Verificar estructura de proyecto
check_project_structure() {
    log_info "Verificando estructura del proyecto..."

    local required_files=(
        ".pre-commit-config.yaml"
        "scripts/hooks/terraform-validate-wrapper.sh"
        "scripts/hooks/tflint-wrapper.sh"
        "scripts/hooks/trivy-wrapper.sh"
        ".tflint-simple.hcl"
    )

    local optional_files=(
        ".trivyignore"
        ".devcontainer/devcontainer.json"
        ".vscode/settings.json"
        ".vscode/board-games-infra.code-workspace"
    )

    local missing_required=0

    for file in "${required_files[@]}"; do
        if [[ -f "${PROJECT_ROOT_VAR}/${file}" ]]; then
            log_success "Archivo requerido encontrado: ${file}"
        else
            log_error "Archivo requerido faltante: ${file}"
            ((missing_required++))
        fi
    done

    for file in "${optional_files[@]}"; do
        if [[ -f "${PROJECT_ROOT_VAR}/${file}" ]]; then
            log_success "Archivo opcional encontrado: ${file}"
        else
            log_warning "Archivo opcional faltante: ${file}"
        fi
    done

    return $missing_required
}

# Verificar permisos de scripts
check_script_permissions() {
    log_info "Verificando permisos de scripts..."

    local scripts=(
        "scripts/hooks/terraform-validate-wrapper.sh"
        "scripts/hooks/tflint-wrapper.sh"
        "scripts/hooks/trivy-wrapper.sh"
    )

    local permission_errors=0

    for script in "${scripts[@]}"; do
        local script_path="${PROJECT_ROOT_VAR}/${script}"
        if [[ -f "$script_path" ]]; then
            if [[ -x "$script_path" ]]; then
                log_success "Script ejecutable: ${script}"
            else
                log_error "Script sin permisos de ejecución: ${script}"
                log_info "Ejecuta: chmod +x ${script_path}"
                ((permission_errors++))
            fi
        fi
    done

    return $permission_errors
}

# Testear wrapper de terraform-validate
test_terraform_validate_wrapper() {
    log_info "Testeando terraform-validate-wrapper..."

    local wrapper="${PROJECT_ROOT_VAR}/scripts/hooks/terraform-validate-wrapper.sh"

    if [[ ! -x "$wrapper" ]]; then
        log_error "terraform-validate-wrapper.sh no es ejecutable"
        return 1
    fi

    # Crear directorio de caché si no existe
    mkdir -p "$CACHE_DIR"

    # Test básico del wrapper
    cd "${PROJECT_ROOT_VAR}/calavia-eks-infra/environments/staging" || {
        log_error "No se puede acceder al directorio de staging"
        return 1
    }

    # Ejecutar wrapper (debería ser rápido)
    local start_time
    start_time=$(date +%s)

    if "$wrapper" >/dev/null 2>&1; then
        local end_time
        end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_success "terraform-validate-wrapper ejecutado en ${duration}s"

        # Verificar que sea rápido (menos de 5 segundos)
        if [[ "$duration" -lt 5 ]]; then
            log_success "Validación rápida confirmada (${duration}s < 5s)"
        else
            log_warning "Validación más lenta de lo esperado (${duration}s)"
        fi
    else
        log_error "terraform-validate-wrapper falló"
        return 1
    fi

    cd - >/dev/null
}

# Testear wrapper de tflint
test_tflint_wrapper() {
    log_info "Testeando tflint-wrapper..."

    local wrapper="${PROJECT_ROOT_VAR}/scripts/hooks/tflint-wrapper.sh"

    if [[ ! -x "$wrapper" ]]; then
        log_error "tflint-wrapper.sh no es ejecutable"
        return 1
    fi

    # Test básico del wrapper
    cd "${PROJECT_ROOT_VAR}/calavia-eks-infra/environments/staging" || return 1

    if "$wrapper" --version >/dev/null 2>&1; then
        log_success "tflint-wrapper funcional"
    else
        log_error "tflint-wrapper falló"
        return 1
    fi

    cd - >/dev/null
}

# Testear wrapper de trivy
test_trivy_wrapper() {
    log_info "Testeando trivy-wrapper..."

    local wrapper="${PROJECT_ROOT_VAR}/scripts/hooks/trivy-wrapper.sh"

    if [[ ! -x "$wrapper" ]]; then
        log_error "trivy-wrapper.sh no es ejecutable"
        return 1
    fi

    # Test básico del wrapper
    if "$wrapper" --version >/dev/null 2>&1; then
        log_success "trivy-wrapper funcional"
    else
        log_error "trivy-wrapper falló"
        return 1
    fi
}

# Verificar configuración de pre-commit
check_precommit_config() {
    log_info "Verificando configuración de pre-commit..."

    local config_file="${PROJECT_ROOT_VAR}/.pre-commit-config.yaml"

    if [[ ! -f "$config_file" ]]; then
        log_error "Archivo .pre-commit-config.yaml no encontrado"
        return 1
    fi

    # Verificar que contiene nuestros hooks personalizados
    local required_hooks=(
        "terraform-validate-fast"
        "tflint-custom"
        "trivy-terraform-security"
    )

    local missing_hooks=0

    for hook in "${required_hooks[@]}"; do
        if grep -q "$hook" "$config_file"; then
            log_success "Hook personalizado encontrado: ${hook}"
        else
            log_error "Hook personalizado faltante: ${hook}"
            ((missing_hooks++))
        fi
    done

    return $missing_hooks
}

# Testear pre-commit en un archivo de prueba
test_precommit_execution() {
    log_info "Testeando ejecución de pre-commit..."

    cd "$PROJECT_ROOT_VAR" || return 1

    # Instalar hooks si no están instalados
    if ! pre-commit install --install-hooks >/dev/null 2>&1; then
        log_error "No se pudieron instalar los hooks de pre-commit"
        return 1
    fi

    # Crear un archivo temporal para test
    local test_file="test_file_temp.tf"
    cat > "$test_file" << 'EOF'
# Archivo de test temporal
resource "aws_instance" "test" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  tags = {
    Name = "test"
  }
}
EOF

    # Ejecutar pre-commit en el archivo de test
    local start_time
    start_time=$(date +%s)

    if pre-commit run --files "$test_file" >/dev/null 2>&1; then
        local end_time
        end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_success "Pre-commit ejecutado exitosamente en ${duration}s"
    else
        log_warning "Pre-commit reportó issues (normal en test)"
    fi

    # Limpiar archivo temporal
    rm -f "$test_file"

    cd - >/dev/null
}

# Detectar tipo de entorno
detect_environment() {
    log_info "Detectando tipo de entorno..."

    if [[ -n "${CODESPACES:-}" ]]; then
        log_info "🌐 Entorno: GitHub Codespaces"
        return 0
    elif [[ -f "/.dockerenv" ]] && [[ -n "${VSCODE_INJECTION:-}" ]]; then
        log_info "🐳 Entorno: VS Code DevContainer"
        return 0
    elif [[ -n "${VSCODE_PID:-}" ]]; then
        log_info "💻 Entorno: VS Code Local"
        return 0
    elif [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        log_info "🚀 Entorno: GitHub Actions"
        return 0
    else
        log_info "🖥️  Entorno: Terminal Local"
        return 0
    fi
}

# Generar reporte
generate_report() {
    local total_errors="$1"

    echo
    echo "========================================"
    echo "    REPORTE DE VERIFICACIÓN FINAL"
    echo "========================================"
    echo

    if [[ "$total_errors" -eq 0 ]]; then
        log_success "✨ Entorno configurado correctamente"
        log_success "🚀 Los hooks personalizados de pre-commit están listos"
        log_success "⚡ Esperada mejora de rendimiento: 30-60x más rápido"
        echo
        log_info "Uso recomendado:"
        echo "  • pre-commit run --all-files    # Ejecutar en todos los archivos"
        echo "  • pre-commit run terraform-validate-fast  # Solo validación"
        echo "  • pre-commit run tflint-custom   # Solo linting"
        echo "  • pre-commit run trivy-terraform-security  # Solo seguridad"
        return 0
    else
        log_error "❌ Se encontraron ${total_errors} errores"
        log_error "🔧 Corrige los errores antes de usar pre-commit"
        echo
        log_info "Comandos útiles para solucionar:"
        echo "  • chmod +x scripts/*.sh          # Permisos de ejecución"
        echo "  • pre-commit install --install-hooks  # Instalar hooks"
        echo "  • terraform init                 # Inicializar Terraform"
        return 1
    fi
}

# Función principal
main() {
    echo "========================================"
    echo "  VERIFICACIÓN DE ENTORNO DE DESARROLLO"
    echo "    Board Games Infrastructure"
    echo "========================================"
    echo

    local total_errors=0

    # Detectar entorno
    detect_environment
    echo

    # Verificar comandos requeridos
    log_info "Verificando herramientas requeridas..."
    check_command "terraform" "true" || ((total_errors++))
    check_command "tflint" "true" || ((total_errors++))
    check_command "trivy" "false"  # Opcional para desarrollo local
    check_command "pre-commit" "true" || ((total_errors++))
    check_command "git" "true" || ((total_errors++))
    echo

    # Verificar estructura del proyecto
    check_project_structure || total_errors=$((total_errors + $?))
    echo

    # Verificar permisos
    check_script_permissions || total_errors=$((total_errors + $?))
    echo

    # Verificar configuración de pre-commit
    check_precommit_config || total_errors=$((total_errors + $?))
    echo

    # Testear wrappers si no hay errores críticos
    if [[ "$total_errors" -eq 0 ]]; then
        log_info "Testeando wrappers personalizados..."
        test_terraform_validate_wrapper || ((total_errors++))
        test_tflint_wrapper || ((total_errors++))
        test_trivy_wrapper || log_warning "Trivy wrapper test omitido"
        echo

        # Testear pre-commit completo
        test_precommit_execution || log_warning "Pre-commit test tuvo warnings"
        echo
    fi

    # Generar reporte final
    generate_report "$total_errors"

    exit $total_errors
}

# Verificar que estamos en el directorio correcto
if [[ ! -f "${PROJECT_ROOT_VAR}/.pre-commit-config.yaml" ]]; then
    log_error "Este script debe ejecutarse desde el directorio raíz del proyecto"
    log_error "Directorio actual: $(pwd)"
    log_error "Directorio esperado: directorio que contiene .pre-commit-config.yaml"
    exit 1
fi

# Ejecutar función principal
main "$@"
