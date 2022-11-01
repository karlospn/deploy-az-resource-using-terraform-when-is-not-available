locals {
    resource_group_name = "rg-provisioning-demo"
    app_conf_name = "appconf-demo-dev"
    app_conf_sku = "Free"
    app_conf_enable_public_network = true
    app_conf_disable_local_auth = false
    app_conf_location = "westeurope"
}

## Create Resource Group
resource "azurerm_resource_group" "rg_demo" {
    name      = local.resource_group_name
    location  = "West Europe"
}

## Create App Configuration using the external script
resource "null_resource" "app_conf_demo_creation" {
    triggers = {
        app_conf_name = local.app_conf_name
        res_group_name = local.resource_group_name
        sku = local.app_conf_sku
        enable_public_network = local.app_conf_enable_public_network
        disable_local_auth = local.app_conf_disable_local_auth
        location = local.app_conf_location
    }
    provisioner "local-exec" {
        command = "./create_or_update_app_config.sh ${self.triggers.app_conf_name} ${self.triggers.res_group_name} ${self.triggers.sku} ${self.triggers.enable_public_network} ${self.triggers.disable_local_auth} ${self.triggers.location}" 
        interpreter = ["bash", "-c"]
    }
    depends_on = [
        azurerm_resource_group.rg_demo
    ]
}

## Destroy App Configuration using the external script
resource "null_resource" "app_conf_demo_deletion" {
    triggers = {
        app_conf_name = local.app_conf_name
        res_group_name = local.resource_group_name
        sku = local.app_conf_sku
        enable_public_network = local.app_conf_enable_public_network
        disable_local_auth = local.app_conf_disable_local_auth
        location = local.app_conf_location
    }
    provisioner "local-exec" {
        when = destroy
        command = "./destroy_app_config.sh ${self.triggers.app_conf_name} ${self.triggers.res_group_name} ${self.triggers.sku} ${self.triggers.enable_public_network} ${self.triggers.disable_local_auth}"
        interpreter = ["bash", "-c"]
    }
    depends_on = [
        azurerm_resource_group.rg_demo
    ]
}