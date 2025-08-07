#!/bin/bash

# Script ejecutado cada vez que se inicia el contenedor
# Configuraciones que deben ejecutarse en cada inicio

set -e

# Mostrar información del contexto actual
if command -v kubectl &> /dev/null && kubectl config current-context &> /dev/null; then
    echo "🎯 Contexto kubectl actual: $(kubectl config current-context)"
fi

# Verificar cache de pre-commit
if [[ -f "/workspace/.terraform-validate-cache" ]]; then
    echo "⚡ Cache de terraform-validate disponible"
fi

# Mensaje de bienvenida
echo "🎮 Board Games Infrastructure - Devcontainer activo"
