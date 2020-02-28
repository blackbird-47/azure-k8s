data "azurerm_resource_group" "swastik-rg" {
  name = "swastik-rg"
}

data "azurerm_subnet" "aks-subnet" {
  name = "aks-subnet"
  virtual_network_name = "aks-vnet-15707174"
  resource_group_name = "MC_swastik-rg_swastik-aks-1_westeurope"
}

resource "azurerm_kubernetes_cluster" "aks-multi-nodepool" {
  name = "swastik-aks-2"
  location = data.azurerm_resource_group.swastik-rg.location
  resource_group_name = data.azurerm_resource_group.swastik-rg.name
  dns_prefix = "aks-multi-nodepool"
  kubernetes_version = "1.14.7"

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr = "10.2.0.0/24"
    load_balancer_sku = "Standard"
  }

  agent_pool_profile {
    name = "stdds2v2"
    count = "2"
    vm_size = "Standard_DS2_v2"
    os_type = "Linux"
    os_disk_size_gb = 50
    vnet_subnet_id = data.azurerm_subnet.aks-subnet.id
    availability_zones = "${list("1","2","3")}"
    enable_auto_scaling = "1"
    type = "VirtualMachineScaleSets"
    min_count = "2"
    max_count = "3"
    max_pods = "30"
  }

  agent_pool_profile {
    name = "stdf4sv2"
    count = "1"
    vm_size = "Standard_F4s_v2"
    os_type = "Linux"
    os_disk_size_gb = 50
    vnet_subnet_id = data.azurerm_subnet.aks-subnet.id
    availability_zones = "${list("1","2","3")}"
    enable_auto_scaling = "1"
    type = "VirtualMachineScaleSets"
    min_count = "1"
    max_count = "2"
    max_pods = "30"
  }

  agent_pool_profile {
    name = "stdf8sv2"
    count = "1"
    vm_size = "Standard_F8s_v2"
    os_type = "Linux"
    os_disk_size_gb = 50
    vnet_subnet_id = data.azurerm_subnet.aks-subnet.id
    availability_zones = "${list("1","2","3")}"
    enable_auto_scaling = "1"
    type = "VirtualMachineScaleSets"
    min_count = "1"
    max_count = "2"
    max_pods = "30"
    node_taints = "${list("cpu=highest_8c:NoExecute","memory=highest_16g:NoExecute")}"
  }

  service_principal {
    client_id = "f8bc4caf-4f94-4964-9a3d-6921fbabf7e9"
    client_secret = "xIsmSjqw.x5yCYJcMzXOA0.:HDv:Ua00"
  }

  addon_profile {
    oms_agent {
      enabled = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks-multi-nodepool.id
    }
  }

  tags = {
    environment = "dev",
    team_number = "123"
  }
}

resource "azurerm_log_analytics_workspace" "aks-multi-nodepool" {
  name = "swastik-aks-2-workspace"
  location = data.azurerm_resource_group.swastik-rg.location
  resource_group_name = data.azurerm_resource_group.swastik-rg.name
  sku = "PerGB2018"
  retention_in_days = "30"
}

resource "azurerm_log_analytics_solution" "aks-multi-nodepool" {
  solution_name = "ContainerInsights"
  location = data.azurerm_resource_group.swastik-rg.location
  resource_group_name = data.azurerm_resource_group.swastik-rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.aks-multi-nodepool.id
  workspace_name = azurerm_log_analytics_workspace.aks-multi-nodepool.name

  plan {
    publisher = "Microsoft"
    product = "OMSGallery/ContainerInsights"
  }
}