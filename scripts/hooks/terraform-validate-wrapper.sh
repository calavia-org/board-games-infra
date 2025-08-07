#!/bin/bash

# Wrapper script optimizado para terraform validate
# Versión simplificada y rápida para pre-commit hooks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
CACHE_FILE="$PROJECT_ROOT/.terraform-validate-cache"
TERRAFORM_ROOT="$PROJECT_ROOT/calavia-eks-infra"

echo "🚀 Terraform validate (optimizado)"

# Verificar que existe el directorio de infraestructura
if [[ ! -d "$TERRAFORM_ROOT" ]]; then
    echo "❌ No se encontró calavia-eks-infra"
    exit 1
fi

# Crear checksum simple de archivos .tf
CURRENT_HASH=$(find "$TERRAFORM_ROOT" -name "*.tf" -type f -newer "$CACHE_FILE" 2>/dev/null | wc -l)

# Si no hay archivos más nuevos que el cache, usar cache
if [[ -f "$CACHE_FILE" ]] && [[ "$CURRENT_HASH" -eq 0 ]]; then
    echo "✅ Cache válido - sin cambios detectados"
    exit 0
fi

echo "🔄 Validando configuración..."

# Validar solo los módulos principales (más rápido)
cd "$TERRAFORM_ROOT" || exit 1

# Verificar si Terraform está inicializado
if [[ ! -d ".terraform" ]] || [[ ! -f ".terraform.lock.hcl" ]]; then
    echo "🔧 Terraform no inicializado, ejecutando terraform init..."
    if terraform init -backend=false -no-color >/dev/null 2>&1; then
        echo "✅ Terraform inicializado correctamente"
    else
        echo "❌ Error al inicializar Terraform"
        terraform init -backend=false -no-color
        exit 1
    fi
fi

if terraform validate -no-color >/dev/null 2>&1; then
    echo "✅ Validación exitosa"
    # Actualizar cache
    touch "$CACHE_FILE"
    exit 0
else
    echo "❌ Error en validación"
    terraform validate -no-color
    exit 1
fi
