#!/bin/bash

# Script de diagnóstico para troubleshooting de Infracost
# Uso: ./scripts/debug-infracost.sh [staging|production]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ENVIRONMENT=${1:-staging}
TF_ROOT="calavia-eks-infra"

echo -e "${BLUE}🔍 Diagnóstico de Infracost - Entorno: $ENVIRONMENT${NC}"
echo "=============================================="

# 1. Verificar estructura de directorios
echo -e "\n${BLUE}1. Verificando estructura de directorios...${NC}"
if [ -d "${TF_ROOT}/environments/${ENVIRONMENT}" ]; then
    echo -e "${GREEN}✓ Directorio de entorno existe: ${TF_ROOT}/environments/${ENVIRONMENT}${NC}"
    echo "Archivos encontrados:"
    ls -la "${TF_ROOT}/environments/${ENVIRONMENT}/"
else
    echo -e "${RED}✗ Directorio de entorno NO existe: ${TF_ROOT}/environments/${ENVIRONMENT}${NC}"
    exit 1
fi

# 2. Verificar archivos de configuración de Infracost
echo -e "\n${BLUE}2. Verificando configuración de Infracost...${NC}"
if [ -f ".infracost/config.yml" ]; then
    echo -e "${GREEN}✓ config.yml existe${NC}"
else
    echo -e "${YELLOW}⚠ config.yml no encontrado${NC}"
fi

if [ -f ".infracost/usage-${ENVIRONMENT}.yml" ]; then
    echo -e "${GREEN}✓ usage-${ENVIRONMENT}.yml existe${NC}"
else
    echo -e "${RED}✗ usage-${ENVIRONMENT}.yml NO encontrado${NC}"
    exit 1
fi

# 3. Verificar archivos Terraform
echo -e "\n${BLUE}3. Verificando archivos Terraform...${NC}"
REQUIRED_FILES=("main.tf" "variables.tf" "providers.tf")
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "${TF_ROOT}/environments/${ENVIRONMENT}/${file}" ]; then
        echo -e "${GREEN}✓ ${file} existe${NC}"
    else
        echo -e "${RED}✗ ${file} NO encontrado${NC}"
    fi
done

# 4. Verificar módulos
echo -e "\n${BLUE}4. Verificando módulos...${NC}"
if [ -d "${TF_ROOT}/modules" ]; then
    echo -e "${GREEN}✓ Directorio de módulos existe${NC}"
    echo "Módulos disponibles:"
    ls -la "${TF_ROOT}/modules/"
else
    echo -e "${RED}✗ Directorio de módulos NO existe${NC}"
fi

# 5. Verificar instalación de herramientas
echo -e "\n${BLUE}5. Verificando herramientas...${NC}"
if command -v terraform &> /dev/null; then
    echo -e "${GREEN}✓ Terraform instalado: $(terraform version | head -1)${NC}"
else
    echo -e "${RED}✗ Terraform NO instalado${NC}"
fi

if command -v infracost &> /dev/null; then
    echo -e "${GREEN}✓ Infracost instalado: $(infracost --version)${NC}"
else
    echo -e "${RED}✗ Infracost NO instalado${NC}"
fi

# 6. Verificar variables de entorno
echo -e "\n${BLUE}6. Verificando variables de entorno...${NC}"
if [ -n "$INFRACOST_API_KEY" ]; then
    echo -e "${GREEN}✓ INFRACOST_API_KEY configurada${NC}"
else
    echo -e "${YELLOW}⚠ INFRACOST_API_KEY no configurada${NC}"
fi

# 7. Test de inicialización de Terraform
echo -e "\n${BLUE}7. Test de inicialización de Terraform...${NC}"
cd "${TF_ROOT}/environments/${ENVIRONMENT}"

echo "Ejecutando terraform init..."
if terraform init -backend=false > /tmp/tf-init.log 2>&1; then
    echo -e "${GREEN}✓ terraform init exitoso${NC}"
else
    echo -e "${RED}✗ terraform init falló${NC}"
    echo "Últimas líneas del log:"
    tail -5 /tmp/tf-init.log
fi

echo "Ejecutando terraform validate..."
if terraform validate > /tmp/tf-validate.log 2>&1; then
    echo -e "${GREEN}✓ terraform validate exitoso${NC}"
else
    echo -e "${RED}✗ terraform validate falló${NC}"
    echo "Errores encontrados:"
    cat /tmp/tf-validate.log
fi

cd - > /dev/null

# 8. Test de Infracost
echo -e "\n${BLUE}8. Test de Infracost...${NC}"

echo "Ejecutando infracost breakdown..."
if infracost breakdown \
    --path "${TF_ROOT}/environments/${ENVIRONMENT}" \
    --usage-file ".infracost/usage-${ENVIRONMENT}.yml" \
    --format json \
    --out-file "/tmp/infracost-test.json" > /tmp/infracost.log 2>&1; then
    echo -e "${GREEN}✓ infracost breakdown exitoso${NC}"
    
    # Mostrar resumen
    if [ -f "/tmp/infracost-test.json" ]; then
        echo "Coste mensual estimado:"
        jq -r '.totalMonthlyCost' /tmp/infracost-test.json 2>/dev/null || echo "No se pudo extraer el coste"
    fi
else
    echo -e "${RED}✗ infracost breakdown falló${NC}"
    echo "Errores encontrados:"
    cat /tmp/infracost.log
fi

# 9. Resumen
echo -e "\n${BLUE}9. Resumen de diagnóstico${NC}"
echo "=========================="

echo -e "\n${GREEN}Pasos para solucionar problemas comunes:${NC}"
echo "1. Si faltan archivos Terraform, ejecuta: terraform init en el directorio del entorno"
echo "2. Si Infracost falla, verifica que el API key esté configurado: export INFRACOST_API_KEY=your-key"
echo "3. Si hay errores de módulos, verifica que las rutas en main.tf sean correctas"
echo "4. Para GitHub Actions, asegúrate de que INFRACOST_API_KEY esté en los secretos del repo"

echo -e "\n${BLUE}Archivos de log creados:${NC}"
echo "- /tmp/tf-init.log"
echo "- /tmp/tf-validate.log" 
echo "- /tmp/infracost.log"
echo "- /tmp/infracost-test.json"

echo -e "\n${GREEN}✅ Diagnóstico completado para ${ENVIRONMENT}${NC}"
