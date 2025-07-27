# External DNS Module

Este módulo de Terraform configura External DNS para gestionar automáticamente los registros DNS en Amazon Route 53 basándose en los recursos de Kubernetes.

## Requisitos

- Un clúster de Kubernetes en funcionamiento.
- Permisos adecuados en AWS para gestionar Route 53.
- El controlador de Ingress debe estar configurado para trabajar con External DNS.

## Variables

Este módulo puede requerir las siguientes variables:

- `zone_id`: El ID de la zona de Route 53 donde se gestionarán los registros.
- `service_account`: La cuenta de servicio de Kubernetes que External DNS utilizará para autenticar las solicitudes a la API de Kubernetes.

## Uso

Para utilizar este módulo, puedes incluirlo en tu archivo `main.tf` de la siguiente manera:

```hcl
module "external_dns" {
  source     = "../modules/external-dns"
  zone_id    = "Z1234567890"  # Reemplaza con tu ID de zona
  service_account = "external-dns-sa"  # Reemplaza con tu cuenta de servicio
}
```

## Salidas

Este módulo puede proporcionar las siguientes salidas:

- `external_dns_service`: Detalles del servicio External DNS creado.
- `external_dns_deployment`: Detalles del despliegue de External DNS.

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este módulo, por favor abre un issue o un pull request.

## Licencia

Este proyecto está bajo la Licencia MIT.