# ##################################################################
# Terraform module to deploy a VM with a single VM NIC. 
# Additional VM NICs can be deployed through the 'vm_nic' TF module.
# ##################################################################

provider "azurerm" {
  features {}
}

# ################################################
# DATA LOOKUPS
# Get data for resources already deployed.
# Takes inputs from user specified variables file.
# ################################################

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_resourcegroup
}

data "azurerm_resource_group" "rg_for_vm" {
  name = var.resource_group_name
}

# #########################
# CREATE NETWORK INTERFACES
# #########################

resource "azurerm_network_interface" "linux_vmnic" {
  name                = "${var.vm_name}-NIC"
  location            = data.azurerm_resource_group.rg_for_vm.location
  resource_group_name = data.azurerm_resource_group.rg_for_vm.name

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# ###################################################
# CREATE VIRTUAL MACHINES.
# Only supports Dynamic IP address allocation so far.
# Needs an improved image reference lookup code block. 
# ####################################################

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.vm_name
  resource_group_name             = data.azurerm_resource_group.rg_for_vm.name
  location                        = data.azurerm_resource_group.rg_for_vm.location
  size                            = var.vm_size
  admin_username                  = "adminuser"
  disable_password_authentication = true
  tags                            = var.tags
  network_interface_ids           = [azurerm_network_interface.linux_vmnic.id]


  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_pub_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
