resource "kubernetes_deployment" "probe" {
  count = var.probe == true ? 1 : 0

  metadata {
    name   = "probe"
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