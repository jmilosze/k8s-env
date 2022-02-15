resource "kubernetes_namespace" "probe" {
  metadata {
    name = "probe"
  }
}

resource "kubernetes_deployment" "probe" {
  depends_on = [kubernetes_namespace.probe]

  metadata {
    name   = "probe"
    namespace = "probe"
    labels = {
      app = "probe"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "probe"
      }
    }

    template {
      metadata {
        labels = {
          app = "probe"
        }
      }

      spec {
        container {
          image = "nicolaka/netshoot:latest"
          name  = "netshoot"
          command = ["sleep", "infinity"]
        }
      }
    }
  }
}