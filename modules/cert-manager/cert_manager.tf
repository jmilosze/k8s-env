resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [kubernetes_namespace.cert_manager]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io/"
  chart      = "cert-manager"
  version    = "v1.6.1"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_secret" "cert_manager_ca_key_pair" {
  depends_on = [kubernetes_namespace.cert_manager]

  metadata {
    name      = "ca-key-pair"
    namespace = "cert-manager"
  }

  data = {
    "tls.crt" = file("${path.root}/ca-cert.pem")
    "tls.key" = file("${path.root}/ca-key.pem")
  }
}

resource "time_sleep" "wait_after_cert_manager" {
  depends_on = [helm_release.cert_manager]
  create_duration = "10s"
}

resource "helm_release" "ca_issuer" {
  depends_on = [time_sleep.wait_after_cert_manager]

  name  = "cluster-issuer"
  chart = "${path.module}/cluster-issuer"
}