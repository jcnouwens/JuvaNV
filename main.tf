# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-test"
  location = "westeurope"
}

resource "azurerm_databricks_workspace" "workspace" {
  name                = "dbw-wl-terraform-test"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"

  tags = {
    Environment = "Test"
  }
}

resource "azurerm_storage_account" "datalake" {
  name                     = "sawlterraformtest2"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = "true"
}


resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "bronze"
  storage_account_id = azurerm_storage_account.datalake.id
}


resource "azurerm_storage_data_lake_gen2_filesystem" "unity" {
  name               = "unity"
  storage_account_id = azurerm_storage_account.datalake.id
}
