provider kubernetes {
  config_path    = "~/.kube/config"
  config_context = "kind-kind"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-kind"
  }
}

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

resource "kubernetes_secret" "cert_manager_ca" {
  depends_on = [kubernetes_namespace.cert_manager]

  metadata {
    name      = "ca-key-pair"
    namespace = "cert-manager"
  }

  data = {
    "tls.crt" = file("${path.module}/ca-cert.pem")
    "tls.key" = file("${path.module}/ca-key.pem")
  }
}

resource "time_sleep" "wait_after_cert_manager" {
  depends_on = [helm_release.cert_manager]
  create_duration = "30s"
}

resource "helm_release" "ca_issuer" {
  depends_on = [time_sleep.wait_after_cert_manager]

  name  = "cluster-issuer"
  chart = "./charts/cluster-issuer"
}

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
    name  = "http.nodePort"
    value = 32080
  }
  set {
    name  = "tls.nodePort"
    value = 32443
  }
}