 resource "azurerm_resource_group" "concat(var.name)" {
   name     = "pulkit-azure-rg"
   location = "eastus"
 }

/*
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
   count               = 2
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
   count                = 2
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

#############################Linux VMs###############################################################################################
 resource "azurerm_linux_virtual_machine" "pulkit-azure" {
   count                 = 2
   name                  = "acctvm${count.index}"
   location              = azurerm_resource_group.pulkit-azure.location
   availability_set_id   = azurerm_availability_set.avset.id
   resource_group_name   = azurerm_resource_group.pulkit-azure.name
   network_interface_ids = [element(azurerm_network_interface.pulkit-azure.*.id, count.index)]
   size               = "Standard_DS1_v2"
	admin_username      = "adminuser"
   # delete_os_disk_on_termination = true
   # delete_data_disks_on_termination = true

   admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
*/