variable "location" {
  description = "The azure region where the new resource will be created"
  type        = string
}

variable "resourcegroup_name" {
  description = "The name of the Resource Group where the new VM should be created."
  type        = string
}

variable "tags" {
  description = "(optional) describe your variable"
  type        = map(string)
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VMs main NIC will reside"
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html#source_image_reference"
  type        = map(string)

  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "vm_size" {
  description = "The size of the new Vm to deploy. Options can be found HERE."
  default     = "standard_b2s"
  type        = string
}

variable "vm_name" {
  description = "The name to assign to the new VM"
  type        = string
}

variable "storage_os_disk_config" {
  description = "Map to configure OS storage disk. (Caching, size, storage account type...)"
  type        = map(string)
  default = {
    disk_size_gb         = "127" # minimum disk size of 127GB
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

variable "admin_username" {
  description = "The admin username to set."
  type        = string
  default     = "adminuser"
}

variable "pubkey_path" {
  description = "Th epath to the public key file for accessing the admin user."
  type        = string
}


variable "diagnostics_storage_account_name" {
  description = "The Storage account to use for VM diagnostics"
  type        = string
}

variable "is_custom_image" {
  description = "Is the VM deployed from a custom image? True/False"
  type        = bool
  default     = false
}

variable "custom_image_name" {
  description = "The name of the Custom Azure VM Image to deploy from."
  type        = string
  default     = null
}

variable "image_rg" {
  description = "The name of the Resource Group where the custom image resides."
  type        = string
  default     = null
}

variable "image_id" {
  description = "If deploying a custom VM image, enter in the the ID of the custom image."
  type        = string
  default     = null
}

variable "plan" {
  description = "A Plan block to be used when the source VM image was taken from a marketplace image (Required data will be tagged on to the VM Image.)"
  type        = map(string)
}
