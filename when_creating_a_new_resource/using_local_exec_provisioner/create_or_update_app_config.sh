#!/bin/bash

APP_CONFIG_NAME="$1"
RES_GROUP_NAME="$2"
SKU="$3"
ENABLE_PUBLIC_NETWORK="$4"
DISABLE_LOCAL_AUTH="$5"
LOCATION="$6"

app_config_instance=$(az appconfig list | jq --arg name "$APP_CONFIG_NAME" -e '.[]|select(.name==$name).name')

if [ -z "$app_config_instance" ]; then
    echo "App Config doesn't exists. Creating a new one."
    az appconfig create --name $APP_CONFIG_NAME --resource-group $RES_GROUP_NAME --sku $SKU --enable-public-network $ENABLE_PUBLIC_NETWORK --disable-local-auth $DISABLE_LOCAL_AUTH --location $LOCATION
fi