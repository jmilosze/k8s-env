variable "cilium" {
  type        = bool
  description = "Enable/disable cilium. equires cluster without cni."
}

variable "echo" {
  type        = bool
  description = "Enable/disable echo server. Requires kong."
}

variable "cert_manager" {
  type        = bool
  description = "Enable/disable cert-manager."
}

variable "kong" {
  type        = bool
  description = "Enable/disable kong."
}

variable "probe" {
  type        = bool
  description = "Enable/disable netshoot probe."
}

variable "mongodb" {
  type        = bool
  description = "Enable/disable mongodb."
}