 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

#Create virtual network azurerm_network_interface
resource "azurerm_network_interface" "nic" {
  name                = "Tolu-Terraform-NIC"
  location            = "eastus"
  resource_group_name = "Gbenusi-Terraform"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  
}

resource "azurerm_subnet" "subnet" {
  name                   = "Tolu-Terraform-Subnet"
  resource_group_name    = "Gbenusi-Terraform"
  virtual_network_name   = "Tolu-terraform-vnet"
  address_prefixes       = ["10.0.1.0/24"]
}
 #creating a Virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "Tolu-Terraform-VM"
  location              = "eastus"
  resource_group_name   = "Gbenusi-Terraform"
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}