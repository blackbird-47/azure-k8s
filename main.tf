provider "azurerm" {
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  version = "1.33.1"
}

terraform {
  backend "azurerm" {
    storage_account_name = "azurermstorage"
    container_name = "akstfstate"
    key = "aks.tfstate"
    access_key = "rC3y5vGZ/ftKSIxP4ulpscOETvMy1d3ToCT1gjligLBHmVxDPmqd9pK6Pnyfi6EYqC278NZtYgdxtRkzHVtEeg=="
  }
}