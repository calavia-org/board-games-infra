#!/bin/bash

# Script de inicialización del contenedor
# Ejecutado al crear el devcontainer

set -e

echo "🔧 Configurando devcontainer..."

# Asegurar permisos correctos
sudo chown -R vscode:vscode /workspace
chmod +x /workspace/scripts/*.sh

# Configurar pre-commit
if [[ -f "/workspace/.pre-commit-config.yaml" ]]; then
    echo "📦 Instalando hooks de pre-commit..."
    cd /workspace
    pre-commit install
    pre-commit install --hook-type commit-msg

    # Cachear hooks para primera ejecución más rápida
    echo "⚡ Cacheando hooks..."
    pre-commit run --all-files || echo "⚠️  Algunos hooks fallaron pero están instalados"
fi

# Configurar TFLint plugins
echo "🔍 Inicializando TFLint plugins con configuración AWS..."
if [[ -f "/workspace/.tflint.hcl" ]]; then
    cd /workspace/calavia-eks-infra
    cp ../.tflint.hcl ./.tflint.hcl
    echo "📦 Descargando plugin AWS para TFLint..."
    if tflint --init --config=.tflint.hcl; then
        echo "✅ Plugin AWS de TFLint inicializado correctamente"
    else
        echo "⚠️  TFLint init falló, se ejecutará en primer uso"
    fi
    rm -f .tflint.hcl  # Limpiar archivo temporal
fi

# Crear configuración de Terraform
echo "🏗️ Configurando Terraform..."
mkdir -p ~/.terraform.d
cat > ~/.terraformrc << 'EOF'
plugin_cache_dir   = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true
EOF

mkdir -p ~/.terraform.d/plugin-cache

echo "✅ Devcontainer configurado correctamente"
