resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_record" "external_dns" {
  zone_id = aws_route53_zone.main.zone_id
  name     = var.fqdn
  type     = "CNAME"
  ttl      = 300
  records  = [var.target]
}

resource "kubernetes_manifest" "external_dns" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "external-dns"
      namespace = var.namespace
    }
  }
}

resource "kubernetes_manifest" "external_dns_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "external-dns"
      namespace = var.namespace
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "external-dns"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "external-dns"
          }
        }
        spec = {
          serviceAccountName = "external-dns"
          containers = [
            {
              name  = "external-dns"
              image = "kubernetes-sigs/external-dns:v0.10.2"
              args = [
                "--source=service",
                "--domain-filter=${var.domain_name}",
                "--provider=aws",
                "--policy=upsert-only",
                "--registry=txt",
                "--txt-owner-id=${var.txt_owner_id}",
                "--aws-zone-type=public",
                "--aws-profile=${var.aws_profile}",
                "--aws-region=${var.aws_region}"
              ]
              env = [
                {
                  name  = "AWS_ACCESS_KEY_ID"
                  value = var.aws_access_key_id
                },
                {
                  name  = "AWS_SECRET_ACCESS_KEY"
                  value = var.aws_secret_access_key
                }
              ]
            }
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "external_dns_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "external-dns"
      namespace = var.namespace
    }
    spec = {
      type = "ClusterIP"
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]
      selector = {
        app = "external-dns"
      }
    }
  }
}