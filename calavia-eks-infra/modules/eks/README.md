# Calavia EKS Module

Este módulo de Terraform se encarga de la creación y configuración de un clúster de Amazon EKS (Elastic Kubernetes Service) en AWS. A continuación se detallan los componentes y configuraciones que se pueden realizar con este módulo.

## Requisitos

- Tener una cuenta de AWS con permisos adecuados para crear recursos de EKS.
- Tener configurado el CLI de AWS y Terraform en tu máquina local.

## Variables

Este módulo utiliza varias variables que se deben definir en el archivo `variables.tf`. Algunas de las variables más importantes son:

- `cluster_name`: Nombre del clúster EKS.
- `node_instance_type`: Tipo de instancia para los nodos del clúster.
- `desired_capacity`: Número deseado de nodos en el clúster.
- `max_size`: Número máximo de nodos en el clúster.
- `min_size`: Número mínimo de nodos en el clúster.
- `vpc_id`: ID de la VPC donde se desplegará el clúster.

## Salidas

Al finalizar la ejecución de este módulo, se generarán las siguientes salidas:

- `cluster_endpoint`: El endpoint del clúster EKS.
- `cluster_name`: El nombre del clúster EKS.
- `cluster_arn`: El ARN del clúster EKS.
- `node_group_id`: El ID del grupo de nodos creado.

## Uso

Para utilizar este módulo, puedes incluirlo en tu archivo `main.tf` de la siguiente manera:

```hcl
module "eks" {
  source              = "./modules/eks"
  cluster_name       = "mi-cluster"
  node_instance_type = "t3.medium"
  desired_capacity    = 2
  max_size           = 3
  min_size           = 1
  vpc_id             = module.vpc.vpc_id
}
```

## Contribuciones

Las contribuciones son bienvenidas. Si deseas mejorar este módulo, por favor abre un issue o un pull request.

## Licencia

Este proyecto está bajo la Licencia MIT.