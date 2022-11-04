locals {
    resource_group_name         = "rg-provisioning-demo"
    storage_account_name        = "stsftprovdev"
    storage_account_tier        = "Standard"
    storage_account_replication = "LRS"
    storage_account_min_tls     = "TLS1_2"
    storage_account_hns_enabled = true
    sftp_user                   = "ftpuser2"
}

## Create Resource Group
resource "azurerm_resource_group" "rg_demo" {
    name      = local.resource_group_name
    location  = "West Europe"
}

## Create Storage Account
resource "azurerm_storage_account" "sftp_storage_acct" {
    name                        = local.storage_account_name
    location                    = azurerm_resource_group.rg_demo.location
    resource_group_name         = azurerm_resource_group.rg_demo.name
    account_tier                = local.storage_account_tier
    account_replication_type    = local.storage_account_replication
    min_tls_version             = local.storage_account_min_tls
    is_hns_enabled              = local.storage_account_hns_enabled
}

# Create container
resource "azurerm_storage_container" "azurerm_storage_container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.sftp_storage_acct.name
}

## Enable SFTP and add local users using the resource group arm template resource
resource "azurerm_resource_group_template_deployment" "sftp" {
    name                  = "sftp-deploy"
    resource_group_name   = local.resource_group_name
    deployment_mode       = "Incremental"
    template_content      = file("template.json")
    parameters_content  = <<PARAMETERS
    {
        "storage_account_name": {
            "value": "${local.storage_account_name}"
        },
        "storage_account_tier": {
            "value": "${local.storage_account_tier}"
        },
        "storage_account_replication": {
            "value": "${local.storage_account_replication}"
        },
        "storage_account_min_tls": {
            "value": "${local.storage_account_min_tls}"
        },
        "storage_account_hns_enabled": {
            "value": ${local.storage_account_hns_enabled}
        },
        "sftp_user": {
            "value": "${local.sftp_user}"
        }
    }
    PARAMETERS 
    depends_on = [
        azurerm_resource_group.rg_demo,
        azurerm_storage_account.sftp_storage_acct,
        azurerm_storage_container.azurerm_storage_container
    ]
}