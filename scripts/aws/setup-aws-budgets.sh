#!/bin/bash

# Script para configurar AWS Budgets para control de costes
# Integra con Infracost para monitoreo proactivo de costes

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "")
EMAIL_ALERT=${EMAIL_ALERT:-"devops@calavia.org"}
# SLACK_WEBHOOK=${SLACK_WEBHOOK_URL:-""}  # Variable no utilizada

show_help() {
    echo "Configuración de AWS Budgets para Board Games Infrastructure"
    echo ""
    echo "Uso: $0 [OPTIONS]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help           Mostrar esta ayuda"
    echo "  -e, --email EMAIL    Email para alertas (default: devops@calavia.org)"
    echo "  -d, --delete         Eliminar budgets existentes"
    echo "  -l, --list           Listar budgets existentes"
    echo ""
    echo "Variables de entorno:"
    echo "  EMAIL_ALERT          Email para notificaciones"
    echo "  SLACK_WEBHOOK_URL    Webhook de Slack para notificaciones"
}

check_aws_cli() {
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}Error: AWS CLI no está instalado${NC}"
        exit 1
    fi

    if [ -z "$ACCOUNT_ID" ]; then
        echo -e "${RED}Error: No se pudo obtener el Account ID de AWS${NC}"
        echo "Verifica que AWS CLI esté configurado correctamente"
        exit 1
    fi

    echo -e "${GREEN}✓ AWS CLI configurado - Account ID: $ACCOUNT_ID${NC}"
}

list_budgets() {
    echo -e "${BLUE}Listando budgets existentes...${NC}"
    aws budgets describe-budgets --account-id $ACCOUNT_ID --query 'Budgets[?BudgetName | starts_with(@, `board-games`)].[BudgetName,BudgetLimit.Amount,BudgetLimit.Unit]' --output table
}

delete_budgets() {
    echo -e "${YELLOW}Eliminando budgets existentes...${NC}"

    local budgets
    budgets=$(aws budgets describe-budgets --account-id $ACCOUNT_ID --query 'Budgets[?BudgetName | starts_with(@, `board-games`)].BudgetName' --output text)

    if [ -z "$budgets" ]; then
        echo -e "${YELLOW}No se encontraron budgets para eliminar${NC}"
        return
    fi

    for budget in $budgets; do
        echo -e "${BLUE}Eliminando budget: $budget${NC}"
        aws budgets delete-budget --account-id $ACCOUNT_ID --budget-name $budget
    done

    echo -e "${GREEN}✓ Budgets eliminados${NC}"
}

create_staging_budget() {
    echo -e "${BLUE}Creando budget para Staging...${NC}"

    cat > /tmp/staging-budget.json << EOF
{
    "BudgetName": "board-games-staging-monthly",
    "BudgetLimit": {
        "Amount": "500",
        "Unit": "USD"
    },
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST",
    "CostFilters": {
        "TagKey": [
            "Environment"
        ],
        "TagValue": [
            "staging"
        ]
    },
    "TimePeriod": {
        "Start": "$(date -d 'first day of this month' '+%Y-%m-01')",
        "End": "2030-12-31"
    },
    "CalculatedSpend": {
        "ActualSpend": {
            "Amount": "0",
            "Unit": "USD"
        }
    }
}
EOF

    aws budgets create-budget \
        --account-id $ACCOUNT_ID \
        --budget file:///tmp/staging-budget.json

    echo -e "${GREEN}✓ Budget de Staging creado${NC}"
}

create_production_budget() {
    echo -e "${BLUE}Creando budget para Production...${NC}"

    cat > /tmp/production-budget.json << EOF
{
    "BudgetName": "board-games-production-monthly",
    "BudgetLimit": {
        "Amount": "1500",
        "Unit": "USD"
    },
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST",
    "CostFilters": {
        "TagKey": [
            "Environment"
        ],
        "TagValue": [
            "production"
        ]
    },
    "TimePeriod": {
        "Start": "$(date -d 'first day of this month' '+%Y-%m-01')",
        "End": "2030-12-31"
    },
    "CalculatedSpend": {
        "ActualSpend": {
            "Amount": "0",
            "Unit": "USD"
        }
    }
}
EOF

    aws budgets create-budget \
        --account-id $ACCOUNT_ID \
        --budget file:///tmp/production-budget.json

    echo -e "${GREEN}✓ Budget de Production creado${NC}"
}

