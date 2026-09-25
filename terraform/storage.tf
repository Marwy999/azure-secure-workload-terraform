# Primary Storage Account (LRS for zero-cost deployment)
resource "azurerm_storage_account" "sa" {
  name                     = "st${var.prefix}${var.environment}${random_integer.ri.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Private Blob Container
resource "azurerm_storage_container" "container" {
  name                  = "app-data"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
