terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}

# IAM Role for Cert-Manager
resource "aws_iam_role" "cert_manager" {
  name = "${var.cluster_name}-cert-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.cluster_oidc_issuer_url, "https://", "")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:cert-manager:cert-manager"
            "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = var.tags
}

# IAM Policy for Cert-Manager
resource "aws_iam_policy" "cert_manager" {
  name        = "${var.cluster_name}-cert-manager-policy"
  description = "IAM policy for Cert-Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:GetChange"
        ]
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZonesByName"
        ]
        Resource = "*"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cert_manager" {
  policy_arn = aws_iam_policy.cert_manager.arn
  role       = aws_iam_role.cert_manager.name
}

# Helm Release for Cert-Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.13.3"

  create_namespace = true

  values = [
    <<-EOF
    installCRDs: true
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${aws_iam_role.cert_manager.arn}
    EOF
  ]

  depends_on = [aws_iam_role_policy_attachment.cert_manager]
}

# ClusterIssuer for Let's Encrypt staging
resource "kubernetes_manifest" "letsencrypt_staging" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-staging"
    }
    spec = {
      acme = {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        email  = var.lets_encrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-staging"
        }
        solvers = [
          {
            dns01 = {
              route53 = {
                region = var.region
              }
            }
            selector = {
              dnsZones = [var.domain_name]
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager]
}

# ClusterIssuer for Let's Encrypt production
resource "kubernetes_manifest" "letsencrypt_production" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-production"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = var.lets_encrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-production"
        }
        solvers = [
          {
            dns01 = {
              route53 = {
                region = var.region
              }
            }
            selector = {
              dnsZones = [var.domain_name]
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager]
}
