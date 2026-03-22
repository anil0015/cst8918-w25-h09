terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "aks-rg-h09"
  location = "Canada Central"
}

resource "azurerm_kubernetes_cluster" "app" {
  name                = "aks-h09-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-h09"

  kubernetes_version = "1.34.3"

default_node_pool {
  name       = "nodepool"
  node_count = 1
  vm_size    = "Standard_B2s"
}

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.app.kube_config_raw
  sensitive = true
}