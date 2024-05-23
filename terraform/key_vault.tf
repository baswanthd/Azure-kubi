data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                        = "mybaskeyvault"
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  #enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_subscription.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "premium"

  access_policy {
    tenant_id = data.azurerm_subscription.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Encrypt", "Decrypt", "Create"
    ]

    secret_permissions = [
      "Get", "List", "Delete", "Set", "Purge"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

# resource "azurerm_key_vault_secret" "key_vault_secret" {
#   name         = "mybaskeyvaultsecret"
#   value        = azurerm_container_registry_token_password.bastoken_pwd.password1[0].value # password value from container.tf
#   key_vault_id = azurerm_key_vault.key_vault.id
#   depends_on = [
#     azurerm_resource_group.devopsbas7,
#   ]
# }

resource "azurerm_key_vault_secret" "kube_config_key_vault_secret" {
  name         = "kubemybaskeyvaultsecret"
  value        = azurerm_kubernetes_cluster.kube-cluster-bas.kube_config_raw # config value from k8s.tf.tf file
  key_vault_id = azurerm_key_vault.key_vault.id
}

# data "azurerm_key_vault_secret" "key_secret" {
#   name         = "kubemybaskeyvaultsecret"
#   key_vault_id = azurerm_key_vault.key_vault.id
# }