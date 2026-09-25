terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }

  # Configurazione Remote Backend (salva lo stato su Azure invece che sul runner locale)
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-dev"
    storage_account_name = "sttfstatesecapp9278" # Deve contenere solo lettere minuscole e numeri
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Azure Provider configuration
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }
}

# Random suffix to ensure globally unique names
resource "random_integer" "ri" {
  min = 1000
  max = 9999
}

# Core Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-${var.environment}-${var.location}"
  location = var.location

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AZ-104-Secure-Workload"
    CostCenter  = "FreeTier"
  }
}
