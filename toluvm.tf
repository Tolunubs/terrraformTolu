#configure azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

#prefix for Azure resources

variable "prefix" {
  default = "ToluTerraform"
}

#create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "uk south"
  resource_group_name = "Tolu-RG"
  tags = {
    environment = "Non-Prod"
  }
}

#create a subnet for the virtual network above
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "Tolu-RG"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

#create a network interface card for the virtual machine
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = "uk south"
  resource_group_name = "Tolu-RG"

#associate IP address
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Create a virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = "ToluTerraform-vm"
  location              = "uk south"
  resource_group_name   = "Tolu-RG"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
    
# Uncomment this line to delete the OS disk automatically when deleting the VM
    delete_os_disk_on_termination = true
# Uncomment this line to delete the data disks automatically when deleting the VM
    delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "Toluosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "Tolunubserver"
    admin_username = "tolunubs"
    admin_password = "P@ssw0rd1234!" # Change this to a secure password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
    tags = {
        environment = "Non-Prod"
    }
}
