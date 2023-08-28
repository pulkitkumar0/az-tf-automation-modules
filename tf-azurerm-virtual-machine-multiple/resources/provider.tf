# Configure the Microsoft Azure Provider
terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

provider "tls" {
  # Configuration options
}