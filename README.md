# How to deploy an Azure resource using Terraform when it is not available in the AzureRM official provider

Everyone who has worked long enough with Terraform in Azure has been in the position of wanting to deploy a resource that's not available on the official [Azure Terraform provider](https://registry.terraform.io/providers/hashicorp/azurerm).    
The same situation also happens when trying to enable a feature of an existing resource and that feature is missing from the Azure Terraform provider.

Right now there are **3 options available** when you want to create or update an Azure resource but this resource doesn't exist on the AzureRM Terraform Provider:
- Using the ``null_resource`` resource alongside with ``local-exec`` provisioner, and building a script that uses the ``Azure CLI`` or the ``Azure Az Powershell Module``.
- Using the ``azurerm_resource_group_template_deployment`` resource alongside an ``ARM Template``.
- Using the ``AzAPI`` provider.

This repository contains a few of examples of it.

**Important**: Using any of these options to provision or update a resource using Terraform should be a last resort and it makes sense only when the AzureRM provider doesn't have an implementation for the service we want to create or update.

# **Folder structure**

- ``/when_creating_a_new_resource`` folder contains:
  -  An example of how to create an Azure App Configuration using the ``AzApi`` provider.
  - An example of how to create an Azure App Configuration using the ``azurerm_resource_group_template_deployment`` resource +  an ``ARM Template``.
  - An example of how to create an Azure App Configuration using the ``null_resource`` + ``local-exec`` provisioner + ``Az CLI`` shell script.

_I'm aware that you can create an Azure App Configuration using the ``azurerm_app_configuration`` resource available on the AzureRM provider, but this is just an example of how you can provision an Azure resource using Terraform without the AzureRM provider._

- ``/when_updating_an_existing_resource`` folder contains:
  - An example of how to enable the SFTP support on an existing Azure Blob Storage using the ``AzApi`` provider.
  - An example of how to enable the SFTP support on an existing Azure Blob Storage using the ``azurerm_resource_group_template_deployment`` resource +  an ``ARM Template``.
  - An example of how to enable the SFTP support on an existing Azure Blob Storage using the ``null_resource`` + ``local-exec`` provisioner + ``Az CLI`` shell script.

