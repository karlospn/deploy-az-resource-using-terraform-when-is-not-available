locals {
    resource_group_name = "rg-provisioning-demo"
}

## Create Resource Group
resource "azurerm_resource_group" "rg_demo" {
    name      = local.resource_group_name
    location  = "West Europe"
}

## Create Storage Account
resource "azurerm_storage_account" "sftp_storage_acct" {
    name                        = "stsftprovdev"
    location                    = azurerm_resource_group.rg_demo.location
    resource_group_name         = azurerm_resource_group.rg_demo.name
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    min_tls_version             = "TLS1_2"
    is_hns_enabled           = true
}

# Create container
resource "azurerm_storage_container" "sftp_storage_acct_container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.sftp_storage_acct.name
}

# Enable SFTP
resource "azapi_update_resource" "sftp_azpi_sftp" {
  type        = "Microsoft.Storage/storageAccounts@2021-09-01"
  resource_id = azurerm_storage_account.sftp_storage_acct.id

  body = jsonencode({
    properties = {
      isSftpEnabled = true
    }
  })

  depends_on = [
    azurerm_storage_account.sftp_storage_acct,
    azurerm_storage_container.sftp_storage_acct_container
  ]
  response_export_values = ["*"]
}

# Create local user
resource "azapi_resource" "sftp_local_user" {
  type        = "Microsoft.Storage/storageAccounts/localUsers@2021-09-01"
  parent_id = azurerm_storage_account.sftp_storage_acct.id
  name = "ftpuser"

  body = jsonencode({
    properties = {
      hasSshPassword = true,
      homeDirectory = "container"
      hasSharedKey = true,
      hasSshKey = false,
      permissionScopes = [{
        permissions = "rw",
        service = "blob",
        resourceName = "container"
      }]
    }
  })

  response_export_values = ["*"]

  depends_on = [
    azurerm_storage_account.sftp_storage_acct,
    azurerm_storage_container.sftp_storage_acct_container,
    azapi_update_resource.sftp_azpi_sftp
  ]
}