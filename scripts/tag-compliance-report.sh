#!/bin/bash

# Tag Compliance Report Script
# Genera reportes de compliance de tags para todos los recursos AWS
# Autor: DevOps Team - Calavia Gaming Platform
# Versión: 1.0.0

set -euo pipefail

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$PROJECT_ROOT/reports/tag-compliance"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tags obligatorios definidos en el módulo
MANDATORY_TAGS=(
    "Environment"
    "Project" 
    "Owner"
    "CostCenter"
    "ManagedBy"
)

# Tipos de recursos a auditar
RESOURCE_TYPES=(
    "AWS::RDS::DBInstance"
    "AWS::RDS::DBCluster"
    "AWS::EKS::Cluster"
    "AWS::EKS::NodeGroup"
    "AWS::ElastiCache::CacheCluster"
    "AWS::ElastiCache::ReplicationGroup"
    "AWS::EC2::Instance"
    "AWS::EC2::VPC"
    "AWS::EC2::Subnet"
    "AWS::EC2::InternetGateway"
    "AWS::EC2::NatGateway"
    "AWS::EC2::RouteTable"
    "AWS::EC2::SecurityGroup"
    "AWS::ELB::LoadBalancer"
    "AWS::ELBv2::LoadBalancer"
    "AWS::Lambda::Function"
    "AWS::S3::Bucket"
    "AWS::CloudWatch::LogGroup"
    "AWS::IAM::Role"
    "AWS::SecretsManager::Secret"
)

# Funciones auxiliares
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    cat << EOF
🏷️  Tag Compliance Report Generator

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -f, --format FORMAT     Formato de salida: table|json|html|csv (default: table)
    -o, --output FILE       Archivo de salida (default: stdout)
    -e, --email EMAIL       Enviar reporte por email
    -r, --region REGION     Región AWS (default: región actual)
    --save-details          Guardar detalles de recursos no conformes
    --fix-mode              Modo interactivo para corregir tags faltantes
    --environment ENV       Filtrar por environment específico
    --resource-type TYPE    Filtrar por tipo de recurso específico
    -h, --help              Mostrar esta ayuda

EXAMPLES:
    # Reporte básico en tabla
    $0

    # Reporte HTML guardado y enviado por email
    $0 --format html --output compliance-report.html --email devops@calavia.org

    # Reporte JSON para procesamiento automático
    $0 --format json --output compliance.json

    # Auditar solo bases de datos en producción
    $0 --environment production --resource-type "AWS::RDS::DBInstance"

    # Modo de corrección interactiva
    $0 --fix-mode

MANDATORY TAGS:
    $(printf "  • %s\n" "${MANDATORY_TAGS[@]}")