create_alerts() {
    echo -e "${BLUE}Configurando alertas de budget...${NC}"

    # Alerta para Staging - 80% del presupuesto
    cat > /tmp/staging-alert.json << EOF
{
    "Notification": {
        "NotificationType": "ACTUAL",
        "ComparisonOperator": "GREATER_THAN",
        "Threshold": 80,
        "ThresholdType": "PERCENTAGE",
        "NotificationState": "OK"
    },
    "Subscribers": [
        {
            "SubscriptionType": "EMAIL",
            "Address": "$EMAIL_ALERT"
        }
    ]
}
EOF

    aws budgets create-notification \
        --account-id $ACCOUNT_ID \
        --budget-name "board-games-staging-monthly" \
        --notification file:///tmp/staging-alert.json

    # Alerta para Production - 80% del presupuesto
    cat > /tmp/production-alert.json << EOF
{
    "Notification": {
        "NotificationType": "ACTUAL",
        "ComparisonOperator": "GREATER_THAN",
        "Threshold": 80,
        "ThresholdType": "PERCENTAGE",
        "NotificationState": "OK"
    },
    "Subscribers": [
        {
            "SubscriptionType": "EMAIL",
            "Address": "$EMAIL_ALERT"
        }
    ]
}
EOF

    aws budgets create-notification \
        --account-id $ACCOUNT_ID \
        --budget-name "board-games-production-monthly" \
        --notification file:///tmp/production-alert.json

    # Alerta adicional para Production - 100% del presupuesto
    cat > /tmp/production-alert-100.json << EOF
{
    "Notification": {
        "NotificationType": "ACTUAL",
        "ComparisonOperator": "GREATER_THAN",
        "Threshold": 100,
        "ThresholdType": "PERCENTAGE",
        "NotificationState": "OK"
    },
    "Subscribers": [
        {
            "SubscriptionType": "EMAIL",
            "Address": "$EMAIL_ALERT"
        }
    ]
}
EOF

    aws budgets create-notification \
        --account-id $ACCOUNT_ID \
        --budget-name "board-games-production-monthly" \
        --notification file:///tmp/production-alert-100.json

    echo -e "${GREEN}✓ Alertas configuradas${NC}"
}

create_cost_anomaly_detector() {
    echo -e "${BLUE}Configurando detector de anomalías de costes...${NC}"

    # Crear detector de anomalías para la aplicación completa
    local detector_arn
    detector_arn=$(aws ce create-anomaly-detector \
        --anomaly-detector '{"MonitorType":"DIMENSIONAL","DimensionKey":"SERVICE","MatchOptions":["EQUALS"],"Values":["AmazonEKS","AmazonRDS","AmazonElastiCache"]}' \
        --query AnomalyDetectorArn --output text)

    if [ -n "$detector_arn" ]; then
        echo -e "${GREEN}✓ Detector de anomalías creado: $detector_arn${NC}"

        # Crear suscripción para notificaciones
        aws ce create-anomaly-subscription \
            --anomaly-subscription AnomalySubscriptionName=board-games-anomaly-alerts,MonitorArnList=$detector_arn,Subscribers=Type=EMAIL,Address=$EMAIL_ALERT,Frequency=DAILY,ThresholdExpression=And

        echo -e "${GREEN}✓ Suscripción a anomalías configurada${NC}"
    else
        echo -e "${YELLOW}Advertencia: No se pudo crear el detector de anomalías${NC}"
    fi
}

cleanup_temp_files() {
    rm -f /tmp/staging-budget.json /tmp/production-budget.json
    rm -f /tmp/staging-alert.json /tmp/production-alert.json /tmp/production-alert-100.json
}

main() {
    local action="create"

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -e|--email)
                EMAIL_ALERT="$2"
                shift 2
                ;;
            -d|--delete)
                action="delete"
                shift
                ;;
            -l|--list)
                action="list"
                shift
                ;;
            *)
                echo -e "${RED}Argumento desconocido: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done

    echo -e "${GREEN}🏗️  Configuración de AWS Budgets - Board Games Infrastructure${NC}"
    echo -e "${BLUE}Account ID: $ACCOUNT_ID${NC}"
    echo -e "${BLUE}Email de alertas: $EMAIL_ALERT${NC}"
    echo ""

    check_aws_cli

    case $action in
        "list")
            list_budgets
            ;;
        "delete")
            delete_budgets
            ;;
        "create")
            echo -e "${BLUE}Creando budgets y alertas...${NC}"
            create_staging_budget
            create_production_budget
            create_alerts
            create_cost_anomaly_detector
            cleanup_temp_files

            echo ""
            echo -e "${GREEN}✅ Configuración completada${NC}"
            echo -e "${YELLOW}Resumen:${NC}"
            echo "  • Budget Staging: \$500/mes (alerta al 80%)"
            echo "  • Budget Production: \$1500/mes (alertas al 80% y 100%)"
            echo "  • Detector de anomalías configurado"
            echo "  • Notificaciones por email: $EMAIL_ALERT"
            echo ""
            list_budgets
            ;;
    esac
}

# Trap para limpiar archivos temporales
trap cleanup_temp_files EXIT

main "$@"
