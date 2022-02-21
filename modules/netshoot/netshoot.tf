resource "kubernetes_namespace" "netshoot" {
  metadata {
    name = "netshoot"
  }
}

resource "kubernetes_deployment" "netshoot" {
  depends_on = [kubernetes_namespace.netshoot]

  metadata {
    name   = "netshoot"
    namespace = "netshoot"
    labels = {
      app = "netshoot"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "netshoot"
      }
    }

    template {
      metadata {
        labels = {
          app = "netshoot"
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