# Documentación del Módulo ElastiCache Redis

Este módulo de Terraform configura una instancia de ElastiCache para Redis en AWS. ElastiCache es un servicio de almacenamiento en caché en memoria que mejora el rendimiento de las aplicaciones al permitir un acceso rápido a los datos.

## Requisitos

- Tener configurado el proveedor de AWS en Terraform.
- Permisos adecuados para crear recursos de ElastiCache en la cuenta de AWS.

## Variables

Este módulo utiliza las siguientes variables:

- `redis_cluster_name`: Nombre del clúster de Redis.
- `redis_node_type`: Tipo de instancia para los nodos de Redis.
- `redis_engine_version`: Versión del motor de Redis.
- `redis_num_nodes`: Número de nodos en el clúster.
- `vpc_id`: ID de la VPC donde se desplegará ElastiCache.
- `subnet_ids`: Lista de IDs de subredes donde se desplegarán los nodos de Redis.

## Salidas

El módulo proporciona las siguientes salidas:

- `redis_endpoint`: Endpoint del clúster de Redis.
- `redis_primary_endpoint`: Endpoint del nodo primario de Redis.

## Uso

Para utilizar este módulo, puedes incluirlo en tu archivo de configuración de Terraform de la siguiente manera:

```hcl
module "elasticache_redis" {
  source              = "../modules/elasticache-redis"
  redis_cluster_name  = "mi-cluster-redis"
  redis_node_type     = "cache.t3.micro"
  redis_engine_version = "6.x"
  redis_num_nodes     = 1
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
}
```

## Consideraciones

- Asegúrate de que las subredes especificadas sean privadas y estén configuradas para permitir el acceso desde el clúster de EKS.
- Revisa las políticas de seguridad para garantizar que el acceso a Redis esté restringido a las aplicaciones que lo necesiten.

## Licencia

Este módulo se distribuye bajo la Licencia MIT.