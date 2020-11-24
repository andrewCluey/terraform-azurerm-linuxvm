# terraform-azurerm-linuxvm
Deploy a Linux VM with Password auth disabled.


## Standard or Custom images


## Example deployment
The example block of code below shows a deployment of three Centos 7 images created by the center for internet security (CIS).
```
data "azurerm_subnet" "default_sn" {
    name                 = var.subnet_name
    virtual_network_name = var.vnet_name
    resource_group_name  = var.vnet_resource_group
    }

locals {
    centos_vm = { 
        "offer": "cis-centos-7-v2-1-1-l1", 
        "publisher": "center-for-internet-security-inc", 
        "sku": "cis-centos7-l1", 
        "version": "3.0.4"
        }

    plan = {
        name      = "cis-centos7-l1"
        product   = "cis-centos-7-v2-1-1-l1"
        publisher = "center-for-internet-security-inc"
        }
}

module "centos_vm" {
  source  = "andrewCluey/linuxvm/azurerm"
  version = "1.2.0"
  
  count                            = "3"
  location                         = var.location
  resourcegroup_name               = var.rg_name
  vm_name                          = "SV-${var.environment}-CENTOS${count.index + 1}"
  vm_image                         = local.centos_vm
  vm_size                          = var.vm_size
  plan                             = local.plan
  admin_username                   = "adminuser"
  subnet_id                        = data.azurerm_subnet.default_sn.id
  pubkey                           = var.pubkey
  diagnostics_storage_account_name = var.diagnostic_storage_account
}

```