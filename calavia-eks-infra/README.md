# Calavia EKS Infrastructure

Este proyecto tiene como objetivo desplegar una infraestructura en AWS utilizando Terraform para un clúster de Kubernetes (EKS) que soporta partidas distribuidas multijugador en tiempo real. La infraestructura incluye componentes críticos como bases de datos, monitoreo, seguridad y gestión de certificados.

## Estructura del Proyecto

El proyecto está organizado en módulos y entornos:

- **Módulos**: Contienen la lógica de infraestructura para componentes específicos.
  - `eks`: Configuración del clúster EKS.
  - `vpc`: Configuración de la VPC necesaria.
  - `rds-postgres`: Configuración de la base de datos PostgreSQL.
  - `elasticache-redis`: Configuración de la base de datos Redis.
  - `security`: Políticas de seguridad para el clúster.
  - `monitoring`: Configuración de monitoreo y alertas.
  - `alb-ingress`: Configuración del Ingress Controller basado en AWS ALB.
  - `external-dns`: Gestión de registros en Route 53.
  - `cert-manager`: Gestión de certificados con Let's Encrypt.

- **Entornos**: Definiciones específicas para producción y staging.
  - `production`: Infraestructura para el entorno de producción.
  - `staging`: Infraestructura para el entorno de staging.

## Requisitos

- Tener una cuenta de AWS con permisos adecuados para crear recursos.
- Tener instalado Terraform y configurado para usar AWS.
- Acceso a Terraform Cloud para aplicar los planes de infraestructura.

## Uso

1. Clona el repositorio.
2. Navega a la carpeta del entorno deseado (`production` o `staging`).
3. Configura las variables necesarias en los archivos `variables.tf`.
4. Inicializa Terraform:
   ```
   terraform init
   ```
5. Aplica la configuración:
   ```
   terraform apply
   ```

## Monitoreo y Alertas

El clúster está configurado con kube-prometheus stack para monitoreo y alertas, con retención de datos de 3 días en producción y 1 día en staging.

## Seguridad

Se implementan políticas de seguridad estrictas y se utiliza Cert-Manager para la gestión de certificados, asegurando que todas las aplicaciones desplegadas tengan certificados válidos y auto-renovables.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request para discutir cambios o mejoras.

## Licencia

Este proyecto está bajo la licencia MIT.