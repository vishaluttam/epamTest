provider "azurerm" {
  features {}
}

# ================== Resource Group (RG) ===========================
# resource "azurerm_resource_group" "RG" {
#  name     = "${var.base_name}${var.custom_identifier}-rg"
#  location = var.azure_region
#}

# ================== Virtual Network (VNet) ======================== 

# Create virtual network
resource "azurerm_virtual_network" "VNET" {
  name                = "${var.base_name}${var.custom_identifier}-vnet"
  resource_group_name = "${var.base_name}${var.custom_identifier}-rg"
  location            = var.azure_region
  address_space       = [var.address_space]
}

# Create 1st subnet
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.subnet2}"
  resource_group_name  = "${var.base_name}${var.custom_identifier}-rg"
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 1)]
}

# Create 2nd subnet
resource "azurerm_subnet" "private_subnet" {
  name                 = "${var.subnet1}"
  resource_group_name  = "${var.base_name}${var.custom_identifier}-rg"
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, 10)]
}

# ================== Storage Account (SA) =============================


# Create storage account for VM boot diagnostics
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.base_name}${var.custom_identifier}sa"
  location                 = var.azure_region
  resource_group_name      = "${var.base_name}${var.custom_identifier}-rg"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled                  = true
  enable_https_traffic_only       = true
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = {
    Name = var.base_name
  }
}


