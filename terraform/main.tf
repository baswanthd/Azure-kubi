
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "=3.3.0"
    }
    random = {
      source = "hashicorp/random"
      #version = "=3.3.0"
    }
    azapi = {
      source = "azure/azapi"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    encrypt              = true
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "devopsbas7" {
  name     = "devopsbas7"
  location = var.resource_group_location
}

# module "vnet" {
#   source = "./modules/vnet/"

#   resource_group_name     = var.resource_group_name
#   resource_group_location = var.resource_group_location
  # pri_subnet_names        = var.pri_subnet_names
  # pub_subnet_names        = var.pub_subnet_names
  # network_interface_id    = var.network_interface_id
  # subnet_cidr_private     = var.subnet_cidr_private
  # subnet_cidr_public      = var.subnet_cidr_public
#}
