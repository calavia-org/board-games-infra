resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://charts.helm.sh/stable"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    templatefile("${path.module}/values.yaml", {
      retention_days = var.retention_days
    })
  ]
}

resource "kubernetes_secret" "alertmanager" {
  metadata {
    name      = "alertmanager"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    alertmanager.yaml = base64encode(file("${path.module}/alertmanager.yaml"))
  }
}

resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    prometheus.yaml = file("${path.module}/prometheus.yaml")
  }
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      port        = 80
      target_port = 3000
    }
  }
}

output "grafana_url" {
  value = "http://${kubernetes_service.grafana.metadata[0].name}.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local"
}