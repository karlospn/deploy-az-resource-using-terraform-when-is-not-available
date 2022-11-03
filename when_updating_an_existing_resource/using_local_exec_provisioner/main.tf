locals {
    resource_group_name = "rg-provisioning-demo"
    storage_account_name = "stsftprovdev"
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
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    min_tls_version             = "TLS1_2"
    is_hns_enabled           = true
}

# Create container
resource "azurerm_storage_container" "azurerm_storage_container" {
  name                  = "container"
  storage_account_name  = azurerm_storage_account.sftp_storage_acct.name
}


## Enable SFTP and create SFTP local users using an external script
resource "null_resource" "sftp_enable" {
    triggers = {
        storage_account_name = local.storage_account_name
        res_group_name = local.resource_group_name
        sftp_user = "ftpuser"
    }
    provisioner "local-exec" {
        command = "./enable_sftp_create_localuser.sh ${self.triggers.storage_account_name} ${self.triggers.res_group_name} ${self.triggers.sftp_user}"
        interpreter = ["bash", "-c"]
    }

    provisioner "local-exec" {
        when = destroy
        command = "./disable_sftp_and_localuser.sh ${self.triggers.storage_account_name} ${self.triggers.res_group_name} ${self.triggers.sftp_user}" 
        interpreter = ["bash", "-c"]
    }

    depends_on = [
        azurerm_storage_container.azurerm_storage_container
    ]
}