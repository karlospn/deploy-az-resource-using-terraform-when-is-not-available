locals {
    resource_group_name = "rg-provisioning-demo"
    app_conf_name = "appconf-demo-dev"
    app_conf_sku = "free"
    app_conf_public_network_access = "Enabled"
    app_conf_disable_local_auth = false
    app_conf_location = "westeurope"
}

## Create Resource Group
resource "azurerm_resource_group" "rg_demo" {
    name      = local.resource_group_name
    location  = "West Europe"
}

## Create App Configuration using the resource group arm template resource
resource "azurerm_resource_group_template_deployment" "appconf" {
    name                  = "app-conf-deploy"
    resource_group_name   = local.resource_group_name
    deployment_mode       = "Incremental"
    template_content      = file("template.json")
    parameters_content  = <<PARAMETERS
    {
        "name": {
            "value": "${local.app_conf_name}"
        },
        "location": {
            "value": "${local.app_conf_location}"
        },
        "sku": {
            "value": "${local.app_conf_sku}"
        },
        "public_network_access": {
            "value": "${local.app_conf_public_network_access}"
        },
        "disable_local_auth": {
            "value": "${local.app_conf_disable_local_auth}"
        }
    }
    PARAMETERS 
    depends_on = [
        azurerm_resource_group.rg_demo
    ]
}