resource "kubectl_manifest" "cert_manager" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "Issuer"
    metadata = {
      name      = "letsencrypt-prod"
      namespace = "cert-manager"
    }
    spec = {
      acme = {
        config = [
          {
            http01 = {
              ingressClassName = "alb"
            }
            domains = ["*.yourdomain.com"]
          }
        ]
        email = "your-email@example.com"
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        server = "https://acme-v02.api.letsencrypt.org/directory"
      }
    }
  }
}

resource "kubectl_manifest" "cert_manager_crd" {
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "certificates.cert-manager.io"
    }
    spec = {
      group = "cert-manager.io"
      names = {
        kind     = "Certificate"
        listKind = "CertificateList"
        plural   = "certificates"
        singular = "certificate"
      }
      scope = "Namespaced"
      versions = [
        {
          name    = "v1"
          served  = true
          storage = true
        }
      ]
    }
  }
}

resource "kubectl_manifest" "cert_manager_service_account" {
  manifest = {
    apiVersion = "v1"
    kind       = "ServiceAccount"
    metadata = {
      name      = "cert-manager"
      namespace = "cert-manager"
    }
  }
}

resource "kubectl_manifest" "cert_manager_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "cert-manager"
      namespace = "cert-manager"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "cert-manager"
        }
      }
      template = {
        metadata = {
          labels = {
            app = "cert-manager"
          }
        }
        spec = {
          serviceAccountName = "cert-manager"
          containers = [
            {
              name  = "cert-manager"
              image = "quay.io/jetstack/cert-manager-controller:v1.5.3"
              args  = ["--v=2"]
            }
          ]
        }
      }
    }
  }
}

resource "kubectl_manifest" "cert_manager_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "cert-manager"
      namespace = "cert-manager"
    }
    spec = {
      ports = [
        {
          port     = 443
          protocol = "TCP"
        }
      ]
      selector = {
        app = "cert-manager"
      }
      type = "ClusterIP"
    }
  }
}