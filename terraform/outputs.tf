output "kube_admin_config" {
  value = azurerm_kubernetes_cluster.kube-cluster-bas.kube_admin_config_raw
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kube-cluster-bas.kube_config_raw
  sensitive = true
}

output "kube_config_secrets" {
  value = azurerm_key_vault_secret.kube_config_key_vault_secret.value
  sensitive = true
}