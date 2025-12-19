# Outputs for Enterprise Foundation Hub Network

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.hub.name
}

output "hub_resource_group_name" {
  description = "Name of the hub resource group"
  value       = azurerm_resource_group.hub.name
}

output "firewall_private_ip" {
  description = "Private IP address of Azure Firewall (for route tables)"
  value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  description = "Public IP address of Azure Firewall"
  value       = azurerm_public_ip.firewall.ip_address
}

output "bastion_id" {
  description = "Resource ID of Azure Bastion"
  value       = azurerm_bastion_host.hub.id
}

output "vpn_gateway_id" {
  description = "Resource ID of VPN Gateway (if enabled)"
  value       = var.enable_vpn_gateway ? azurerm_virtual_network_gateway.vpn[0].id : null
}

output "route_table_id" {
  description = "Resource ID of the hub route table (for spoke association)"
  value       = azurerm_route_table.hub.id
}

output "private_dns_zone_ids" {
  description = "Map of private DNS zones for Azure services"
  value       = { for name, zone in azurerm_private_dns_zone.services : name => zone.id }
}

output "dns_resource_group_name" {
  description = "Resource group containing private DNS zones"
  value       = azurerm_resource_group.dns.name
}

output "network_watcher_id" {
  description = "Resource ID of Network Watcher"
  value       = azurerm_network_watcher.hub.id
}

output "deployment_summary" {
  description = "Summary of hub network deployment"
  value = {
    hub_vnet            = azurerm_virtual_network.hub.name
    hub_address_space   = var.hub_vnet_address_space
    firewall_private_ip = azurerm_firewall.hub.ip_configuration[0].private_ip_address
    bastion_enabled     = true
    vpn_gateway_enabled = var.enable_vpn_gateway
    ddos_enabled        = var.enable_ddos_protection
    private_dns_zones   = length(azurerm_private_dns_zone.services)
  }
}
