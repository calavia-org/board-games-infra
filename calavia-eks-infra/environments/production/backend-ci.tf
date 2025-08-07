# Backend configuration for CI/CD
# Este archivo permite que terraform init funcione en GitHub Actions
# sin configurar un backend real de S3

terraform {
  # No backend configurado para CI/CD - usar local state
  # En producción, usar el backend S3 real
}
