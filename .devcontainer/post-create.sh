#!/bin/bash

# Script ejecutado después de crear el contenedor
# Configuraciones finales y verificaciones

set -e

echo "🚀 Finalizando configuración del devcontainer..."

# Verificar que todas las herramientas están disponibles
echo "📊 Verificando herramientas instaladas:"
echo "  - AWS CLI: $(aws --version 2>&1)"
echo "  - Terraform: $(terraform version | head -n1)"
echo "  - kubectl: $(kubectl version --client --short 2>/dev/null)"
echo "  - Pre-commit: $(pre-commit --version)"
echo "  - TFLint: $(tflint --version)"
echo "  - Trivy: $(trivy --version | head -n1)"
echo "  - Infracost: $(infracost --version)"

# Mostrar información útil
echo ""
echo "🎯 Comandos útiles disponibles:"
echo "  - pcra          # Ejecutar todos los pre-commit hooks"
echo "  - tf            # Terraform"
echo "  - k             # kubectl"
echo "  - kctx staging  # Cambiar a contexto staging de kubectl"
echo ""

# Verificar conexión a AWS (si está configurado)
if aws sts get-caller-identity &>/dev/null; then
    echo "✅ AWS CLI configurado correctamente"
    echo "   Account: $(aws sts get-caller-identity --query Account --output text)"
    echo "   User: $(aws sts get-caller-identity --query Arn --output text)"
else
    echo "⚠️  AWS CLI no configurado. Ejecuta 'aws configure' para configurar credenciales"
fi

echo ""
echo "🎉 Devcontainer listo para usar!"
echo "💡 Tip: Ejecuta 'pcra' para validar que todo funciona correctamente"
