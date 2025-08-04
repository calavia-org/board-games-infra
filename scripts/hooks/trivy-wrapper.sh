#!/bin/bash

# Wrapper script para ejecutar trivy con configuración de ignorar
# Este script se ejecuta desde el directorio raíz del proyecto

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "Ejecutando Trivy security scan en calavia-eks-infra..."
echo "Proyecto: $PROJECT_ROOT"
echo "Archivo ignore: $PROJECT_ROOT/.trivyignore"

# Ejecutar trivy desde el directorio raíz con el archivo de ignore
cd "$PROJECT_ROOT" || exit 1
exec trivy config --ignorefile=.trivyignore --severity=MEDIUM,HIGH,CRITICAL calavia-eks-infra/
