#!/bin/bash

# Script ejecutado después de crear el contenedor
# Configuraciones finales y verificaciones

set -e

echo "🚀 Finalizando configuración del devcontainer..."

# Verificar que todas las herramientas están disponibles
export PATH="$HOME/.local/bin:$PATH"
echo "📊 Verificando herramientas instaladas:"
echo "  - AWS CLI: $(aws --version 2>&1)"
echo "  - Terraform: $(terraform version | head -n1)"
echo "  - Terraform-docs: $(terraform-docs --version)"
echo "  - kubectl: $(kubectl version --client --short 2>/dev/null)"
echo "  - Pre-commit: $(pre-commit --version)"
echo "  - TFLint: $(tflint --version)"
echo "  - Trivy: $(trivy --version | head -n1)"
echo "  - Infracost: $(infracost --version)"

# Verificar Docker con configuración de permisos
echo -n "  - Docker: "
if docker --version >/dev/null 2>&1; then
    echo "$(docker --version)"
    echo -n "  - Docker Compose: "
    if docker compose version >/dev/null 2>&1; then
        echo "$(docker compose version)"
    else
        echo "❌ Docker Compose no disponible"
    fi

    # Verificar conectividad a Docker daemon
    echo -n "  - Docker daemon: "
    if docker info >/dev/null 2>&1; then
        echo "✅ Conectado"
    else
        echo "⚠️  No conectado - configurando permisos..."
        if [ -S /var/run/docker.sock ]; then
            sudo chown root:docker /var/run/docker.sock 2>/dev/null || true
            sudo chmod 664 /var/run/docker.sock 2>/dev/null || true
            if docker info >/dev/null 2>&1; then
                echo "     ✅ Permisos configurados correctamente"
            else
                echo "     ❌ No se pudo conectar al daemon de Docker"
            fi
        else
            echo "     ❌ Socket de Docker no encontrado"
        fi
    fi
else
    echo "❌ Docker no disponible"
fi

# Mostrar información útil
echo ""
echo "🎯 Comandos útiles disponibles:"
echo "  - pcra          # Ejecutar todos los pre-commit hooks"
echo "  - tf            # Terraform"
echo "  - tfdocs        # Terraform-docs"
echo "  - k             # kubectl"
echo "  - kctx staging  # Cambiar a contexto staging de kubectl"
echo ""
echo "🐳 Docker disponible:"
echo "  - docker        # Cliente Docker CLI"
echo "  - docker compose # Docker Compose plugin"
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