RESOURCE TYPES AUDITADOS:
    $(printf "  • %s\n" "${RESOURCE_TYPES[@]}" | head -10)
    ... y $(( ${#RESOURCE_TYPES[@]} - 10 )) más
EOF
}

# Verificar dependencias
check_dependencies() {
    local deps=("aws" "jq")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Dependencia requerida no encontrada: $dep"
            exit 1
        fi
    done
    
    # Verificar credenciales AWS
    if ! aws sts get-caller-identity &> /dev/null; then
        log_error "AWS CLI no configurado o credenciales inválidas"
        exit 1
    fi
}

# Obtener recursos con tags
get_resources_with_tags() {
    local resource_type="$1"
    local region="${2:-}"
    
    local aws_cmd="aws resourcegroupstaggingapi get-resources"
    
    if [[ -n "$resource_type" ]]; then
        aws_cmd="$aws_cmd --resource-type-filters $resource_type"
    fi
    
    if [[ -n "$region" ]]; then
        aws_cmd="$aws_cmd --region $region"
    fi
    
    $aws_cmd --output json 2>/dev/null || echo '{"ResourceTagMappingList": []}'
}

# Verificar compliance de un recurso
check_resource_compliance() {
    local resource_arn="$1"
    local resource_tags="$2"
    
    local missing_tags=()
    local compliant=true
    
    for tag in "${MANDATORY_TAGS[@]}"; do
        if ! echo "$resource_tags" | jq -e --arg tag "$tag" '.[] | select(.Key == $tag)' > /dev/null; then
            missing_tags+=("$tag")
            compliant=false
        fi
    done
    
    # Retornar resultado en JSON
    jq -n \
        --arg arn "$resource_arn" \
        --argjson compliant "$compliant" \
        --argjson missing "$(printf '%s\n' "${missing_tags[@]}" | jq -R . | jq -s .)" \
        --argjson existing "$resource_tags" \
        '{
            resourceArn: $arn,
            compliant: $compliant,
            missingTags: $missing,
            existingTags: $existing
        }'
}

# Generar reporte de compliance
generate_compliance_report() {
    local format="$1"
    local output_file="$2"
    local environment_filter="$3"
    local resource_type_filter="$4"
    
    log_info "Iniciando auditoría de tags..."
    
    # Crear directorio de reportes
    mkdir -p "$REPORTS_DIR"
    
    local temp_file=$(mktemp)
    local results_file="$REPORTS_DIR/compliance-results-$TIMESTAMP.json"
    
    # Array para almacenar resultados
    echo '[]' > "$temp_file"
    
    local total_resources=0
    local compliant_resources=0
    local non_compliant_resources=0
    
    # Tipos de recursos a procesar
    local types_to_check=("${RESOURCE_TYPES[@]}")
    if [[ -n "$resource_type_filter" ]]; then
        types_to_check=("$resource_type_filter")
    fi
    
    log_info "Auditando ${#types_to_check[@]} tipos de recursos..."
    
    for resource_type in "${types_to_check[@]}"; do
        log_info "Procesando: $resource_type"
        
        # Obtener recursos de este tipo
        local resources_json=$(get_resources_with_tags "$resource_type")
        
        # Procesar cada recurso
        while IFS= read -r resource_line; do
            if [[ -z "$resource_line" || "$resource_line" == "null" ]]; then
                continue
            fi
            
            local resource_arn=$(echo "$resource_line" | jq -r '.ResourceARN')
            local resource_tags=$(echo "$resource_line" | jq '.Tags')
            
            # Filtrar por environment si se especifica
            if [[ -n "$environment_filter" ]]; then
                local env_tag=$(echo "$resource_tags" | jq -r --arg env "$environment_filter" '.[] | select(.Key == "Environment") | .Value')
                if [[ "$env_tag" != "$environment_filter" ]]; then
                    continue
                fi
            fi
            
            # Verificar compliance
            local compliance_result=$(check_resource_compliance "$resource_arn" "$resource_tags")
            
            # Agregar tipo de recurso al resultado
            compliance_result=$(echo "$compliance_result" | jq --arg type "$resource_type" '. + {resourceType: $type}')
            
            # Agregar al archivo temporal
            jq --argjson new "$compliance_result" '. + [$new]' "$temp_file" > "${temp_file}.tmp" && mv "${temp_file}.tmp" "$temp_file"
            
            # Contar estadísticas
            ((total_resources++))
            if [[ $(echo "$compliance_result" | jq -r '.compliant') == "true" ]]; then
                ((compliant_resources++))
            else
                ((non_compliant_resources++))
            fi
            
        done < <(echo "$resources_json" | jq -c '.ResourceTagMappingList[]?')
    done
    
    # Calcular métricas
    local compliance_percentage=0
    if [[ $total_resources -gt 0 ]]; then
        compliance_percentage=$(( (compliant_resources * 100) / total_resources ))
    fi
    
    # Crear reporte final
    local report_data=$(jq -n \
        --argjson total "$total_resources" \
        --argjson compliant "$compliant_resources" \
        --argjson non_compliant "$non_compliant_resources" \
        --argjson percentage "$compliance_percentage" \
        --arg timestamp "$TIMESTAMP" \
        --arg environment "${environment_filter:-all}" \
        --arg resource_type "${resource_type_filter:-all}" \
        --argjson mandatory_tags "$(printf '%s\n' "${MANDATORY_TAGS[@]}" | jq -R . | jq -s .)" \
        --argjson resources "$(cat "$temp_file")" \
        '{
            metadata: {
                generatedAt: $timestamp,
                totalResources: $total,
                compliantResources: $compliant,
                nonCompliantResources: $non_compliant,
                compliancePercentage: $percentage,
                environmentFilter: $environment,
                resourceTypeFilter: $resource_type,
                mandatoryTags: $mandatory_tags
            },
            resources: $resources
        }')
    
    # Guardar resultados JSON
    echo "$report_data" > "$results_file"
    
    # Generar output según formato
    case "$format" in
        "json")
            generate_json_report "$report_data" "$output_file"
            ;;
        "html")
            generate_html_report "$report_data" "$output_file"
            ;;
        "csv")
            generate_csv_report "$report_data" "$output_file"
            ;;
        *)
            generate_table_report "$report_data" "$output_file"
            ;;
    esac
    
    # Limpiar archivo temporal
    rm -f "$temp_file"
    
    log_success "Reporte generado: $results_file"
    
    # Mostrar resumen
    echo
    log_info "📊 RESUMEN DE COMPLIANCE"
    echo "=========================="
    echo "Total de recursos auditados: $total_resources"
    echo "Recursos conformes: $compliant_resources"
    echo "Recursos no conformes: $non_compliant_resources"
    echo "Porcentaje de compliance: ${compliance_percentage}%"
    echo
    
    if [[ $compliance_percentage -lt 95 ]]; then
        log_warning "⚠️  Compliance por debajo del objetivo (95%)"
        log_info "Considera ejecutar con --fix-mode para corregir tags faltantes"
    else
        log_success "✅ Compliance objetivo alcanzado"
    fi
}

