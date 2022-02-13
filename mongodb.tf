resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }
}

resource "helm_release" "mongodb_operator" {
  count = var.mongodb == true ? 1 : 0
  depends_on = [kubernetes_namespace.mongodb]

  name       = "community-operator"
  repository = "https://mongodb.github.io/helm-charts"
  chart      = "community-operator"
  namespace  = "mongodb"

  set {
    name = "resource.tls.useCertManager"
    value = false
  }
}

resource "time_sleep" "wait_after_operator" {
  count = var.mongodb == true ? 1 : 0
  depends_on = [helm_release.mongodb_operator]
  create_duration = "10s"
}

resource "helm_release" "mongodb" {
  count = var.mongodb == true ? 1 : 0
  depends_on = [time_sleep.wait_after_operator]

  name  = "mongodb"
  chart = "charts/mongodb"
  namespace  = "mongodb"
}