output "vm_private_ipaddress" {
  description = "The IP Address assigned to the main VM NIC"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "nic_id" {
  description = "the IP Address of the VM Network Interface"
  value       = azurerm_network_interface.vm_nic.id
}

output "vm_id" {
  value = var.is_custom_image ? azurerm_linux_virtual_machine.lin_vm[0].id : azurerm_linux_virtual_machine.vm[0].id
}