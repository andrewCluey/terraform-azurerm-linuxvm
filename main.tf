# Create VM Network Interfaces
resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resourcegroup_name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


# If 'is_custom_image' = true. Create Custom VM
resource "azurerm_linux_virtual_machine" "lin_vm" {
  count               = var.is_custom_image ? 1 : 0
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resourcegroup_name
  size                = var.vm_size
  admin_username      = var.admin_username
  source_image_id     = var.image_id
  tags                = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.pubkey
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching              = lookup(var.storage_os_disk_config, "caching", null)
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", null)
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  identity {
    type = "SystemAssigned"
  }

  plan {
    name      = lookup(var.plan, "name", null)
    product   = lookup(var.plan, "product", null)
    publisher = lookup(var.plan, "publisher", null)
  }
}


# If 'is_custom_image' = false. Create VM from standard image.
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.is_custom_image ? 0 : 1
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resourcegroup_name
  size                = var.vm_size
  admin_username      = var.admin_username
  provision_vm_agent  = true
  tags                = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.pubkey
  }

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id
  ]

  source_image_reference {
    offer     = lookup(var.vm_image, "offer", null)
    publisher = lookup(var.vm_image, "publisher", null)
    sku       = lookup(var.vm_image, "sku", null)
    version   = lookup(var.vm_image, "version", null)
  }

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = lookup(var.storage_os_disk_config, "name", "${var.vm_name}-osdisk")
    caching              = lookup(var.storage_os_disk_config, "caching", null)
    storage_account_type = lookup(var.storage_os_disk_config, "storage_account_type", null)
    disk_size_gb         = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  plan {
    name      = lookup(var.plan, "name", null)
    product   = lookup(var.plan, "product", null)
    publisher = lookup(var.plan, "publisher", null)
  }

  identity {
    type = "SystemAssigned"
  }
}
