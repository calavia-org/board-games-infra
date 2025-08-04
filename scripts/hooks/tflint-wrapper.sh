#!/bin/bash

# Wrapper script para ejecutar tflint con configuración desde .tflint.hcl
# Este script se ejecuta desde el directorio raíz del proyecto

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Ejecutando TFLint con configuración completa desde .tflint.hcl..."
echo "Proyecto: $PROJECT_ROOT"
echo "Archivo config: $PROJECT_ROOT/.tflint.hcl"

# Ejecutar tflint desde el directorio raíz con el archivo de configuración
cd "$PROJECT_ROOT" || exit 1

# Verificar si el archivo de configuración existe
if [[ ! -f ".tflint.hcl" ]]; then
    echo "Error: Archivo .tflint.hcl no encontrado en $PROJECT_ROOT"
    exit 1
fi

# Copiar la configuración al directorio de trabajo y ejecutar tflint
cp .tflint.hcl calavia-eks-infra/.tflint.hcl
cd calavia-eks-infra || exit 1

# Inicializar plugins de TFLint (asegurar que plugin AWS esté disponible)
echo "Inicializando plugins de TFLint (AWS plugin v0.29.0)..."
if ! tflint --init --config=.tflint.hcl; then
    echo "❌ Error: No se pudo inicializar TFLint plugins"
    echo "🔍 Verificando conectividad a GitHub para descargar plugin AWS..."
    rm -f .tflint.hcl
    exit 1
fi

# Verificar que el plugin AWS está disponible
echo "🔍 Verificando plugin AWS..."
if tflint --config=.tflint.hcl --version > /dev/null 2>&1; then
    echo "✅ TFLint configurado correctamente con plugin AWS"
else
    echo "⚠️  Warning: Problema con configuración TFLint"
    echo "🔄 Re-intentando inicialización..."
    rm -rf .tflint.d/  # Limpiar cache de plugins
    tflint --init --config=.tflint.hcl --force
fi

# Ejecutar TFLint
echo "Ejecutando TFLint con reglas AWS..."
tflint --config=.tflint.hcl
exit_code=$?

# Limpiar el archivo copiado
rm -f .tflint.hcl

exit $exit_code
