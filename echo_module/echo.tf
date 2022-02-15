resource "kubernetes_namespace" "echo" {
  metadata {
    name = "echo"
  }
}

resource "helm_release" "echo" {
  depends_on = [kubernetes_namespace.echo]

  name  = "echo"
  chart = "${path.module}/echo"
  namespace = "echo"
}