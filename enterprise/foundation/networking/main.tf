# Enterprise Foundation - Hub Network Infrastructure
# Provides centralized networking, security, and connectivity for all projects

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "acme-prod-foundation-rg-eastus-001"
    storage_account_name = "acmeprodfoundationst001"
    container_name       = "tfstate"
    key                  = "foundation-network.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Hub Resource Group
resource "azurerm_resource_group" "hub" {
  name     = "acme-prod-hub-network-rg-${var.location}-001"
  location = var.location
  
  tags = merge(local.common_tags, {
    Purpose = "Hub Network"
  })
}

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = "acme-prod-hub-vnet-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  address_space       = [var.hub_vnet_address_space]
  
  tags = local.common_tags
}

# DDoS Protection Plan (Production)
resource "azurerm_network_ddos_protection_plan" "hub" {
  count               = var.enable_ddos_protection ? 1 : 0
  name                = "acme-prod-hub-ddos-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  
  tags = local.common_tags
}

# Gateway Subnet (for VPN/ExpressRoute)
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"  # Must be exactly "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_prefix]
}

# Azure Firewall Subnet
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"  # Must be exactly "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_prefix]
}

# Azure Bastion Subnet
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"  # Must be exactly "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.bastion_subnet_prefix]
}

# Shared Services Subnet (DNS, AD, monitoring)
resource "azurerm_subnet" "shared_services" {
  name                 = "SharedServicesSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.shared_services_subnet_prefix]
  
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Sql"
  ]
}

# Management Subnet (jump boxes)
resource "azurerm_subnet" "management" {
  name                 = "ManagementSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.management_subnet_prefix]
  
  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

# Public IP for Azure Firewall
resource "azurerm_public_ip" "firewall" {
  name                = "acme-prod-hub-firewall-pip-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = local.common_tags
}

# Azure Firewall
resource "azurerm_firewall" "hub" {
  name                = "acme-prod-hub-afw-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  
  ip_configuration {
    name                 = "firewall-ipconfig"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  
  tags = local.common_tags
}

# Firewall Network Rules
resource "azurerm_firewall_network_rule_collection" "outbound" {
  name                = "outbound-rules"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"
  
  rule {
    name = "allow-ntp"
    source_addresses  = ["*"]
    destination_ports = ["123"]
    destination_addresses = ["*"]
    protocols = ["UDP"]
  }
  
  rule {
    name = "allow-dns"
    source_addresses  = ["*"]
    destination_ports = ["53"]
    destination_addresses = ["*"]
    protocols = ["UDP", "TCP"]
  }
  
  rule {
    name = "allow-https"
    source_addresses  = ["*"]
    destination_ports = ["443"]
    destination_addresses = ["*"]
    protocols = ["TCP"]
  }
  
  rule {
    name = "allow-http"
    source_addresses  = ["*"]
    destination_ports = ["80"]
    destination_addresses = ["*"]
    protocols = ["TCP"]
  }
}

# Firewall Application Rules
resource "azurerm_firewall_application_rule_collection" "approved_services" {
  name                = "approved-services"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub.name
  priority            = 100
  action              = "Allow"
  
  rule {
    name = "allow-azure-services"
    source_addresses = ["*"]
    
    fqdn_tags = [
      "AzureKubernetesService",
      "WindowsUpdate",
      "AzureBackup"
    ]
  }
  
  rule {
    name = "allow-package-managers"
    source_addresses = ["*"]
    
    target_fqdns = [
      "*.docker.io",
      "*.docker.com",
      "*.github.com",
      "*.githubusercontent.com",
      "*.npmjs.org",
      "*.pypi.org",
      "*.nuget.org",
      "*.ubuntu.com",
      "*.debian.org"
    ]
    
    protocol {
      port = "443"
      type = "Https"
    }
  }
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion" {
  name                = "acme-prod-hub-bastion-pip-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = local.common_tags
}

# Azure Bastion
resource "azurerm_bastion_host" "hub" {
  name                = "acme-prod-hub-bastion-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  
  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
  
  tags = local.common_tags
}

# VPN Gateway (optional - for site-to-site or point-to-site VPN)
resource "azurerm_public_ip" "vpn_gateway" {
  count               = var.enable_vpn_gateway ? 1 : 0
  name                = "acme-prod-hub-vpngw-pip-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = local.common_tags
}

resource "azurerm_virtual_network_gateway" "vpn" {
  count               = var.enable_vpn_gateway ? 1 : 0
  name                = "acme-prod-hub-vpngw-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  
  type     = "Vpn"
  vpn_type = "RouteBased"
  
  active_active = false
  enable_bgp    = true
  sku           = var.vpn_gateway_sku
  
  ip_configuration {
    name                          = "vpn-gateway-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }
  
  tags = local.common_tags
}

# Route Table for spoke networks
resource "azurerm_route_table" "hub" {
  name                          = "acme-prod-hub-rt-${var.location}-001"
  resource_group_name           = azurerm_resource_group.hub.name
  location                      = azurerm_resource_group.hub.location
  disable_bgp_route_propagation = false
  
  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }
  
  tags = local.common_tags
}

# Private DNS Zones for Azure services
resource "azurerm_resource_group" "dns" {
  name     = "acme-prod-hub-dns-rg-${var.location}-001"
  location = var.location
  
  tags = merge(local.common_tags, {
    Purpose = "Private DNS"
  })
}

resource "azurerm_private_dns_zone" "services" {
  for_each = toset([
    "privatelink.database.windows.net",      # SQL Database
    "privatelink.blob.core.windows.net",     # Blob Storage
    "privatelink.file.core.windows.net",     # File Storage
    "privatelink.vaultcore.azure.net",       # Key Vault
    "privatelink.azurecr.io",                # Container Registry
    "privatelink.azurewebsites.net",         # App Service
    "privatelink.redis.cache.windows.net",   # Redis Cache
    "privatelink.postgres.database.azure.com",  # PostgreSQL
    "privatelink.mysql.database.azure.com"   # MySQL
  ])
  
  name                = each.value
  resource_group_name = azurerm_resource_group.dns.name
  
  tags = local.common_tags
}

# Link hub VNet to private DNS zones
resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each = azurerm_private_dns_zone.services
  
  name                  = "hub-vnet-link"
  resource_group_name   = azurerm_resource_group.dns.name
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.hub.id
  
  tags = local.common_tags
}

# Network Watcher
resource "azurerm_resource_group" "network_watcher" {
  name     = "NetworkWatcherRG"  # Standard name
  location = var.location
  
  tags = local.common_tags
}

resource "azurerm_network_watcher" "hub" {
  name                = "acme-prod-hub-nw-${var.location}-001"
  resource_group_name = azurerm_resource_group.network_watcher.name
  location            = azurerm_resource_group.network_watcher.location
  
  tags = local.common_tags
}

# Network Security Group for Management Subnet
resource "azurerm_network_security_group" "management" {
  name                = "acme-prod-hub-mgmt-nsg-${var.location}-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  
  security_rule {
    name                       = "allow-bastion-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = azurerm_subnet.bastion.address_prefixes[0]
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "allow-bastion-ssh"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = azurerm_subnet.bastion.address_prefixes[0]
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = local.common_tags
}

# Associate NSG with Management Subnet
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

# Local variables
locals {
  common_tags = {
    Environment   = "production"
    Project       = "hub"
    ManagedBy     = "Terraform"
    CostCenter    = var.cost_center
    Owner         = "Platform Team"
    CreatedDate   = "2025-12-19"
  }
}
