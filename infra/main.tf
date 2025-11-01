terraform {
  required_version = ">= 1.12.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "81121d2b-1ba6-4d91-8ab5-659b49d10952"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr${var.unique_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier
  dns_prefix          = "${var.prefix}-dns"
  private_cluster_enabled = true

  default_node_pool {
    name                 = "system"
    node_count           = var.node_count
    vm_size              = var.node_vm_size
    os_sku               = "AzureLinux"
    min_count            = var.node_count_min
    max_count            = var.node_count_max
    auto_scaling_enabled = var.node_auto_scaling_enabled
    max_pods             = var.max_pods
    host_encryption_enabled = true
    node_public_ip_enabled = false
    #vnet_subnet_id = "" # Add your vnet integration here
  }

  identity {
    type = "SystemAssigned"
  }
}