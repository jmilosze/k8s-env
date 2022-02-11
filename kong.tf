resource "kubernetes_namespace" "kong" {
  metadata {
    name = "kong"
  }
}

resource "helm_release" "kong" {
  depends_on = [kubernetes_namespace.kong]

  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  namespace  = "kong"

  set {
    name  = "installCRDs"
    value = "false"
  }
  set {
    name  = "proxy.type"
    value = "NodePort"
  }
  set {
    name  = "proxy.http.nodePort"
    value = 32080
  }
  set {
    name  = "proxy.tls.nodePort"
    value = 32443
  }
}