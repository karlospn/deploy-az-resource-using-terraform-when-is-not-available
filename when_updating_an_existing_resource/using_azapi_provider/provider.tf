terraform {
  backend "local" {
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">3.0.0"
    }

    azapi = {
      source = "azure/azapi"
    }

  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}