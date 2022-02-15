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

module "kong" {
  count = var.kong == true ? 1 : 0
  source = "./kong_module"
}

module "echo" {
  count = var.echo == true && var.kong == true ? 1 : 0
  depends_on = [module.kong]
  source = "./echo_module"
}

module "cert_manager" {
  count = var.cert_manager == true ? 1 : 0
  source = "./cert_mgr_module"
}

module "probe" {
  count = var.probe == true ? 1 : 0
  source = "./probe_module"
}

module "mongodb" {
  count = var.mongodb == true && var.cert_manager == true ? 1 : 0
  depends_on = [module.cert_manager]
  source = "./mongodb_module"
}