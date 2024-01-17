
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}


resource "azurerm_resource_group" "devopsbas" {
  name     = "devops_bas"
  location = "West Europe"
}


resource "azurerm_network_security_group" "devopssg" {
  name                = "devops-security-group"
  location            = azurerm_resource_group.devopsbas.location
  resource_group_name = azurerm_resource_group.devopsbas.name
}

resource "azurerm_virtual_network" "devopsavn" {
  name                = "devops-network"
  location            = azurerm_resource_group.devopsbas.location
  resource_group_name = azurerm_resource_group.devopsbas.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.devopssg.id
  }

  tags = {
    environment = "Production"
  }
}
