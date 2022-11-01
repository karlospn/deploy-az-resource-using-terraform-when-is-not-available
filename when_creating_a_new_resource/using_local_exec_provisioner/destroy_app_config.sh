#!/bin/bash

APP_CONFIG_NAME="$1"
RES_GROUP_NAME="$2"
SKU="$3"
ENABLE_PUBLIC_NETWORK="$4"
DISABLE_LOCAL_AUTH="$5"

app_config_instance=$(az appconfig list | jq --arg name "$APP_CONFIG_NAME" -e '.[]|select(.name==$name).name')

if [ -z "$app_config_instance" ]; then
    echo "App Config doesn't exist. No need to delete anything."
else
    echo "App Config found. Trying to destroy the resource."
    az appconfig delete --name $APP_CONFIG_NAME --resource-group $RES_GROUP_NAME --yes
    sleep 5s
fi