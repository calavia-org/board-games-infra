#!/bin/bash

# Script ejecutado en el host antes de crear el contenedor
# Preparaciones necesarias en el sistema host

set -e

echo "🔧 Preparando host para devcontainer..."

# Verificar que Docker está ejecutándose
if ! docker info &> /dev/null; then
    echo "❌ Docker no está ejecutándose. Inicia Docker y vuelve a intentar."
    exit 1
fi

# Crear directorios necesarios en el host si no existen
mkdir -p ~/.aws ~/.kube ~/.terraform.d

echo "✅ Host preparado para devcontainer"
