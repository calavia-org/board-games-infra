#!/bin/bash

# Script de inicialización del contenedor
# Ejecutado al crear el devcontainer

set -e

echo "🔧 Configurando devcontainer..."

# Asegurar permisos correctos
sudo chown -R vscode:vscode /workspace
chmod +x /workspace/scripts/*.sh

# Instalar pre-commit si no está disponible
echo "📦 Verificando instalación de pre-commit..."
export PATH="$HOME/.local/bin:$PATH"
if ! command -v pre-commit &> /dev/null; then
    echo "📥 Instalando pre-commit..."
    pip3 install --user pre-commit
    echo "✅ Pre-commit instalado correctamente"
else
    echo "✅ Pre-commit ya está instalado"
fi

# Configurar pre-commit
if [[ -f "/workspace/.pre-commit-config.yaml" ]]; then
    echo "� Configurando hooks de pre-commit..."
    cd /workspace
    export PATH="$HOME/.local/bin:$PATH"

    # Instalar hooks para commits regulares
    echo "📦 Instalando hook pre-commit..."
    pre-commit install

    # Instalar hooks para mensajes de commit
    echo "📝 Instalando hook para mensajes de commit..."
    pre-commit install --hook-type commit-msg

    # Verificar que los hooks estén instalados
    if [[ -f ".git/hooks/pre-commit" ]]; then
        echo "✅ Hook pre-commit instalado correctamente"
    else
        echo "⚠️  Warning: No se pudo verificar la instalación del hook pre-commit"
    fi

    if [[ -f ".git/hooks/commit-msg" ]]; then
        echo "✅ Hook commit-msg instalado correctamente"
    else
        echo "⚠️  Warning: No se pudo verificar la instalación del hook commit-msg"
    fi

    # Cachear hooks para primera ejecución más rápida
    echo "⚡ Cacheando hooks..."
    pre-commit run --all-files || echo "⚠️  Algunos hooks fallaron pero están instalados"

    echo "✅ Pre-commit hooks activados - se ejecutarán automáticamente en cada commit"
else
    echo "⚠️  No se encontró .pre-commit-config.yaml, saltando configuración de hooks"
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

# Instalar hadolint para linting de Dockerfiles
echo "📦 Instalando hadolint..."
if ! command -v hadolint &> /dev/null; then
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
            echo "⚠️  Arquitectura no soportada: $ARCH, usando x86_64 por defecto"
            HADOLINT_ARCH="x86_64"
            ;;
    esac

    echo "📥 Descargando hadolint para arquitectura: $HADOLINT_ARCH"
    curl -sL -o /tmp/hadolint "https://github.com/hadolint/hadolint/releases/latest/download/hadolint-Linux-${HADOLINT_ARCH}"
    chmod +x /tmp/hadolint
    sudo mv /tmp/hadolint /usr/local/bin/hadolint
    echo "✅ Hadolint instalado correctamente"
else
    echo "✅ Hadolint ya está instalado"
fi

echo "✅ Devcontainer configurado correctamente"

# Verificar que pre-commit esté funcionando
echo "🔍 Verificando configuración de pre-commit..."
export PATH="$HOME/.local/bin:$PATH"
cd /workspace

if command -v pre-commit &> /dev/null; then
    echo "✅ Pre-commit disponible: $(pre-commit --version)"

    # Verificar que los hooks estén instalados
    if [[ -f ".git/hooks/pre-commit" ]]; then
        echo "✅ Hook pre-commit activo - se ejecutará en cada commit"
    else
        echo "❌ Hook pre-commit no está instalado"
    fi

    if [[ -f ".git/hooks/commit-msg" ]]; then
        echo "✅ Hook commit-msg activo - validará mensajes de commit"
    else
        echo "❌ Hook commit-msg no está instalado"
    fi
else
    echo "❌ Pre-commit no está disponible en PATH"
fi
