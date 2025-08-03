#!/bin/bash

# Auto-Tagger Script
# Aplica tags automáticamente a recursos AWS existentes
# Autor: DevOps Team - Calavia Gaming Platform
# Versión: 1.0.0

set -euo pipefail

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración de tags por defecto
DEFAULT_PROJECT="board-games"
DEFAULT_COST_CENTER="CC-001-GAMING"
DEFAULT_BUSINESS_UNIT="Gaming-Platform"
DEFAULT_DEPARTMENT="Engineering"
DEFAULT_MANAGED_BY="terraform"

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
🏷️  AWS Auto-Tagger

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -e, --environment ENV       Environment (production|staging|development|testing)
    -o, --owner EMAIL          Owner email address
    -p, --project NAME         Project name (default: $DEFAULT_PROJECT)
    -c, --cost-center CODE     Cost center code (default: $DEFAULT_COST_CENTER)
    --business-unit UNIT       Business unit (default: $DEFAULT_BUSINESS_UNIT)
    --department DEPT          Department (default: $DEFAULT_DEPARTMENT)
    --component COMP           Component type (database, cache, etc.)
    --criticality LEVEL        Criticality (critical|high|medium|low)
    --dry-run                  Show what would be tagged without applying
    --resource-type TYPE       Filter by specific resource type
    --resource-arn ARN         Tag specific resource by ARN
    --force                    Skip confirmation prompts
    -r, --region REGION        AWS region (default: current region)
    -h, --help                 Show this help

EXAMPLES:
    # Tag all resources in staging environment
    $0 --environment staging --owner devops@calavia.org

    # Dry run for production resources
    $0 --environment production --owner devops@calavia.org --dry-run

    # Tag specific database with custom component
    $0 --resource-arn arn:aws:rds:us-east-1:123456789012:db:mydb \\
       --environment production --owner dba@calavia.org --component database

    # Tag all RDS instances
    $0 --resource-type "AWS::RDS::DBInstance" --environment production \\
       --owner dba@calavia.org --component database --criticality critical

SUPPORTED RESOURCE TYPES:
    • AWS::RDS::DBInstance
    • AWS::RDS::DBCluster  
    • AWS::EKS::Cluster
    • AWS::EKS::NodeGroup
    • AWS::ElastiCache::CacheCluster
    • AWS::ElastiCache::ReplicationGroup
    • AWS::EC2::Instance
    • AWS::EC2::VPC
    • AWS::ELB::LoadBalancer
    • AWS::ELBv2::LoadBalancer
    • ... y más
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

# Construir tags basándose en parámetros
build_tags() {
    local environment="$1"
    local owner="$2"
    local project="$3"
    local cost_center="$4"
    local business_unit="$5"
    local department="$6"
    local component="$7"
    local criticality="$8"
    
    local current_date=$(date +%Y-%m-%d)
    
    # Tags obligatorios
    local tags=()
    tags+=("Environment=$environment")
    tags+=("Project=$project")
    tags+=("Owner=$owner")
    tags+=("CostCenter=$cost_center")
    tags+=("ManagedBy=$DEFAULT_MANAGED_BY")
    
    # Tags de negocio
    tags+=("BusinessUnit=$business_unit")
    tags+=("Department=$department")
    
    # Tags técnicos
    tags+=("CreatedBy=auto-tagger")
    tags+=("CreatedDate=$current_date")
    tags+=("Architecture=x86_64")
    
    # Tags opcionales
    if [[ -n "$component" ]]; then
        tags+=("Component=$component")
    fi
    
    if [[ -n "$criticality" ]]; then
        tags+=("Criticality=$criticality")
    fi
    
    # Tags específicos por environment
    case "$environment" in
        "production")
            tags+=("Backup=required")
            tags+=("Monitoring=enhanced")
            tags+=("ReservedInstance=candidate")
            ;;
        "staging")
            tags+=("Backup=weekly")
            tags+=("Monitoring=standard")
            tags+=("ScheduleShutdown=enabled")
            ;;
        "development"|"testing")
            tags+=("Backup=optional")
            tags+=("Monitoring=basic")
            tags+=("ScheduleShutdown=enabled")
            ;;
    esac
    
    # Tags de costes
    tags+=("BillingProject=BG-2025-Q3")
    tags+=("BudgetAlerts=enabled")
    tags+=("CostOptimization=candidate")
    
    printf '%s\n' "${tags[@]}"
}

