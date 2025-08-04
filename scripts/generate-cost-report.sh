#!/bin/bash

# Script para generar reportes de costes periódicos y análisis de tendencias
# Se puede ejecutar como cron job para reportes automáticos

set -e

# Configuración
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$PROJECT_ROOT/reports"
TF_ROOT="$PROJECT_ROOT/calavia-eks-infra"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración por defecto
EMAIL_RECIPIENTS=${EMAIL_RECIPIENTS:-"devops@calavia.org,finance@calavia.org"}
SLACK_WEBHOOK=${SLACK_WEBHOOK_URL:-""}
REPORT_FREQUENCY=${REPORT_FREQUENCY:-"weekly"}

show_help() {
    echo "Generador de Reportes de Costes - Board Games Infrastructure"
    echo ""
    echo "Uso: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help              Mostrar esta ayuda"
    echo "  -f, --frequency TYPE    Frecuencia del reporte (daily|weekly|monthly)"
    echo "  -e, --email EMAILS      Lista de emails separados por coma"
    echo "  -o, --output FORMAT     Formato de salida (html|json|csv)"
    echo "  -s, --send              Enviar reporte por email/Slack"
    echo "  --trend-analysis        Incluir análisis de tendencias"
    echo "  --cost-optimization     Incluir recomendaciones de optimización"
    echo ""
    echo "Variables de entorno:"
    echo "  EMAIL_RECIPIENTS        Emails para envío de reportes"
    echo "  SLACK_WEBHOOK_URL       Webhook de Slack"
    echo "  REPORT_FREQUENCY        Frecuencia por defecto"
}

setup_directories() {
    mkdir -p "$REPORTS_DIR"/{daily,weekly,monthly,trends,optimization}
    mkdir -p "$REPORTS_DIR/assets"
}

get_aws_costs() {
    local start_date=$1
    local end_date=$2
    local granularity=$3
    local group_by=$4

    aws ce get-cost-and-usage \
        --time-period Start=$start_date,End=$end_date \
        --granularity $granularity \
        --metrics BlendedCost UnblendedCost \
        --group-by Type=$group_by,Key=$group_by \
        --query 'ResultsByTime[*].[TimePeriod.Start,Groups[*].[Keys[0],Metrics.BlendedCost.Amount]]' \
        --output json
}

generate_infracost_report() {
    local env=$1
    local output_file=$2

    echo -e "${BLUE}Generando reporte Infracost para $env...${NC}"

    infracost breakdown \
        --path "$TF_ROOT/environments/$env" \
        --usage-file "$PROJECT_ROOT/.infracost/usage-$env.yml" \
        --format json \
        --out-file "$output_file"
}

analyze_cost_trends() {
    local frequency=$1
    local output_dir=$2

    echo -e "${BLUE}Realizando análisis de tendencias ($frequency)...${NC}"

    # Calcular fechas según frecuencia
    local days_back
    case $frequency in
        "daily") days_back=7 ;;
        "weekly") days_back=28 ;;
        "monthly") days_back=90 ;;
        *) days_back=7 ;;
    esac

    local start_date=$(date -d "$days_back days ago" +%Y-%m-%d)
    local end_date=$(date +%Y-%m-%d)

    # Obtener datos de costes reales de AWS
    local cost_data=$(get_aws_costs $start_date $end_date "DAILY" "SERVICE")

    # Generar análisis de tendencias
    cat > "$output_dir/trend-analysis.json" << EOF
{
    "period": "$frequency",
    "start_date": "$start_date",
    "end_date": "$end_date",
    "aws_actual_costs": $cost_data,
    "analysis_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF

    echo -e "${GREEN}✓ Análisis de tendencias guardado en $output_dir/trend-analysis.json${NC}"
}

