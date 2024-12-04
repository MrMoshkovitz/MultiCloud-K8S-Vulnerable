#* Azure Infrastructure Module
#* This module sets up the complete Azure infrastructure including
#* networking, security, container registry, and AKS cluster

#* Resource Group Configuration
# Central resource group for all Azure resources
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.azure_region
}

#* Networking Configuration
#? Core network infrastructure for the AKS cluster
# Virtual Network setup
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration for AKS
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]
}

#* Security Configuration
#? SECURITY NOTE: These rules are intentionally permissive for testing
#? DO NOT use these settings in production environments
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#* Network Security Association
# Links the NSG to the subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#* Container Registry Configuration
#? Registry for storing vulnerable application images
resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

#* AKS Cluster Configuration
#? Main Kubernetes cluster setup with network integration
#? SECURITY NOTE: Uses service principal authentication
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-aks"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2as_v4"
    vnet_subnet_id  = azurerm_subnet.subnet.id
  }

  service_principal {
    client_id     = var.azure_client_id
    client_secret = var.azure_client_secret
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
  }
}

#* Role Assignment Configuration (Commented)
# Uncomment to enable ACR Pull access for AKS
# resource "azurerm_role_assignment" "acr_pull" {
#   principal_id                   = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
#   role_definition_name           = "AcrPull"
#   scope                          = azurerm_container_registry.acr.id
#   skip_service_principal_aad_check = true
# }
