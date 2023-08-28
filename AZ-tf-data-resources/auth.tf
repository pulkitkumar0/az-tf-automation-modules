#-----------------------------------------------------------
# Provider Authentication 
#----------------------------------------------------------

variable "client_secret" {} # Variable to store SP's password
variable "client_id" {}     # Application ID
variable "subscr_id" {}     # Subscription ID
variable "tenant_id" {}     # Tenant ID

# Terraform and Provider Version Constraints
terraform {
  required_version = ">=0.15" # tested with the 0.15.5
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.62"
    }
  }
}
provider "azurerm" {
  subscription_id = var.subscr_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

