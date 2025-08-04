# 📂 Scripts Directory

Organización de scripts por funcionalidad para la infraestructura Board Games.

## 📁 Estructura

```
scripts/
├── README.md                    # Este archivo
├── verify-environment.sh        # Verificación de entorno (script principal)
├── hooks/                       # Scripts para pre-commit hooks
│   ├── terraform-validate-wrapper.sh    # Validación rápida con caché
│   ├── tflint-wrapper.sh               # Linting personalizado
│   └── trivy-wrapper.sh                # Escaneo de seguridad
├── aws/                         # Scripts específicos de AWS
│   ├── setup-aws-budgets.sh           # Configuración de presupuestos
│   ├── cost-analysis.sh               # Análisis de costes
│   └── generate-cost-report.sh         # Generación de reportes
├── demo/                        # Scripts de demostración y debugging
│   ├── demo-cost-system.sh            # Demo del sistema de costes
│   ├── demo-tagging-system.sh          # Demo del sistema de tags
│   └── debug-infracost.sh             # Debug de infracost
└── utils/                       # Utilidades y herramientas auxiliares
    ├── auto-tagger.sh                  # Aplicación automática de tags
    ├── tag-compliance-report.sh        # Reporte de compliance de tags
    ├── verify-infracost-solution.sh    # Verificación de infracost
    └── crontab.example                 # Ejemplo de configuración cron
```

## 🚀 Scripts Principales

### verify-environment.sh

**Uso**: `./scripts/verify-environment.sh`
**Propósito**: Verificar que el entorno esté configurado correctamente

- Verifica herramientas instaladas
- Comprueba permisos de scripts
- Testa hooks de pre-commit
- Genera reporte de configuración

## 🎣 Pre-commit Hooks (`hooks/`)

### Terraform-validate-wrapper.sh

**Optimización**: 30-60x más rápido que Terraform_validate original
**Características**:

- Cache inteligente basado en MD5 hash
- Solo re-valida si cambiaron archivos .tf
- Tiempo de ejecución: ~0.5s vs 10-30s

### tflint-wrapper.sh

**Propósito**: Linting con configuración personalizada
**Características**:

- Usa `.tflint-simple.hcl` del proyecto
- Evita reglas AWS problemáticas
- Configuración optimizada para desarrollo

### trivy-wrapper.sh

**Propósito**: Escaneo de seguridad respetando `.trivyignore`
**Características**:

- Ignora falsos positivos conocidos
- Ejecuta desde raíz del proyecto
- Configuración de severidad personalizable

## ☁️ Scripts AWS (`aws/`)

### setup-AWS-budgets.sh

**Propósito**: Configurar alertas y límites de presupuesto
**Uso**: `./scripts/aws/setup-aws-budgets.sh`

### cost-analysis.sh

**Propósito**: Análisis detallado de costes por servicio
**Uso**: `./scripts/aws/cost-analysis.sh [periodo]`

### generate-cost-report.sh

**Propósito**: Generar reportes de costes en formato CSV/JSON
**Uso**: `./scripts/aws/generate-cost-report.sh --format csv`

## 🔧 Demo Scripts (`demo/`)

### demo-cost-system.sh

**Propósito**: Demostración del sistema de monitoreo de costes
**Uso**: `./scripts/demo/demo-cost-system.sh`

### demo-tagging-system.sh

**Propósito**: Demostración del sistema de etiquetado automático
**Uso**: `./scripts/demo/demo-tagging-system.sh`

### debug-infracost.sh

**Propósito**: Debugging y troubleshooting de infracost
**Uso**: `./scripts/demo/debug-infracost.sh`

## 🛠️ Utilidades (`utils/`)

### auto-tagger.sh

**Propósito**: Aplicar tags automáticamente a recursos AWS
**Uso**: `./scripts/utils/auto-tagger.sh --environment staging`

### tag-compliance-report.sh

**Propósito**: Generar reporte de compliance de tags
**Uso**: `./scripts/utils/tag-compliance-report.sh`

### verify-infracost-solution.sh

**Propósito**: Verificar funcionamiento de infracost
**Uso**: `./scripts/utils/verify-infracost-solution.sh`

### crontab.example

**Propósito**: Ejemplo de configuración para tareas programadas
**Uso**: `crontab -e` y copiar configuraciones relevantes

## 🎯 Uso Típico

### Desarrollo Diario

```bash
# Verificar entorno
./scripts/verify-environment.sh

# Ejecutar hooks de pre-commit
pre-commit run --all-files
```

### Análisis de Costes

```bash
# Setup inicial de presupuestos
./scripts/aws/setup-aws-budgets.sh

# Análisis mensual
./scripts/aws/cost-analysis.sh --month $(date +%Y-%m)

# Reporte para CFO
./scripts/aws/generate-cost-report.sh --format csv --output monthly-report.csv
```

### Compliance y Tagging

```bash
# Aplicar tags automáticamente
./scripts/utils/auto-tagger.sh --environment production

# Verificar compliance
./scripts/utils/tag-compliance-report.sh
```

### Troubleshooting

```bash
# Debug de pre-commit hooks
./scripts/hooks/terraform-validate-wrapper.sh
./scripts/hooks/tflint-wrapper.sh
./scripts/hooks/trivy-wrapper.sh

# Debug de infracost
./scripts/demo/debug-infracost.sh
```

## ⚡ Performance

### Tiempos de Ejecución (Promedio)

| Script | Tiempo | Optimización |
|--------|--------|--------------|
| Terraform-validate-wrapper.sh | 0.5s | Cache MD5 |
| tflint-wrapper.sh | 2s | Config simple |
| trivy-wrapper.sh | 3s | .trivyignore |
| verify-environment.sh | 10s | Verificación completa |
| cost-analysis.sh | 30s | APIs AWS |

### Cache y Optimizaciones

- **Terraform cache**: `.terraform-validate-cache/`
- **TFLint cache**: `.tflint-cache/` (auto-generado)
- **Pre-commit cache**: `~/.cache/pre-commit`

## 🔧 Mantenimiento

### Actualización de Scripts

```bash
# Hacer ejecutables después de git pull
chmod +x scripts/**/*.sh

# Verificar integridad
./scripts/verify-environment.sh
```

### Limpieza de Cache

```bash
# Limpiar cache de terraform
rm -rf .terraform-validate-cache

# Limpiar cache de pre-commit
pre-commit clean
```

---

**Nota**: Todos los scripts están documentados internamente con comentarios detallados y logging colorizado para mejor experiencia de usuario.
