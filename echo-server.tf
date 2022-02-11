resource "kubernetes_namespace" "echo_server" {
  metadata {
    name = "echo"
  }
}

resource "helm_release" "echo_server" {
  depends_on = [helm_release.kong, kubernetes_namespace.echo_server]

  name  = "echo-server"
  chart = "./charts/echo-server"
  namespace = "echo"
}