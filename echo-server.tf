resource "kubernetes_namespace" "echo_server" {
  metadata {
    name = "echo"
  }
}

resource "helm_release" "echo_server" {
  count = var.echo_server == true ? 1 : 0
  depends_on = [kubernetes_namespace.echo_server]

  name  = "echo-server"
  chart = "./charts/echo-server"
  namespace = "echo"
}