# Reusable Networking Module for Project Spoke Networks

resource "azurerm_resource_group" "network" {
  name     = "${var.project_name}-${var.environment}-network-rg-${var.location}"
  location = var.location
  tags     = var.tags
}

# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = "acme-${var.environment}-${var.project_name}-vnet-${var.location}-001"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  address_space       = [var.vnet_address_space]
  
  tags = var.tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets
  
  name                 = "${each.key}-subnet"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])
  
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name = delegation.value.service_name
      }
    }
  }
}

# Network Security Groups per subnet
resource "azurerm_network_security_group" "subnets" {
  for_each = var.subnets
  
  name                = "acme-${var.environment}-${var.project_name}-${each.key}-nsg-${var.location}-001"
  resource_group_name = azurerm_resource_group.network.name
  location            = azurerm_resource_group.network.location
  
  tags = var.tags
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "subnets" {
  for_each = var.subnets
  
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.subnets[each.key].id
}

# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count = var.hub_vnet_id != null ? 1 : 0
  
  name                         = "${var.project_name}-${var.environment}-to-hub"
  resource_group_name          = azurerm_resource_group.network.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateway
}

# VNet Peering: Hub to Spoke (requires provider alias or separate configuration)
# This would typically be managed by the hub or via Azure Policy

# Route Table (force traffic through hub firewall)
resource "azurerm_route_table" "spoke" {
  count = var.enable_forced_tunneling ? 1 : 0
  
  name                          = "acme-${var.environment}-${var.project_name}-rt-${var.location}-001"
  resource_group_name           = azurerm_resource_group.network.name
  location                      = azurerm_resource_group.network.location
  disable_bgp_route_propagation = false
  
  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.hub_firewall_private_ip
  }
  
  tags = var.tags
}

# Associate route table with subnets (except AKS if using CNI)
resource "azurerm_subnet_route_table_association" "spoke" {
  for_each = var.enable_forced_tunneling ? {
    for key, subnet in var.subnets : key => subnet
    if !contains(var.exclude_route_table_subnets, key)
  } : {}
  
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.spoke[0].id
}
