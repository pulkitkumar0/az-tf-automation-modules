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



 resource "azurerm_resource_group" "pulkit-azure" {
   name     = "test-azure-rg"
   location = "eastus"
 }

 resource "azurerm_virtual_network" "pulkit-azure" {
   name                = "acctvn"
   address_space       = ["10.0.0.0/16"]
   location            = azurerm_resource_group.pulkit-azure.location
   resource_group_name = azurerm_resource_group.pulkit-azure.name
 }

 resource "azurerm_subnet" "pulkit-azure" {
   name                 = "acctsub"
   resource_group_name  = azurerm_resource_group.pulkit-azure.name
   virtual_network_name = azurerm_virtual_network.pulkit-azure.name
   address_prefixes     = ["10.0.2.0/24"]
 }

 resource "azurerm_public_ip" "pulkit-azure" {
   name                         = "publicIPForLB"
   location                     = azurerm_resource_group.pulkit-azure.location
   resource_group_name          = azurerm_resource_group.pulkit-azure.name
   allocation_method            = "Static"
 }

 resource "azurerm_lb" "pulkit-azure" {
   name                = "loadBalancer"
   location            = azurerm_resource_group.pulkit-azure.location
   resource_group_name = azurerm_resource_group.pulkit-azure.name

   frontend_ip_configuration {
     name                 = "publicIPAddress"
     public_ip_address_id = azurerm_public_ip.pulkit-azure.id
   }
 }

 resource "azurerm_lb_backend_address_pool" "pulkit-azure" {
   loadbalancer_id     = azurerm_lb.pulkit-azure.id
   name                = "BackEndAddressPool"
 }

 resource "azurerm_network_interface" "pulkit-azure" {
   count               = 1
   name                = "acctni${count.index}"
   location            = azurerm_resource_group.pulkit-azure.location
   resource_group_name = azurerm_resource_group.pulkit-azure.name

   ip_configuration {
     name                          = "pulkit-azureConfiguration"
     subnet_id                     = azurerm_subnet.pulkit-azure.id
     private_ip_address_allocation = "dynamic"
   }
 }

 resource "azurerm_managed_disk" "pulkit-azure" {
   count                = 1
   name                 = "datadisk_existing_${count.index}"
   location             = azurerm_resource_group.pulkit-azure.location
   resource_group_name  = azurerm_resource_group.pulkit-azure.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "1023"
 }

 resource "azurerm_availability_set" "avset" {
   name                         = "avset"
   location                     = azurerm_resource_group.pulkit-azure.location
   resource_group_name          = azurerm_resource_group.pulkit-azure.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }


resource "azurerm_virtual_machine" "web_server" {
  name                  = "server"
  location              = "eastus"
  resource_group_name   = "test-azure-rg"
  network_interface_ids = [element(azurerm_network_interface.pulkit-azure.*.id, count.index)]
  vm_size               = "Standard_B2s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "server-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name      = "server"
    admin_username     = "server"
    admin_password     = "Passw0rd1234"

  }

  os_profile_windows_config {
  }

}