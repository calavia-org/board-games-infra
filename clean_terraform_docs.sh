#!/bin/bash

# Script para limpiar duplicaciones de terraform-docs en archivos README.md

find /workspaces/board-games-infra/calavia-eks-infra/modules -name "README.md" | while read -r file; do
    echo "Procesando: $file"

    # Crear una copia de respaldo
    cp "$file" "$file.backup"

    # Extraer solo el contenido antes del primer terraform-docs
    awk '
    BEGIN { in_tf_docs = 0; found_first = 0 }
    /<!-- BEGIN_TF_DOCS -->|<!-- BEGINNING OF PRE-COMMIT/ {
        if (!found_first) {
            found_first = 1
            in_tf_docs = 1
            print
        } else {
            in_tf_docs = 1
        }
        next
    }
    /<!-- END_TF_DOCS -->|<!-- END OF PRE-COMMIT/ {
        if (found_first && in_tf_docs) {
            print
            in_tf_docs = 0
        }
        next
    }
    !in_tf_docs { print }
    ' "$file.backup" > "$file"

    echo "Limpiado: $file"
done

echo "Limpieza completada. Se han creado copias de respaldo con extensión .backup"
