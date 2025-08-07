#!/bin/bash

# Script para ejecutar análisis de costes local con Infracost
# Uso: ./scripts/cost-analysis.sh [staging|production|both]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
TF_ROOT="calavia-eks-infra"

# Función para mostrar ayuda
show_help() {
    echo "Análisis de Costes de Infraestructura - Board Games"
    echo ""
    echo "Uso: $0 [ENVIRONMENT] [OPTIONS]"
    echo ""
    echo "ENVIRONMENTS:"
    echo "  staging     Analizar costes del entorno de staging"
    echo "  production  Analizar costes del entorno de producción"
    echo "  both        Analizar ambos entornos (por defecto)"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help     Mostrar esta ayuda"
    echo "  -c, --compare  Comparar con la rama main"
    echo "  -o, --output   Formato de salida (table|json|html) [default: table]"
    echo "  -s, --save     Guardar reporte en archivo"
    echo ""
    echo "Ejemplos:"
    echo "  $0 staging"
    echo "  $0 production --compare"
    echo "  $0 both --output html --save"
}

# Función para verificar dependencias
check_dependencies() {
    echo -e "${BLUE}Verificando dependencias...${NC}"

    if ! command -v infracost &> /dev/null; then
        echo -e "${RED}Error: Infracost no está instalado${NC}"
        echo "Instala Infracost desde: https://www.infracost.io/docs/#quick-start"
        exit 1
    fi

    if ! command -v terraform &> /dev/null; then
        echo -e "${RED}Error: Terraform no está instalado${NC}"
        exit 1
    fi

    if [ -z "$INFRACOST_API_KEY" ]; then
        echo -e "${YELLOW}Advertencia: INFRACOST_API_KEY no está configurada${NC}"
        echo "Configura tu API key: export INFRACOST_API_KEY=your-api-key"
        echo "Obtenla gratis en: https://dashboard.infracost.io"
    fi

    echo -e "${GREEN}✓ Dependencias verificadas${NC}"
}

# Función para analizar costes de un entorno
analyze_environment() {
    local env=$1
    local output_format=$2
    local compare_mode=$3
    local save_report=$4

    echo -e "${BLUE}Analizando costes para entorno: ${env}${NC}"

    local tf_path="${TF_ROOT}/environments/${env}"
    local usage_file=".infracost/usage-${env}.yml"
    local output_file=""

    if [ "$save_report" = true ]; then
        output_file="reports/infracost-${env}-$(date +%Y%m%d-%H%M%S)"
        mkdir -p reports
    fi

    # Verificar que existen los archivos necesarios
    if [ ! -d "$tf_path" ]; then
        echo -e "${RED}Error: No se encontró el directorio $tf_path${NC}"
        return 1
    fi

    if [ ! -f "$usage_file" ]; then
        echo -e "${YELLOW}Advertencia: No se encontró $usage_file, usando valores por defecto${NC}"
        usage_file=""
    fi

    # Construir comando de Infracost
    local cmd="infracost breakdown --path $tf_path"

    if [ -n "$usage_file" ]; then
        cmd="$cmd --usage-file $usage_file"
    fi

    if [ "$compare_mode" = true ]; then
        echo -e "${BLUE}Modo comparación activado - comparando con main...${NC}"
        cmd="infracost diff --path $tf_path"
        if [ -n "$usage_file" ]; then
            cmd="$cmd --usage-file $usage_file"
        fi
        cmd="$cmd --compare-to main"
    fi

    # Ejecutar análisis
    case $output_format in
        "json")
            if [ -n "$output_file" ]; then
                $cmd --format json --out-file "${output_file}.json"
                echo -e "${GREEN}✓ Reporte JSON guardado en: ${output_file}.json${NC}"
            else
                $cmd --format json
            fi
            ;;
        "html")
            if [ -n "$output_file" ]; then
                $cmd --format html --out-file "${output_file}.html"
                echo -e "${GREEN}✓ Reporte HTML guardado en: ${output_file}.html${NC}"
            else
                $cmd --format html > /tmp/infracost-${env}.html
                echo -e "${GREEN}✓ Reporte HTML generado en: /tmp/infracost-${env}.html${NC}"
            fi
            ;;
        *)
            if [ -n "$output_file" ]; then
                $cmd > "${output_file}.txt"
                echo -e "${GREEN}✓ Reporte guardado en: ${output_file}.txt${NC}"
            fi
            $cmd
            ;;
    esac

    echo ""
}

