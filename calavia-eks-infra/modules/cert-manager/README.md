# Cert-Manager Module for Terraform

Este módulo de Terraform configura Cert-Manager en un clúster de Kubernetes para gestionar certificados SSL/TLS utilizando Let's Encrypt. Cert-Manager automatiza la obtención y renovación de certificados, facilitando la implementación de aplicaciones seguras.

## Requisitos

- Un clúster de Kubernetes en funcionamiento (por ejemplo, EKS).
- Permisos adecuados para crear recursos en el clúster.

## Uso

Para utilizar este módulo, incluya el siguiente bloque en su archivo de configuración de Terraform:

```hcl
module "cert_manager" {
  source = "./modules/cert-manager"

  # Aquí puede agregar las variables necesarias para la configuración
}
```

## Variables

Este módulo puede requerir las siguientes variables (ajuste según sea necesario):

- `namespace`: El espacio de nombres donde se desplegará Cert-Manager.
- `email`: La dirección de correo electrónico para la notificación de renovación de certificados.

## Salidas

Este módulo puede proporcionar las siguientes salidas:

- `cert_manager_installation`: Información sobre la instalación de Cert-Manager.

## Documentación Adicional

Para más información sobre Cert-Manager, consulte la [documentación oficial](https://cert-manager.io/docs/).