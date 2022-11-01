locals {
    resource_group_name = "rg-provisioning-demo"
    app_conf_name = "appconf-demo-dev"
    app_conf_sku = "free"
    app_conf_public_network_access = "Enabled"
    app_conf_disable_local_auth = false
}

## Create Resource Group
resource "azurerm_resource_group" "rg_demo" {
    name      = local.resource_group_name
    location  = "West Europe"
}

## Create App Configuration using the AzApi provider
resource "azapi_resource" "appconf" {
    type      = "Microsoft.AppConfiguration/configurationStores@2022-05-01"
    name      = local.app_conf_name
    parent_id = azurerm_resource_group.rg_demo.id
    location  = azurerm_resource_group.rg_demo.location
    body =  jsonencode({      
        sku = {
            name = local.app_conf_sku
        } 
        properties = {
            publicNetworkAccess = local.app_conf_public_network_access
            disableLocalAuth = local.app_conf_disable_local_auth
        }
    })
    response_export_values = ["*"]
}