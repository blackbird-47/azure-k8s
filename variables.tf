variable "nodepool_types" {
  description = "Nodepool types for k8s cluster."
  type = "map"
  default = {
    stdds2v2 = "Standard_DS2_v2"
    stdf4sv2 = "Standard_F4s_v2"
    stdf8sv2 = "Standard_F8s_v2"
  }
}