# Generar reporte en formato tabla
generate_table_report() {
    local report_data="$1"
    local output_file="$2"
    
    {
        echo "🏷️  TAG COMPLIANCE REPORT"
        echo "========================="
        echo
        echo "Generated: $(date)"
        echo "Total Resources: $(echo "$report_data" | jq -r '.metadata.totalResources')"
        echo "Compliant: $(echo "$report_data" | jq -r '.metadata.compliantResources')"
        echo "Non-Compliant: $(echo "$report_data" | jq -r '.metadata.nonCompliantResources')"
        echo "Compliance Rate: $(echo "$report_data" | jq -r '.metadata.compliancePercentage')%"
        echo
        echo "MANDATORY TAGS:"
        echo "$report_data" | jq -r '.metadata.mandatoryTags[] | "  • " + .'
        echo
        echo "NON-COMPLIANT RESOURCES:"
        echo "========================"
        
        echo "$report_data" | jq -r '
            .resources[] | 
            select(.compliant == false) | 
            "\(.resourceType)\n  ARN: \(.resourceArn)\n  Missing Tags: \(.missingTags | join(", "))\n"
        '
        
    } | if [[ -n "$output_file" ]]; then tee "$output_file"; else cat; fi
}

# Generar reporte HTML
generate_html_report() {
    local report_data="$1"
    local output_file="$2"
    
    local html_file="${output_file:-$REPORTS_DIR/compliance-report-$TIMESTAMP.html}"
    
    cat > "$html_file" << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tag Compliance Report - Board Games Infrastructure</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .metric { background: #f8f9fa; padding: 20px; border-radius: 6px; text-align: center; border-left: 4px solid #3498db; }
        .metric.success { border-left-color: #27ae60; }
        .metric.warning { border-left-color: #f39c12; }
        .metric.danger { border-left-color: #e74c3c; }
        .metric-value { font-size: 2em; font-weight: bold; margin: 10px 0; }
        .compliance-high { color: #27ae60; }
        .compliance-medium { color: #f39c12; }
        .compliance-low { color: #e74c3c; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; font-weight: 600; }
        .status-compliant { color: #27ae60; font-weight: bold; }
        .status-non-compliant { color: #e74c3c; font-weight: bold; }
        .tag-list { font-family: monospace; font-size: 0.9em; }
        .resource-type { font-weight: 500; color: #2c3e50; }
        .timestamp { color: #666; font-size: 0.9em; }
        .mandatory-tags { background: #e3f2fd; padding: 15px; border-radius: 6px; margin: 20px 0; }
        .mandatory-tags ul { margin: 10px 0; padding-left: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏷️ Tag Compliance Report</h1>
        <p class="timestamp">Generated: $(date) | Board Games Infrastructure</p>
        
        <div class="summary">
            <div class="metric">
                <div class="metric-value">$(echo "$report_data" | jq -r '.metadata.totalResources')</div>
                <div>Total Resources</div>
            </div>
            <div class="metric success">
                <div class="metric-value">$(echo "$report_data" | jq -r '.metadata.compliantResources')</div>
                <div>Compliant Resources</div>
            </div>
            <div class="metric danger">
                <div class="metric-value">$(echo "$report_data" | jq -r '.metadata.nonCompliantResources')</div>
                <div>Non-Compliant Resources</div>
            </div>
            <div class="metric $(if [[ $(echo "$report_data" | jq -r '.metadata.compliancePercentage') -ge 95 ]]; then echo "success"; elif [[ $(echo "$report_data" | jq -r '.metadata.compliancePercentage') -ge 80 ]]; then echo "warning"; else echo "danger"; fi)">
                <div class="metric-value compliance-$(if [[ $(echo "$report_data" | jq -r '.metadata.compliancePercentage') -ge 95 ]]; then echo "high"; elif [[ $(echo "$report_data" | jq -r '.metadata.compliancePercentage') -ge 80 ]]; then echo "medium"; else echo "low"; fi)">$(echo "$report_data" | jq -r '.metadata.compliancePercentage')%</div>
                <div>Compliance Rate</div>
            </div>
        </div>

        <div class="mandatory-tags">
            <h3>📋 Mandatory Tags</h3>
            <ul>
$(echo "$report_data" | jq -r '.metadata.mandatoryTags[] | "<li>" + . + "</li>"')
            </ul>
        </div>

        <h2>📊 Resource Details</h2>
        <table>
            <thead>
                <tr>
                    <th>Resource Type</th>
                    <th>Resource ARN</th>
                    <th>Status</th>
                    <th>Missing Tags</th>
                    <th>Existing Tags</th>
                </tr>
            </thead>
            <tbody>
$(echo "$report_data" | jq -r '
    .resources[] | 
    "<tr>" +
    "<td class=\"resource-type\">" + .resourceType + "</td>" +
    "<td style=\"font-family: monospace; font-size: 0.8em; word-break: break-all;\">" + .resourceArn + "</td>" +
    "<td class=\"status-" + (if .compliant then "compliant\">✅ Compliant" else "non-compliant\">❌ Non-Compliant") + "</td>" +
    "<td class=\"tag-list\">" + (.missingTags | join(", ")) + "</td>" +
    "<td class=\"tag-list\">" + ([.existingTags[]? | .Key] | join(", ")) + "</td>" +
    "</tr>"
')
            </tbody>
        </table>
        
        <div style="margin-top: 40px; padding: 20px; background: #f8f9fa; border-radius: 6px;">
            <h3>🔧 Recommendations</h3>
            <ul>
                <li><strong>High Priority:</strong> Fix non-compliant resources with missing mandatory tags</li>
                <li><strong>Automation:</strong> Consider using AWS Config rules to enforce tagging policies</li>
                <li><strong>Training:</strong> Ensure teams understand tagging requirements</li>
                <li><strong>Monitoring:</strong> Set up automated compliance checks in CI/CD pipelines</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF
    
    log_success "Reporte HTML generado: $html_file"
}

# Generar reporte JSON
generate_json_report() {
    local report_data="$1"
    local output_file="$2"
    
    local json_file="${output_file:-$REPORTS_DIR/compliance-report-$TIMESTAMP.json}"
    echo "$report_data" | jq '.' > "$json_file"
    log_success "Reporte JSON generado: $json_file"
}

# Generar reporte CSV
generate_csv_report() {
    local report_data="$1"
    local output_file="$2"
    
    local csv_file="${output_file:-$REPORTS_DIR/compliance-report-$TIMESTAMP.csv}"
    
    {
        echo "ResourceType,ResourceARN,Compliant,MissingTags,ExistingTags"
        echo "$report_data" | jq -r '
            .resources[] | 
            [
                .resourceType,
                .resourceArn,
                .compliant,
                (.missingTags | join(";")),
                ([.existingTags[]? | .Key] | join(";"))
            ] | @csv
        '
    } > "$csv_file"
    
    log_success "Reporte CSV generado: $csv_file"
}

# Enviar reporte por email
send_email_report() {
    local report_file="$1"
    local email="$2"
    local format="$3"
    
    if ! command -v mail &> /dev/null; then
        log_warning "Comando 'mail' no disponible. Instala mailutils para envío de emails."
        return 1
    fi
    
    local subject="Tag Compliance Report - $(date +%Y-%m-%d)"
    
    case "$format" in
        "html")
            mail -s "$subject" -a "Content-Type: text/html" "$email" < "$report_file"
            ;;
        *)
            mail -s "$subject" "$email" < "$report_file"
            ;;
    esac
    
    log_success "Reporte enviado por email a: $email"
}

# Modo de corrección interactiva
fix_mode() {
    log_info "🔧 Modo de corrección interactiva"
    log_warning "ADVERTENCIA: Esta función aplicará tags a recursos AWS reales"
    read -p "¿Continuar? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Operación cancelada"
        exit 0
    fi
    
    # TODO: Implementar lógica de corrección interactiva
    log_info "Función en desarrollo. Por ahora, usa el módulo de tags en Terraform."
}

# Función principal
main() {
    local format="table"
    local output_file=""
    local email=""
    local region=""
    local save_details=false
    local fix_mode_enabled=false
    local environment_filter=""
    local resource_type_filter=""
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--format)
                format="$2"
                shift 2
                ;;
            -o|--output)
                output_file="$2"
                shift 2
                ;;
            -e|--email)
                email="$2"
                shift 2
                ;;
            -r|--region)
                region="$2"
                shift 2
                ;;
            --save-details)
                save_details=true
                shift
                ;;
            --fix-mode)
                fix_mode_enabled=true
                shift
                ;;
            --environment)
                environment_filter="$2"
                shift 2
                ;;
            --resource-type)
                resource_type_filter="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                log_error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Verificar dependencias
    check_dependencies
    
    # Modo de corrección
    if [[ $fix_mode_enabled == true ]]; then
        fix_mode
        exit 0
    fi
    
    # Generar reporte
    generate_compliance_report "$format" "$output_file" "$environment_filter" "$resource_type_filter"
    
    # Enviar por email si se especifica
    if [[ -n "$email" && -n "$output_file" ]]; then
        send_email_report "$output_file" "$email" "$format"
    fi
}

# Ejecutar función principal
main "$@"
