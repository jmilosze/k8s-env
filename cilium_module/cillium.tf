resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.11.1"
  namespace  = "kube-system"
  wait       = true

  set {
    name  = "kubeProxyReplacement"
    value = "partial"
  }
  set {
    name  = "hostServices.enabled"
    value = false
  }
  set {
    name  = "externalIPs.enabled"
    value = true
  }
  set {
    name  = "nodePort.enabled"
    value = true
  }
  set {
    name  = "hostPort.enabled"
    value = true
  }
  set {
    name  = "bpf.masquerade"
    value = false
  }
  set {
    name  = "image.pullPolicy"
    value = "IfNotPresent"
  }
  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }
}