# Obtener recursos para taggear
get_resources() {
    local resource_type="$1"
    local resource_arn="$2"
    local region="$3"
    
    if [[ -n "$resource_arn" ]]; then
        # Recurso específico
        echo "[$resource_arn]"
        return
    fi
    
    local aws_cmd="aws resourcegroupstaggingapi get-resources --output json"
    
    if [[ -n "$resource_type" ]]; then
        aws_cmd="$aws_cmd --resource-type-filters $resource_type"
    fi
    
    if [[ -n "$region" ]]; then
        aws_cmd="$aws_cmd --region $region"
    fi
    
    $aws_cmd | jq -r '.ResourceTagMappingList[].ResourceARN'
}

# Aplicar tags a un recurso
apply_tags_to_resource() {
    local resource_arn="$1"
    local tags_array=("${@:2}")
    local dry_run="$3"
    
    log_info "Procesando: $(basename "$resource_arn")"
    
    # Determinar el servicio AWS desde el ARN
    local service=$(echo "$resource_arn" | cut -d':' -f3)
    local region=$(echo "$resource_arn" | cut -d':' -f4)
    
    # Construir comando de tagging según el servicio
    local tag_cmd=""
    local tag_format=""
    
    case "$service" in
        "rds")
            tag_cmd="aws rds add-tags-to-resource"
            tag_format="--resource-name $resource_arn --tags"
            ;;
        "eks")
            tag_cmd="aws eks tag-resource"
            tag_format="--resource-arn $resource_arn --tags"
            ;;
        "elasticache")
            # ElastiCache usa nombres de recurso, no ARNs completos
            local resource_name=$(echo "$resource_arn" | rev | cut -d':' -f1 | rev)
            tag_cmd="aws elasticache add-tags-to-resource"
            tag_format="--resource-name $resource_name --tags"
            ;;
        "ec2")
            # EC2 usa resource IDs
            local resource_id=$(echo "$resource_arn" | rev | cut -d'/' -f1 | rev)
            tag_cmd="aws ec2 create-tags"
            tag_format="--resources $resource_id --tags"
            ;;
        "elasticloadbalancing")
            tag_cmd="aws elbv2 add-tags"
            tag_format="--resource-arns $resource_arn --tags"
            ;;
        *)
            log_warning "Servicio no soportado para tagging automático: $service"
            return 1
            ;;
    esac
    
    # Preparar tags según el formato del servicio
    local formatted_tags=""
    case "$service" in
        "rds"|"eks")
            # Formato Key=Value
            for tag in "${tags_array[@]}"; do
                if [[ -n "$formatted_tags" ]]; then
                    formatted_tags="$formatted_tags $tag"
                else
                    formatted_tags="$tag"
                fi
            done
            ;;
        "elasticache")
            # Formato Key=Value,Key=Value
            formatted_tags=$(IFS=','; echo "${tags_array[*]}")
            ;;
        "ec2")
            # Formato Key=Value Key=Value
            formatted_tags="${tags_array[*]}"
            ;;
        "elasticloadbalancing")
            # Formato especial para ELB
            for tag in "${tags_array[@]}"; do
                local key=$(echo "$tag" | cut -d'=' -f1)
                local value=$(echo "$tag" | cut -d'=' -f2-)
                if [[ -n "$formatted_tags" ]]; then
                    formatted_tags="$formatted_tags Key=$key,Value=$value"
                else
                    formatted_tags="Key=$key,Value=$value"
                fi
            done
            ;;
    esac
    
    # Construir comando completo
    local full_cmd=""
    case "$service" in
        "elasticache")
            full_cmd="$tag_cmd $tag_format Key=$formatted_tags"
            ;;
        *)
            full_cmd="$tag_cmd $tag_format $formatted_tags"
            ;;
    esac
    
    if [[ -n "$region" ]]; then
        full_cmd="$full_cmd --region $region"
    fi
    
    # Mostrar comando (dry run) o ejecutar
    if [[ "$dry_run" == "true" ]]; then
        log_info "[DRY RUN] $full_cmd"
    else
        log_info "Aplicando tags..."
        if eval "$full_cmd" 2>/dev/null; then
            log_success "Tags aplicados correctamente"
        else
            log_error "Error aplicando tags a $resource_arn"
            return 1
        fi
    fi
}

