#!/bin/bash
STORAGE_ACCT_NAME="$1"
RES_GROUP_NAME="$2"
SFTP_USER="$3"

az storage account local-user delete --account-name $STORAGE_ACCT_NAME -g  $RES_GROUP_NAME -n $SFTP_USER
