provider kubernetes {
  config_path    = "~/.kube/config"
  config_context = "kind-webserver"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-webserver"
  }
}