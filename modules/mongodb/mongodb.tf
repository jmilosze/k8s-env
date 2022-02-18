resource "kubernetes_namespace" "mongodb" {
  metadata {
    name = "mongodb"
  }
}

resource "kubernetes_config_map" "cert_manager_ca" {
  depends_on = [kubernetes_namespace.mongodb]

  metadata {
    name      = "ca-cert"
    namespace = "mongodb"
  }

  data = {
    "ca.crt" = file("${path.root}/ca-cert.pem")
  }
}

resource "kubernetes_secret" "mongodb_admin_password" {
  depends_on = [kubernetes_namespace.mongodb]

  metadata {
    name      = "admin-password"
    namespace = "mongodb"
  }

  data = {
    password = "admin"
  }
}

resource "helm_release" "mongodb_operator" {
  depends_on = [kubernetes_namespace.mongodb]

  name       = "community-operator"
  repository = "https://mongodb.github.io/helm-charts"
  chart      = "community-operator"
  namespace  = "mongodb"

  set {
    name = "resource.tls.useCertManager"
    value = false
  }

  set {
    name = "operator.watchNamespace"
    value = "*"
  }
}

resource "time_sleep" "wait_after_operator" {
  depends_on = [helm_release.mongodb_operator]
  create_duration = "10s"
}

resource "helm_release" "mongodb" {
  depends_on = [time_sleep.wait_after_operator, kubernetes_config_map.cert_manager_ca]

  name  = "mongodb"
  chart = "${path.module}/mongodb"
  namespace  = "mongodb"
}