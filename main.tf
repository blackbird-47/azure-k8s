provider "azurerm" {
  client_id = "f8bc4caf-4f94-4964-9a3d-6921fbabf7e9"
  client_secret = "xIsmSjqw.x5yCYJcMzXOA0.:HDv:Ua00"
  subscription_id = "0e900d60-4c25-4ca0-9571-626b22a1a6cf"
  tenant_id = "f55b1f7d-7a7f-49e4-9b90-55218aad89f8"
  version = "1.33.1"
}

terraform {
  backend "azurerm" {
    storage_account_name = "swastikstorage"
    container_name = "terraform"
    key = "swastik-aks-2.tfstate"
    access_key = "rC3y5vGZ/ftKSIxP4ulpscOETvMy1d3ToCT1gjligLBHmVxDPmqd9pK6Pnyfi6EYqC278NZtYgdxtRkzHVtEeg=="
  }
}