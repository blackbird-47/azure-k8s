variable "subscription_id" {
  description = "Azure subscription ID."
}

variable "tenant_id" {
  description = "Azure tenant ID."
}

variable "client_id" {
  description = "Service principle client ID."
}

variable "client_secret" {
  description = "Service principle client secret."
}

variable "agent_pools" {
  description = "AKS Agent pool configuration variables."
  default = [
    {
      name = "small"
      count = "3"
      vm_size = "Standard_DS2_v2"
      enable_auto_scaling = "1"
      type = "VirtualMachineScaleSets"
      min_count = "2"
      max_count = "3"
      max_pods = "10"
      node_taints = []
    },
    {
      name = "medium"
      count = "2"
      vm_size = "Standard_F4s_v2"
      enable_auto_scaling = "1"
      type = "VirtualMachineScaleSets"
      min_count = "1"
      max_count = "2"
      max_pods = "15"
      node_taints = ["cpu=medium:NoExecute","memory=medium:NoExecute"]
    },
    {
      name = "large"
      count = "2"
      vm_size = "Standard_F8s_v2"
      enable_auto_scaling = "1"
      type = "VirtualMachineScaleSets"
      min_count = "1"
      max_count = "2"
      max_pods = "15"
      node_taints = ["cpu=high:NoExecute","memory=high:NoExecute"]
    }]
}
