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
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubernetes"></a> [Kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.external_dns_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for External DNS | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for External DNS | `string` | `"kube-system"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_dns_role_arn"></a> [external\_DNS\_role\_arn](#output\_external\_dns\_role\_arn) | ARN of the IAM role for External DNS |
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | Status of the Helm release |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | ID of the Route53 hosted zone |
| <a name="output_hosted_zone_name_servers"></a> [hosted\_zone\_name\_servers](#output\_hosted\_zone\_name\_servers) | Name servers for the hosted zone |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
<!-- BEGINNING OF PRE-COMMIT-Terraform DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [AWS](#provider\_aws) | 6.7.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 3.0.2 |
| <a name="provider_kubernetes"></a> [Kubernetes](#provider\_kubernetes) | 2.38.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.external_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.external_dns_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#input\_cluster\_oidc\_issuer\_url) | OIDC issuer URL for the EKS cluster | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name for External DNS | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace for External DNS | `string` | `"kube-system"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_external_dns_role_arn"></a> [external\_DNS\_role\_arn](#output\_external\_dns\_role\_arn) | ARN of the IAM role for External DNS |
| <a name="output_helm_release_status"></a> [helm\_release\_status](#output\_helm\_release\_status) | Status of the Helm release |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | ID of the Route53 hosted zone |
| <a name="output_hosted_zone_name_servers"></a> [hosted\_zone\_name\_servers](#output\_hosted\_zone\_name\_servers) | Name servers for the hosted zone |
<!-- END OF PRE-COMMIT-Terraform DOCS HOOK -->