generate_optimization_recommendations() {
    local output_dir=$1

    echo -e "${BLUE}Generando recomendaciones de optimización...${NC}"

    # Obtener recomendaciones de AWS Cost Explorer
    local recommendations=$(aws ce get-rightsizing-recommendation \
        --service EC2-Instance \
        --query 'RightsizingRecommendations[*].[CurrentInstance.InstanceName,RightsizingType,TargetInstances[0].EstimatedMonthlySavings.Value]' \
        --output json 2>/dev/null || echo "[]")

    # Obtener recomendaciones de Trusted Advisor (si está disponible)
    local trusted_advisor=$(aws support describe-trusted-advisor-checks \
        --language en \
        --query 'checks[?category==`cost_optimizing`].[name,id]' \
        --output json 2>/dev/null || echo "[]")

    cat > "$output_dir/optimization-recommendations.json" << EOF
{
    "generated_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "rightsizing_recommendations": $recommendations,
    "trusted_advisor_checks": $trusted_advisor,
    "infracost_recommendations": {
        "staging": {
            "potential_savings": {
                "spot_instances": "Use more spot instances for development workloads",
                "storage_optimization": "Review EBS volume sizes and types",
                "monitoring_retention": "Reduce CloudWatch logs retention for non-critical logs"
            }
        },
        "production": {
            "potential_savings": {
                "reserved_instances": "Consider Reserved Instances for stable workloads",
                "auto_scaling": "Implement aggressive auto-scaling policies",
                "data_transfer": "Use VPC endpoints to reduce data transfer costs"
            }
        }
    }
}
EOF

    echo -e "${GREEN}✓ Recomendaciones de optimización guardadas en $output_dir/optimization-recommendations.json${NC}"
}

