terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "tfstate1984"
    container_name       = "tfstate2"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
