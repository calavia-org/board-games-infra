#!/bin/bash

# Pre-commit Setup Script for Board Games Infrastructure
# Este script instala y configura pre-commit con todas las dependencias

set -e

echo "🚀 Configurando pre-commit para Board Games Infrastructure..."

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si estamos en el directorio correcto
if [ ! -f ".pre-commit-config.yaml" ]; then
    print_error "No se encontró .pre-commit-config.yaml. Ejecute este script desde la raíz del proyecto."
    exit 1
fi

print_status "Verificando dependencias del sistema..."

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar Python
if ! command_exists python3; then
    print_error "Python3 no está instalado. Por favor instálalo primero."
    exit 1
fi

# Verificar pip
if ! command_exists pip3; then
    print_error "pip3 no está instalado. Por favor instálalo primero."
    exit 1
fi

# Verificar Git
if ! command_exists git; then
    print_error "Git no está instalado. Por favor instálalo primero."
    exit 1
fi

print_success "Dependencias básicas verificadas"

# Instalar pre-commit
print_status "Instalando pre-commit..."
if ! command_exists pre-commit; then
    pip3 install --user pre-commit
    print_success "pre-commit instalado"
else
    print_warning "pre-commit ya está instalado"
fi

# Instalar dependencias adicionales
print_status "Instalando dependencias adicionales..."

# yamllint
if ! command_exists yamllint; then
    pip3 install --user yamllint
    print_success "yamllint instalado"
else
    print_warning "yamllint ya está instalado"
fi

# detect-secrets
if ! pip3 show detect-secrets >/dev/null 2>&1; then
    pip3 install --user detect-secrets
    print_success "detect-secrets instalado"
else
    print_warning "detect-secrets ya está instalado"
fi

# markdownlint (Node.js)
if command_exists npm; then
    if ! command_exists markdownlint; then
        npm install -g markdownlint-cli
        print_success "markdownlint instalado"
    else
        print_warning "markdownlint ya está instalado"
    fi
else
    print_warning "npm no está disponible. markdownlint no se pudo instalar."
fi

# TFLint
if ! command_exists tflint; then
    print_status "Instalando TFLint..."
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    print_success "TFLint instalado"
else
    print_warning "TFLint ya está instalado"
fi

# TFSec
if ! command_exists tfsec; then
    print_status "Instalando TFSec..."
    curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
    print_success "TFSec instalado"
else
    print_warning "TFSec ya está instalado"
fi

# ShellCheck installation
if ! command_exists shellcheck; then
    print_status "Instalando shellcheck..."
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y shellcheck
    elif command_exists yum; then
        sudo yum install -y ShellCheck
    elif command_exists brew; then
        brew install shellcheck
    else
        print_warning "No se pudo instalar shellcheck automáticamente. Instálalo manualmente."
    fi
    print_success "shellcheck instalado"
else
    print_warning "shellcheck ya está instalado"
fi

# hadolint
if ! command_exists hadolint; then
    print_status "Instalando hadolint..."

    # Detectar arquitectura del sistema
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            HADOLINT_ARCH="x86_64"
            ;;
        aarch64|arm64)
            HADOLINT_ARCH="arm64"
            ;;
        *)
            print_warning "Arquitectura no soportada: $ARCH, usando x86_64 por defecto"
            HADOLINT_ARCH="x86_64"
            ;;
    esac

    print_status "Descargando hadolint para arquitectura: $HADOLINT_ARCH"
    wget -O hadolint "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-${HADOLINT_ARCH}"
    chmod +x hadolint
    sudo mv hadolint /usr/local/bin/
    print_success "hadolint instalado"
else
    print_warning "hadolint ya está instalado"
fi

# actionlint (Go)
if command_exists go && ! command_exists actionlint; then
    print_status "Instalando actionlint..."
    go install github.com/rhysd/actionlint/cmd/actionlint@latest
    print_success "actionlint instalado"
elif ! command_exists go; then
    print_warning "Go no está disponible. actionlint no se pudo instalar."
else
    print_warning "actionlint ya está instalado"
fi

# Instalar hooks de pre-commit
print_status "Instalando hooks de pre-commit..."
pre-commit install
pre-commit install --hook-type commit-msg
print_success "Hooks de pre-commit instalados"

# Inicializar todos los módulos de Terraform
print_status "Inicializando módulos de Terraform..."
find . -name "*.tf" -exec dirname {} \; | sort -u | while read -r dir; do
    if [ -f "$dir/main.tf" ] || [ -f "$dir/versions.tf" ]; then
        print_status "Inicializando Terraform en $dir"
        cd "$dir"
        terraform init -backend=false >/dev/null 2>&1 || print_warning "Falló la inicialización en $dir"
        cd - >/dev/null
    fi
done
print_success "Módulos de Terraform inicializados"

# Ejecutar pre-commit en todos los archivos (opcional)
echo
read -p "¿Quieres ejecutar pre-commit en todos los archivos ahora? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Ejecutando pre-commit en todos los archivos..."
    print_warning "Esto puede tomar varios minutos..."

    if pre-commit run --all-files; then
        print_success "Pre-commit ejecutado exitosamente en todos los archivos"
    else
        print_warning "Pre-commit encontró algunos problemas. Revisa la salida anterior."
        print_status "Puedes ejecutar 'pre-commit run --all-files' nuevamente después de revisar los problemas."
    fi
fi

print_success "🎉 Configuración de pre-commit completada!"
echo
print_status "Próximos pasos:"
echo "  1. Revisa los archivos modificados por pre-commit"
echo "  2. Haz commit de los cambios: git add . && git commit -m 'feat: configurar pre-commit hooks'"
echo "  3. Los hooks se ejecutarán automáticamente en futuros commits"
echo
print_status "Comandos útiles:"
echo "  - pre-commit run --all-files    # Ejecutar todos los hooks"
echo "  - pre-commit run terraform_fmt  # Ejecutar hook específico"
echo "  - pre-commit autoupdate         # Actualizar hooks"
echo "  - SKIP=hook_name git commit     # Saltar hook específico"
