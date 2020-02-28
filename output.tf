output "kube_config" {
  value = "${element(azurerm_kubernetes_cluster.aks-multi-nodepool.*.kube_config_raw,0)}"
}