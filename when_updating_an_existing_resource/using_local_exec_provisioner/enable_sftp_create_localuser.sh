#!/bin/bash
STORAGE_ACCT_NAME="$1"
RES_GROUP_NAME="$2"
SFTP_USER="$3"

state=$(az feature show --namespace Microsoft.Storage --name AllowSFTP |  jq '.properties.state')

if [ $state != '"Registered"' ]; then
    echo "Feature not registered. Registration is an asynchronous operation, it must be done manually."
    exit 1
fi

extension=$(az extension list | jq -e '.[]|select(.name=="storage-preview").name')
if [ -z "$extension" ]; then
    echo "Storage-preview extension missing. Installing it."
    az extension add -n storage-preview
fi

az storage account update -g $RES_GROUP_NAME -n $STORAGE_ACCT_NAME --enable-sftp true
az storage account local-user create --account-name $STORAGE_ACCT_NAME -g  $RES_GROUP_NAME -n $SFTP_USER --home-directory "container" --has-ssh-password true --permission-scope permissions=rw service=blob resource-name=container