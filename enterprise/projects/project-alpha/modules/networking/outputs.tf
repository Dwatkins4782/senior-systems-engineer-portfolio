output "vnet_id" {
  description = "Resource ID of the spoke VNet"
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "Name of the spoke VNet"
  value       = azurerm_virtual_network.spoke.name
}

output "subnet_ids" {
  description = "Map of subnet names to their resource IDs"
  value       = { for name, subnet in azurerm_subnet.subnets : name => subnet.id }
}

output "nsg_ids" {
  description = "Map of NSG names to their resource IDs"
  value       = { for name, nsg in azurerm_network_security_group.subnets : name => nsg.id }
}

output "resource_group_name" {
  description = "Name of the network resource group"
  value       = azurerm_resource_group.network.name
}
