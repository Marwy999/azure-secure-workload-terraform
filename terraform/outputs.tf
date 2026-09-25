output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Target resource group name."
}

output "web_app_url" {
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
  description = "Public Web App endpoint."
}

output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "Key Vault service URI."
}

output "storage_account_name" {
  value       = azurerm_storage_account.sa.name
  description = "Storage account name."
}
