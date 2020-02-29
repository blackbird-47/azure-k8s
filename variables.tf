variable "nodepool_types" {
  description = "Nodepool types for k8s cluster."
  type = "map"
  default = {
    stdds2v2 = "Standard_DS2_v2"
    stdf4sv2 = "Standard_F4s_v2"
    stdf8sv2 = "Standard_F8s_v2"
  }
}

variable "client_id" {
  description = "Service principle client ID."
  default = "f8bc4caf-4f94-4964-9a3d-6921fbabf7e9"
}

variable "client_secret" {
  description = "Service principle client secret."
}