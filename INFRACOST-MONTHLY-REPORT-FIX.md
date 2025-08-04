# Fix para el Reporte Mensual de Infracost

## Problema Identificado
El job `infracost-summary` tenía un problema con los nombres de archivos en el comando `infracost output`:

### Problema Anterior
- Los archivos se descargaban como `/tmp/staging/staging-infracost.json` y `/tmp/production/production-infracost.json`
- Se copiaban a `/tmp/staging-costs.json` y `/tmp/production-costs.json`
- El comando `infracost output` buscaba los archivos copiados, pero la copia podría fallar

### Solución Implementada
- Usar directamente los archivos descargados en sus ubicaciones originales
- Comando corregido: `--path="/tmp/staging/staging-infracost.json,/tmp/production/production-infracost.json"`
- Verificación obligatoria de existencia de archivos antes de procesarlos (exit 1 si faltan)

## Cambios Realizados

### 1. Eliminación de Paso de Copia
- Removido el paso de copia `cp /tmp/staging/staging-infracost.json /tmp/staging-costs.json`
- Uso directo de archivos en sus ubicaciones de descarga

### 2. Comando Corregido
```bash
infracost output --path="/tmp/staging/staging-infracost.json,/tmp/production/production-infracost.json" \
                --format=slack-message \
                --out-file=/tmp/slack-message.json
```

### 3. Validación Mejorada
- Verificación obligatoria de archivos antes del procesamiento
- Salida con error si algún archivo falta (exit 1)

## Beneficios
- ✅ Eliminación de pasos de copia innecesarios
- ✅ Uso directo de archivos descargados
- ✅ Validación estricta de existencia de archivos
- ✅ Mayor confiabilidad en el proceso de generación de reportes
- ✅ Reducción de posibles puntos de fallo

## Testing
Este cambio debe probarse ejecutando el workflow completo para verificar que:
1. Los archivos se descargan correctamente
2. El comando `infracost output` encuentra los archivos en las rutas especificadas
3. El reporte mensual se genera exitosamente
