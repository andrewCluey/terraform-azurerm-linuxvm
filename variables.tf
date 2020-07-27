# #######################################################
# Commmon variables. Usually required across ALL modules.
# #######################################################
variable "location" {
  description = "The Azure location where new resources will be created."
  type        = string
  default     = "west europe"
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the new resource should be deployed."
  type        = string
}

# ##########################################
# Variables for use within this module only.
# ##########################################
variable "vnet_resourcegroup" {
  description = "The name of the Resource group where the vNet and Subnets reside for the VM."
  type        = string
}

variable "ssh_pub_key" {
  description = "The SSH public key forthe admin user account."
  type        = string
}


variable "subnet_name" {
  description = "The name of the subnet where you want the VMs to be placed"
  type        = string
}

variable "vnet_name" {
  description = "The name of the vNet where the subnet resides."
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to deploy"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The size of the Virtual machine to be deployed."
  type        = string
  default     = "Standard_B1s"
}

variable "storage_type" {
  description = "The type of storage account that should back the internal Disks."
  type        = string
  default     = "StandardSSD_LRS"
}

variable "tags" {
  description = "A map of Key:Value pairs to TAG the new resource"
  type        = map(string)
}

