
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "=3.0.0"
    }
    random = {
    source  = "hashicorp/random"
    #version = "=3.0.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}


resource "azurerm_resource_group" "devopsbas7" {
  name     = "devopsbas7"
  location = var.location
}


# resource "azurerm_network_security_group" "devopssg" {
#   name                = "devops-security-group"
#   location            = azurerm_resource_group.devopsbas.location
#   resource_group_name = azurerm_resource_group.devopsbas.name
# }

resource "azurerm_virtual_network" "devopsavn" {
  name                = "devops-network"
  location            = azurerm_resource_group.devopsbas7.location
  resource_group_name = azurerm_resource_group.devopsbas7.name
  address_space       = ["10.0.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Production"
  }
}
resource "azurerm_subnet" "subnet1" {
  name                 = "devopsavn-subnet1"
  resource_group_name  = azurerm_resource_group.devopsbas7.name
  virtual_network_name = azurerm_virtual_network.devopsavn.name
  address_prefixes     = ["10.0.1.0/24"]
}

#   subnet {
#     name           = "subnet1"
#     address_prefix = "10.0.1.0/24"
#   }

#   subnet {
#     name           = "subnet2"
#     address_prefix = "10.0.2.0/24"
#     security_group = azurerm_network_security_group.devopssg.id
#   }



# resource "azurerm_network_interface" "devopsni" {
#   name                = "devopsni"
#   location            = azurerm_resource_group.devopsbas.location
#   resource_group_name = azurerm_resource_group.devopsbas.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.subnet1.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_linux_virtual_machine" "devopsvm" {
#   name                = "devopsvm"
#   location            = azurerm_resource_group.devopsbas.location
#   resource_group_name = azurerm_resource_group.devopsbas.name
#   size                = var.vm_type
#   admin_username      = var.admin_username
#   network_interface_ids = [
#     azurerm_network_interface.devopsni.id,
#   ]

#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts"
#     version   = "latest"
#   }
# }