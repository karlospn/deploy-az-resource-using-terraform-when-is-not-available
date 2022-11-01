#!/bin/bash
STORAGE_ACCT_NAME="$1"
RES_GROUP_NAME="$2"
SFTP_USER="$3"

state=$(az feature show --namespace Microsoft.Storage --name AllowSFTP |  jq '.properties.state')

if [ $state == "NotRegistered" ]; then
    echo "Feature not registered. Trying to register it"
    az feature register --namespace Microsoft.Storage --name AllowSFTP 
fi

az storage account update -g $RES_GROUP_NAME -n $STORAGE_ACCT_NAME --enable-sftp=true
az storage account local-user create --account-name $STORAGE_ACCT_NAME -g  $RES_GROUP_NAME -n $SFTP_USER --home-directory "container" --permission-scope permissions="rw" service=blob resource-name="container" --has-ssh-key false --has-ssh-password true