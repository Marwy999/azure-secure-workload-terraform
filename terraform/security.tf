# User-assigned identity for workload authorization
resource "azurerm_user_assigned_identity" "identity" {
  name                = "id-${var.prefix}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Fetch deployment principal context
data "azurerm_client_config" "current" {}

# Key Vault instance
resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.prefix}-${random_integer.ri.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  # Access policy for Terraform runner
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }

  # Read-only policy for App Service workload
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.identity.principal_id

    secret_permissions = [
      "Get", "List"
    ]
  }
}

# Managed application secret
resource "azurerm_key_vault_secret" "db_connection" {
  name         = "DatabaseConnectionString"
  value        = "Server=tcp:sqlserver.database.windows.net;Database=appdb;"
  key_vault_id = azurerm_key_vault.kv.id
}
