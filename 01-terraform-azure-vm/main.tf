#There are steps that you must follow to create a virtual machine

# create a resource group
# create a virtual network
# create a subnet
# create a network interface card
# create a virtual machine (we can also create disks etc as a separate step)

terraform {
}

# NOTE: I have create a file called provider.tf and moded the below section in that file.
#provider "azurerm" {
#  features {}
#  subscription_id   = "xxxx"
#  tenant_id         = "xxxx"
#  client_id         = "xxxx"
#  client_secret     = "xxxx"
#}

resource "azurerm_resource_group" "azvm-rg" {
  location = "eastus"
  name     = "azvm-rg"
}

resource "azurerm_virtual_network" "azvnet" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azvm-rg.location
  name                = "azvnet"
  resource_group_name = azurerm_resource_group.azvm-rg.name
}

resource "azurerm_subnet" "azsubnet1" {
  name                 = "azsubnet1"
  resource_group_name  = azurerm_resource_group.azvm-rg.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "aznetworkinterface" {
  location            = azurerm_resource_group.azvm-rg.location
  name                = "aznetworkinterface"
  resource_group_name = azurerm_resource_group.azvm-rg.name
  ip_configuration {
    name                          = "aznetworkinterfaceip"
    subnet_id                     = azurerm_subnet.azsubnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# az vm image list --output table
# az vm image list --all
# az vm image list-offers -l westus -p MicrosoftWindowsServer
# az vm image list -f CentOS

resource "azurerm_windows_virtual_machine" "winvm1" {
  admin_password        = "P@ss2.rd1234"
  admin_username        = "azureuser"
  location              = azurerm_resource_group.azvm-rg.location
  name                  = "winvm1"
  network_interface_ids = [azurerm_network_interface.aznetworkinterface.id]
  resource_group_name   = azurerm_resource_group.azvm-rg.name
  size                  = "standard_f2"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
