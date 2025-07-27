# Documentación del Módulo ALB Ingress

Este módulo configura un Ingress Controller basado en AWS Application Load Balancer (ALB) para gestionar el tráfico de las aplicaciones desplegadas en el clúster EKS. 

## Requisitos

- Un clúster EKS previamente configurado.
- Permisos adecuados para crear recursos en AWS.

## Variables

Este módulo requiere las siguientes variables:

- `cluster_name`: Nombre del clúster EKS.
- `namespace`: Espacio de nombres donde se desplegará el Ingress.
- `alb_ingress_controller_image`: Imagen del controlador de Ingress ALB.
- `service_account_iam_role`: Rol de IAM para el Service Account del controlador de Ingress.

## Uso

Para utilizar este módulo, puedes incluirlo en tu archivo `main.tf` de la siguiente manera:

```hcl
module "alb_ingress" {
  source = "../modules/alb-ingress"

  cluster_name               = var.cluster_name
  namespace                  = var.namespace
  alb_ingress_controller_image = var.alb_ingress_controller_image
  service_account_iam_role   = var.service_account_iam_role
}
```

## Salidas

Este módulo proporciona las siguientes salidas:

- `alb_dns_name`: Nombre DNS del ALB creado.
- `alb_arn`: ARN del ALB.

## Ejemplo

Aquí tienes un ejemplo de cómo se puede utilizar este módulo en un entorno de producción:

```hcl
module "alb_ingress" {
  source = "../modules/alb-ingress"

  cluster_name               = "mi-cluster"
  namespace                  = "default"
  alb_ingress_controller_image = "amazon/aws-alb-ingress-controller:v2.2.0"
  service_account_iam_role   = "arn:aws:iam::123456789012:role/alb-ingress-role"
}
```

## Contribuciones

Las contribuciones son bienvenidas. Por favor, abre un issue o un pull request si deseas mejorar este módulo.