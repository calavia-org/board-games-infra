# Fix para el Comando infracost output - Múltiples Archivos

## Problema Identificado
El comando `infracost output` estaba fallando con el error:
```
Error: could not load input file /tmp/staging/staging-infracost.json,/tmp/production/production-infracost.json
```

### ❌ **Problema Anterior:**
- El comando usaba comas para separar múltiples archivos: `--path="/tmp/staging/staging-infracost.json,/tmp/production/production-infracost.json"`
- Infracost interpretaba toda la cadena como un solo archivo en lugar de dos archivos separados
- Esto causaba que el comando fallara al no encontrar el archivo combinado

### ✅ **Solución Implementada:**
Cambiar a múltiples argumentos `--path` individuales:

```bash
infracost output --path /tmp/staging/staging-infracost.json \
                --path /tmp/production/production-infracost.json \
                --format=slack-message \
                --out-file=/tmp/slack-message.json
```

## Cambios Realizados

### 1. Comando Corregido
- **Antes:** `--path="/tmp/staging/staging-infracost.json,/tmp/production/production-infracost.json"`
- **Después:** `--path /tmp/staging/staging-infracost.json --path /tmp/production/production-infracost.json`

### 2. Sintaxis de Múltiples Argumentos
- Usar múltiples argumentos `--path` individuales
- Eliminar las comillas alrededor de las rutas
- Cada archivo se especifica con su propio `--path`

## Beneficios
- ✅ Comando compatible con la sintaxis esperada por Infracost
- ✅ Procesamiento correcto de múltiples archivos JSON
- ✅ Generación exitosa del reporte combinado
- ✅ Eliminación del error de "archivo no existe"

## Documentación de Referencia
Según la documentación de Infracost, para combinar múltiples archivos JSON se debe usar:
- Múltiples argumentos `--path` (recomendado)
- O separación por espacios sin comas

## Testing
Este cambio debería permitir que el job `infracost-summary` procese correctamente ambos archivos JSON y genere el reporte mensual combinado.
