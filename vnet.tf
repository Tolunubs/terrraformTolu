terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a new vnets and subnets
resource "azurerm_virtual_network" "example" {
  name                = "Tolu_Terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = "Tolu-RG"
}

resource "azurerm_subnet" "example" {
  name                 = "Tolu_Terraform-subnet"
  resource_group_name  = "Tolu-RG"
  virtual_network_name = "Tolu_Terraform-vnet"
  address_prefixes     = ["10.0.1.0/24"]
 
}