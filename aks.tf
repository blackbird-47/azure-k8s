data "azurerm_resource_group" "swastik-rg" {
  name = "swastik-rg"
}

data "azurerm_subnet" "aks-subnet" {
  name = "swastik-aks-2"
  virtual_network_name = "swastik-aks-vnet"
  resource_group_name = data.azurerm_resource_group.swastik-rg.name
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

  dynamic agent_pool_profile {
    for_each = var.agent_pools
    content {
      vnet_subnet_id = data.azurerm_subnet.aks-subnet.id
      availability_zones = list("1","2","3")
      name = agent_pool_profile.value.name
      count = agent_pool_profile.value.count
      enable_auto_scaling = agent_pool_profile.value.enable_auto_scaling
      type = agent_pool_profile.value.type
      min_count = agent_pool_profile.value.min_count
      max_count = agent_pool_profile.value.max_count
      max_pods = agent_pool_profile.value.max_pods
      vm_size = agent_pool_profile.value.vm_size
      os_type = "Linux"
      os_disk_size_gb = "40"
      node_taints = agent_pool_profile.value.node_taints
    }
  }

  service_principal {
    client_id = var.client_id
    client_secret = var.client_secret
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
    sub_type = "dev"
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