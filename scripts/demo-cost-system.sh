#!/bin/bash

# Demo script para mostrar las capacidades del sistema de control de costes
# Board Games Infrastructure - Cost Control Demo

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🎮 Board Games Infrastructure - Cost Control System Demo${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Función para mostrar título de sección
show_section() {
    echo -e "${PURPLE}$1${NC}"
    echo -e "${BLUE}$(printf '%.0s-' {1..50})${NC}"
}

# Función para simular ejecución (para demo)
simulate_command() {
    local cmd=$1
    local description=$2
    
    echo -e "${YELLOW}▶ $description${NC}"
    echo -e "${BLUE}  Comando: $cmd${NC}"
    echo -e "${GREEN}  ✓ Simulación exitosa${NC}"
    echo ""
}

# Función para mostrar tabla de costes simulada
show_cost_table() {
    echo -e "${CYAN}📊 Estimación de Costes Mensuales${NC}"
    echo ""
    printf "%-20s %-15s %-15s %-15s\n" "Recurso" "Staging" "Production" "Total"
    printf "%-20s %-15s %-15s %-15s\n" "$(printf '%.0s-' {1..20})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})"
    printf "%-20s %-15s %-15s %-15s\n" "EKS Cluster" "\$73.00" "\$146.00" "\$219.00"
    printf "%-20s %-15s %-15s %-15s\n" "EC2 Instances" "\$45.60" "\$182.40" "\$228.00"
    printf "%-20s %-15s %-15s %-15s\n" "RDS PostgreSQL" "\$85.32" "\$341.28" "\$426.60"
    printf "%-20s %-15s %-15s %-15s\n" "ElastiCache Redis" "\$52.56" "\$210.24" "\$262.80"
    printf "%-20s %-15s %-15s %-15s\n" "ALB" "\$16.20" "\$32.40" "\$48.60"
    printf "%-20s %-15s %-15s %-15s\n" "VPC Endpoints" "\$21.60" "\$43.20" "\$64.80"
    printf "%-20s %-15s %-15s %-15s\n" "Secrets Manager" "\$1.20" "\$4.80" "\$6.00"
    printf "%-20s %-15s %-15s %-15s\n" "CloudWatch" "\$12.50" "\$45.30" "\$57.80"
    printf "%-20s %-15s %-15s %-15s\n" "$(printf '%.0s-' {1..20})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})"
    printf "%-20s %-15s %-15s %-15s\n" "TOTAL MENSUAL" "\$307.98" "\$1,005.62" "\$1,313.60"
    echo ""
}

# Función para mostrar alertas de presupuesto
show_budget_alerts() {
    echo -e "${CYAN}🚨 Estado de Presupuestos${NC}"
    echo ""
    echo -e "${GREEN}✅ Staging: \$307.98 / \$500.00 (61.6% - Normal)${NC}"
    echo -e "${YELLOW}⚠️  Production: \$1,005.62 / \$1,500.00 (67.0% - Monitoreando)${NC}"
    echo ""
    echo -e "${BLUE}📈 Tendencia (últimos 7 días): +2.3% vs semana anterior${NC}"
    echo ""
}

# Función para mostrar recomendaciones
show_recommendations() {
    echo -e "${CYAN}💡 Recomendaciones de Optimización${NC}"
    echo ""
    echo -e "${GREEN}🎯 Staging (Ahorro potencial: ~\$75/mes)${NC}"
    echo "   • Usar más instancias Spot (ahorro: ~\$25/mes)"
    echo "   • Optimizar tamaños de volúmenes EBS (ahorro: ~\$15/mes)"
    echo "   • Reducir retención de logs CloudWatch (ahorro: ~\$10/mes)"
    echo "   • Programar shutdown nocturno para desarrollo (ahorro: ~\$25/mes)"
    echo ""
    echo -e "${GREEN}🎯 Production (Ahorro potencial: ~\$200/mes)${NC}"
    echo "   • Reserved Instances para RDS (ahorro: ~\$85/mes)"
    echo "   • Reserved Instances para EC2 (ahorro: ~\$55/mes)"
    echo "   • Implementar auto-scaling más agresivo (ahorro: ~\$35/mes)"
    echo "   • Usar VPC Endpoints para S3/DynamoDB (ahorro: ~\$25/mes)"
    echo ""
}

# Demo principal
main() {
    show_section "🔧 1. ANÁLISIS DE COSTES LOCAL"
    simulate_command "./scripts/cost-analysis.sh both" "Analizando costes de ambos entornos"
    show_cost_table
    
    show_section "📊 2. CONFIGURACIÓN DE PRESUPUESTOS AWS"
    simulate_command "./scripts/setup-aws-budgets.sh" "Configurando AWS Budgets y alertas"
    show_budget_alerts
    
    show_section "📈 3. GENERACIÓN DE REPORTES"
    simulate_command "./scripts/generate-cost-report.sh -f weekly -s --cost-optimization" "Generando reporte semanal con recomendaciones"
    show_recommendations
    
    show_section "🤖 4. AUTOMATIZACIÓN CON GITHUB ACTIONS"
    echo -e "${YELLOW}▶ GitHub Actions Workflow activado${NC}"
    echo -e "${BLUE}  • Pull Request: Análisis automático de costes${NC}"
    echo -e "${BLUE}  • Push a main: Reporte mensual automático${NC}"
    echo -e "${BLUE}  • Alertas de presupuesto: Verificación cada 6 horas${NC}"
    echo -e "${GREEN}  ✓ Workflow configurado y activo${NC}"
    echo ""
    
    show_section "🔄 5. MONITOREO CONTINUO"
    echo -e "${YELLOW}▶ Cron Jobs configurados${NC}"
    echo -e "${BLUE}  • Reporte diario: L-V 9:00 AM${NC}"
    echo -e "${BLUE}  • Reporte semanal: Lunes 8:00 AM${NC}"
    echo -e "${BLUE}  • Reporte mensual: 1er día del mes 7:00 AM${NC}"
    echo -e "${BLUE}  • Verificación de anomalías: Cada 6 horas${NC}"
    echo -e "${GREEN}  ✓ Monitoreo 24/7 activo${NC}"
    echo ""
    
    show_section "🎯 RESUMEN DEL SISTEMA"
    echo -e "${GREEN}✅ Sistema de Control de Costes Completamente Implementado${NC}"
    echo ""
    echo -e "${CYAN}Capacidades:${NC}"
    echo "  • Análisis automático con Infracost"
    echo "  • Presupuestos y alertas AWS"
    echo "  • Reportes automáticos (diario/semanal/mensual)"
    echo "  • Detección de anomalías"
    echo "  • Recomendaciones de optimización"
    echo "  • Integración con CI/CD"
    echo "  • Notificaciones por email y Slack"
    echo ""
    echo -e "${YELLOW}Presupuestos Configurados:${NC}"
    echo "  • Staging: \$500/mes (actual: \$308 - 61.6%)"
    echo "  • Production: \$1,500/mes (actual: \$1,006 - 67.0%)"
    echo ""
    echo -e "${PURPLE}Ahorro Potencial Identificado: ~\$275/mes (17% de reducción)${NC}"
    echo ""
    echo -e "${BLUE}================================================================${NC}"
    echo -e "${CYAN}🎮 Board Games Infrastructure - Ready for Production! 🚀${NC}"
}

# Verificar si está en modo interactivo
if [[ $1 == "--interactive" ]]; then
    echo -e "${YELLOW}Modo interactivo activado - presiona Enter para continuar entre secciones${NC}"
    echo ""
    read -p "Presiona Enter para comenzar la demo..."
fi

main

echo ""
echo -e "${GREEN}Para comenzar a usar el sistema:${NC}"
echo ""
echo -e "${BLUE}1. Configurar variables de entorno:${NC}"
echo "   export INFRACOST_API_KEY='your-api-key'"
echo "   export EMAIL_RECIPIENTS='your-email@company.com'"
echo ""
echo -e "${BLUE}2. Ejecutar análisis inicial:${NC}"
echo "   ./scripts/cost-analysis.sh both"
echo ""
echo -e "${BLUE}3. Configurar presupuestos:${NC}"
echo "   ./scripts/setup-aws-budgets.sh"
echo ""
echo -e "${BLUE}4. Configurar reportes automáticos:${NC}"
echo "   cp scripts/crontab.example /tmp/cost-cron && crontab /tmp/cost-cron"
echo ""
echo -e "${CYAN}¡El sistema está listo para mantener tus costes bajo control! 💰${NC}"