# Función principal
main() {
    local environment=""
    local owner=""
    local project="$DEFAULT_PROJECT"
    local cost_center="$DEFAULT_COST_CENTER"
    local business_unit="$DEFAULT_BUSINESS_UNIT"
    local department="$DEFAULT_DEPARTMENT"
    local component=""
    local criticality=""
    local dry_run="false"
    local resource_type=""
    local resource_arn=""
    local force="false"
    local region=""
    
    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--environment)
                environment="$2"
                shift 2
                ;;
            -o|--owner)
                owner="$2"
                shift 2
                ;;
            -p|--project)
                project="$2"
                shift 2
                ;;
            -c|--cost-center)
                cost_center="$2"
                shift 2
                ;;
            --business-unit)
                business_unit="$2"
                shift 2
                ;;
            --department)
                department="$2"
                shift 2
                ;;
            --component)
                component="$2"
                shift 2
                ;;
            --criticality)
                criticality="$2"
                shift 2
                ;;
            --dry-run)
                dry_run="true"
                shift
                ;;
            --resource-type)
                resource_type="$2"
                shift 2
                ;;
            --resource-arn)
                resource_arn="$2"
                shift
                ;;
            --force)
                force="true"
                shift
                ;;
            -r|--region)
                region="$2"
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
    
    # Validar parámetros obligatorios
    if [[ -z "$environment" ]]; then
        log_error "Environment es obligatorio (-e|--environment)"
        exit 1
    fi
    
    if [[ -z "$owner" ]]; then
        log_error "Owner email es obligatorio (-o|--owner)"
        exit 1
    fi
    
    # Validar environment
    if [[ ! "$environment" =~ ^(production|staging|development|testing)$ ]]; then
        log_error "Environment debe ser: production, staging, development, o testing"
        exit 1
    fi
    
    # Verificar dependencias
    check_dependencies
    
    log_info "🏷️  AWS Auto-Tagger iniciado"
    echo "================================"
    echo "Environment: $environment"
    echo "Owner: $owner"
    echo "Project: $project"
    echo "Cost Center: $cost_center"
    [[ -n "$component" ]] && echo "Component: $component"
    [[ -n "$criticality" ]] && echo "Criticality: $criticality"
    [[ -n "$resource_type" ]] && echo "Resource Type Filter: $resource_type"
    [[ -n "$resource_arn" ]] && echo "Specific Resource: $resource_arn"
    echo "Dry Run: $dry_run"
    echo
    
    # Construir tags
    local tags_array
    readarray -t tags_array < <(build_tags "$environment" "$owner" "$project" "$cost_center" "$business_unit" "$department" "$component" "$criticality")
    
    log_info "Tags que se aplicarán:"
    printf '  • %s\n' "${tags_array[@]}"
    echo
    
    # Confirmación si no está en modo force
    if [[ "$force" != "true" && "$dry_run" != "true" ]]; then
        read -p "¿Continuar con el tagging? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Operación cancelada"
            exit 0
        fi
    fi
    
    # Obtener recursos a taggear
    log_info "Obteniendo recursos..."
    local resources
    readarray -t resources < <(get_resources "$resource_type" "$resource_arn" "$region")
    
    if [[ ${#resources[@]} -eq 0 ]]; then
        log_warning "No se encontraron recursos para taggear"
        exit 0
    fi
    
    log_info "Encontrados ${#resources[@]} recursos para taggear"
    echo
    
    # Aplicar tags a cada recurso
    local success_count=0
    local error_count=0
    
    for resource in "${resources[@]}"; do
        if [[ -z "$resource" || "$resource" == "null" ]]; then
            continue
        fi
        
        if apply_tags_to_resource "$resource" "${tags_array[@]}" "$dry_run"; then
            ((success_count++))
        else
            ((error_count++))
        fi
        echo
    done
    
    # Resumen final
    echo
    log_info "📊 RESUMEN"
    echo "=============="
    echo "Recursos procesados: ${#resources[@]}"
    echo "Exitosos: $success_count"
    echo "Errores: $error_count"
    
    if [[ "$dry_run" == "true" ]]; then
        log_info "🧪 Modo DRY RUN - No se aplicaron cambios reales"
    else
        if [[ $error_count -eq 0 ]]; then
            log_success "✅ Todos los recursos fueron taggeados exitosamente"
        else
            log_warning "⚠️  Algunos recursos tuvieron errores"
        fi
    fi
}

# Ejecutar función principal
main "$@"