generate_html_report() {
    local frequency=$1
    local output_file=$2
    local include_trends=$3
    local include_optimization=$4

    echo -e "${BLUE}Generando reporte HTML...${NC}"

    local report_title="Board Games Infrastructure - Cost Report ($frequency)"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S UTC')

    cat > "$output_file" << EOF
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$report_title</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; border-bottom: 2px solid #007acc; padding-bottom: 20px; margin-bottom: 30px; }
        .header h1 { color: #007acc; margin: 0; }
        .header p { color: #666; margin: 5px 0; }
        .section { margin: 30px 0; }
        .section h2 { color: #333; border-left: 4px solid #007acc; padding-left: 15px; }
        .cost-summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .cost-card { background: #f8f9fa; padding: 20px; border-radius: 6px; border-left: 4px solid #28a745; }
        .cost-card.warning { border-left-color: #ffc107; }
        .cost-card.danger { border-left-color: #dc3545; }
        .cost-card h3 { margin: 0 0 10px 0; color: #333; }
        .cost-card .amount { font-size: 24px; font-weight: bold; color: #007acc; }
        .cost-card .detail { color: #666; font-size: 14px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; font-weight: bold; }
        .trend-up { color: #dc3545; }
        .trend-down { color: #28a745; }
        .recommendation { background: #e3f2fd; padding: 15px; border-radius: 6px; margin: 10px 0; border-left: 4px solid #2196f3; }
        .footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🏗️ $report_title</h1>
            <p>Generado el: $timestamp</p>
            <p>Análisis de costes de infraestructura Kubernetes</p>
        </div>

        <div class="section">
            <h2>📊 Resumen de Costes</h2>
            <div class="cost-summary" id="cost-summary">
                <!-- Se llenará dinámicamente -->
            </div>
        </div>

        <div class="section">
            <h2>🔍 Desglose por Servicio</h2>
            <table id="service-breakdown">
                <thead>
                    <tr>
                        <th>Servicio</th>
                        <th>Entorno</th>
                        <th>Coste Mensual</th>
                        <th>% del Total</th>
                        <th>Tendencia</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Se llenará dinámicamente -->
                </tbody>
            </table>
        </div>
EOF

    if [ "$include_trends" = true ]; then
        cat >> "$output_file" << EOF
        <div class="section">
            <h2>📈 Análisis de Tendencias</h2>
            <div id="trends-content">
                <p>Análisis de tendencias de costes durante el período seleccionado.</p>
                <!-- Aquí se insertarían gráficos de tendencias -->
            </div>
        </div>
EOF
    fi

    if [ "$include_optimization" = true ]; then
        cat >> "$output_file" << EOF
        <div class="section">
            <h2>💡 Recomendaciones de Optimización</h2>
            <div class="recommendation">
                <h3>🎯 Staging</h3>
                <ul>
                    <li>Usar más instancias Spot para cargas de desarrollo</li>
                    <li>Revisar tamaños de volúmenes EBS</li>
                    <li>Reducir retención de logs no críticos</li>
                </ul>
            </div>
            <div class="recommendation">
                <h3>🎯 Production</h3>
                <ul>
                    <li>Considerar Reserved Instances para cargas estables</li>
                    <li>Implementar políticas agresivas de auto-scaling</li>
                    <li>Usar VPC endpoints para reducir transferencia de datos</li>
                </ul>
            </div>
        </div>
EOF
    fi

    cat >> "$output_file" << EOF
        <div class="footer">
            <p>Reporte generado por Board Games Infrastructure Cost Analysis</p>
            <p>Para más información, contacta al equipo de DevOps</p>
        </div>
    </div>

    <script>
        // Aquí se añadiría JavaScript para llenar las tablas dinámicamente
        console.log('Board Games Infrastructure Cost Report loaded');
    </script>
</body>
</html>
EOF

    echo -e "${GREEN}✓ Reporte HTML generado: $output_file${NC}"
}

send_report() {
    local report_file=$1
    local frequency=$2

    if [ -n "$EMAIL_RECIPIENTS" ] && command -v mail &> /dev/null; then
        echo -e "${BLUE}Enviando reporte por email...${NC}"

        local subject="Board Games Infrastructure - Cost Report ($frequency)"
        echo "Reporte de costes adjunto." | mail -s "$subject" -A "$report_file" "$EMAIL_RECIPIENTS"

        echo -e "${GREEN}✓ Reporte enviado por email${NC}"
    fi

    if [ -n "$SLACK_WEBHOOK" ]; then
        echo -e "${BLUE}Enviando notificación a Slack...${NC}"

        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"📊 Nuevo reporte de costes disponible ($frequency): $(basename $report_file)\"}" \
            "$SLACK_WEBHOOK"

        echo -e "${GREEN}✓ Notificación enviada a Slack${NC}"
    fi
}

main() {
    local frequency="$REPORT_FREQUENCY"
    local output_format="html"
    local send_report_flag=false
    local include_trends=false
    local include_optimization=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--frequency)
                frequency="$2"
                shift 2
                ;;
            -e|--email)
                EMAIL_RECIPIENTS="$2"
                shift 2
                ;;
            -o|--output)
                output_format="$2"
                shift 2
                ;;
            -s|--send)
                send_report_flag=true
                shift
                ;;
            --trend-analysis)
                include_trends=true
                shift
                ;;
            --cost-optimization)
                include_optimization=true
                shift
                ;;
            *)
                echo -e "${RED}Argumento desconocido: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    echo -e "${GREEN}🏗️  Generador de Reportes de Costes - Board Games Infrastructure${NC}"
    echo -e "${BLUE}Frecuencia: $frequency | Formato: $output_format${NC}"
    echo ""

    setup_directories

    local timestamp=$(date +%Y%m%d-%H%M%S)
    local output_dir="$REPORTS_DIR/$frequency"
    local report_file="$output_dir/cost-report-$timestamp.$output_format"

    # Generar reportes de Infracost
    generate_infracost_report "staging" "$output_dir/infracost-staging-$timestamp.json"
    generate_infracost_report "production" "$output_dir/infracost-production-$timestamp.json"

    # Análisis adicionales
    if [ "$include_trends" = true ]; then
        analyze_cost_trends "$frequency" "$output_dir"
    fi

    if [ "$include_optimization" = true ]; then
        generate_optimization_recommendations "$output_dir"
    fi

    # Generar reporte principal
    case $output_format in
        "html")
            generate_html_report "$frequency" "$report_file" "$include_trends" "$include_optimization"
            ;;
        "json"|"csv")
            echo -e "${YELLOW}Formato $output_format aún no implementado completamente${NC}"
            ;;
    esac

    # Enviar reporte si se solicita
    if [ "$send_report_flag" = true ]; then
        send_report "$report_file" "$frequency"
    fi

    echo -e "${GREEN}✅ Reporte generado: $report_file${NC}"
}

main "$@"