# Función para generar reporte combinado
generate_combined_report() {
    local output_format=$1
    local save_report=$2

    echo -e "${BLUE}Generando reporte combinado...${NC}"

    local staging_path="${TF_ROOT}/environments/staging"
    local production_path="${TF_ROOT}/environments/production"
    local staging_usage=".infracost/usage-staging.yml"
    local production_usage=".infracost/usage-production.yml"

    # Generar archivos temporales
    infracost breakdown --path $staging_path --usage-file $staging_usage --format json --out-file /tmp/staging.json
    infracost breakdown --path $production_path --usage-file $production_usage --format json --out-file /tmp/production.json

    # Combinar reportes
    local combined_cmd="infracost output --path /tmp/staging.json --path /tmp/production.json"

    if [ "$save_report" = true ]; then
        local output_file
        output_file="reports/infracost-combined-$(date +%Y%m%d-%H%M%S)"
        mkdir -p reports

        case $output_format in
            "json")
                $combined_cmd --format json --out-file "${output_file}.json"
                echo -e "${GREEN}✓ Reporte combinado JSON guardado en: ${output_file}.json${NC}"
                ;;
            "html")
                $combined_cmd --format html --out-file "${output_file}.html"
                echo -e "${GREEN}✓ Reporte combinado HTML guardado en: ${output_file}.html${NC}"
                ;;
            *)
                $combined_cmd > "${output_file}.txt"
                echo -e "${GREEN}✓ Reporte combinado guardado en: ${output_file}.txt${NC}"
                ;;
        esac
    fi

    # Mostrar resumen en consola
    echo -e "${YELLOW}=== RESUMEN DE COSTES COMBINADO ===${NC}"
    $combined_cmd

    # Limpiar archivos temporales
    rm -f /tmp/staging.json /tmp/production.json
}

# Función principal
main() {
    local environment="both"
    local output_format="table"
    local compare_mode=false
    local save_report=false

    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -c|--compare)
                compare_mode=true
                shift
                ;;
            -o|--output)
                output_format="$2"
                shift 2
                ;;
            -s|--save)
                save_report=true
                shift
                ;;
            staging|production|both)
                environment="$1"
                shift
                ;;
            *)
                echo -e "${RED}Argumento desconocido: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    # Validar formato de salida
    if [[ ! "$output_format" =~ ^(table|json|html)$ ]]; then
        echo -e "${RED}Error: Formato de salida no válido: $output_format${NC}"
        echo "Formatos válidos: table, json, html"
        exit 1
    fi

    echo -e "${GREEN}🏗️  Análisis de Costes - Board Games Infrastructure${NC}"
    echo -e "${BLUE}Entorno: $environment | Formato: $output_format | Comparar: $compare_mode | Guardar: $save_report${NC}"
    echo ""

    check_dependencies

    case $environment in
        "staging")
            analyze_environment "staging" "$output_format" "$compare_mode" "$save_report"
            ;;
        "production")
            analyze_environment "production" "$output_format" "$compare_mode" "$save_report"
            ;;
        "both")
            analyze_environment "staging" "$output_format" "$compare_mode" "$save_report"
            analyze_environment "production" "$output_format" "$compare_mode" "$save_report"
            echo ""
            generate_combined_report "$output_format" "$save_report"
            ;;
    esac

    echo -e "${GREEN}✅ Análisis completado${NC}"
}

# Ejecutar script principal
main "$@"
