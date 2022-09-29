provider   "azurerm"   { 
   features   {} 
  } 

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.39.0"
    }
  }
}

  resource  "azurerm_resource_group" "myterraformngroup"   { 
   name     = "demo2-rg" 
   location = "East US" 
  } 

  resource  "azurerm_virtual_network" "myterraformnetwork"   { 
   name                 = "myVnet" 
   address_space        = ["10.0.0.0/16"] 
   location             = "East US"
   resource_group_name  = azurerm_resource_group.myterraformngroup.name
  } 

  resource  "azurerm_subnet" "myterraformsubnet"   { 
   name                 =   "mySubnet" 
   resource_group_name  = azurerm_resource_group.myterraformngroup.name 
   virtual_network_name = azurerm_virtual_network.myterraformnetwork.name 
   address_prefixes     = ["10.0.1.0/24"]
  } 

  resource  "azurerm_public_ip" "myterraformpublicip"   { 
   name                = "myPublicIP" 
   location            = "East US" 
   resource_group_name = azurerm_resource_group.myterraformngroup.name
   allocation_method   = "Dynamic" 
   sku                 = "Basic" 
  } 

  resource "azurerm_network_interface" "myterraformnic"   { 
   name                = "myNIC" 
   location            = "East US" 
   resource_group_name = azurerm_resource_group.myterraformngroup.name 

    ip_configuration   { 
     name                          = "myNicConfig" 
     subnet_id                     = azurerm_subnet.myterraformsubnet.id 
     private_ip_address_allocation = "Dynamic" 
     public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id 
    } 
  } 

  resource "azurerm_linux_virtual_machine" "terraformvm" {
   name                            = "mylinux"
   location                        = "East US"
   resource_group_name             = azurerm_resource_group.myterraformngroup.name 
   network_interface_ids           = [azurerm_network_interface.myterraformnic.id]
   size                            = "Standard_B1s"
   admin_username                  = "admin1"
   admin_password                  = "pass@^@:)"
   disable_password_authentication = false
   

   os_disk {
    name                 = "osdisk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
   }

   source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
   }
 } 
 
