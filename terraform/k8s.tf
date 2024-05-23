resource "azurerm_kubernetes_cluster" "kube-cluster-bas" {
  name                = "kube-cluster-bas"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = "baswanthkkubedns"
  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  

  default_node_pool {
    name       = "kubepool"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "baswanth"
  }
}

# resource "local_file" "azurek8s" {
#   filename = "./azurek8sconfig"
#   content = azurerm_kubernetes_cluster.kube-cluster-bas.kube_config_raw
# }

resource "local_file" "keyvaultsecret" {
  filename = "./keyvaultsecret"
  content = azurerm_key_vault_secret.kube_config_key_vault_secret.value
}