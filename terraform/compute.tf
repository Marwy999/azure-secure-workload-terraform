# App Service Plan (Free F1 Tier)
resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.prefix}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

# Linux Web App host
resource "azurerm_linux_web_app" "app" {
  name                = "app-${var.prefix}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false # Required for F1 SKU
    application_stack {
      node_version = "18-lts"
    }
  }

  # Bind managed identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  app_settings = {
    "KEY_VAULT_URL" = azurerm_key_vault.kv.vault_uri
  }
}
