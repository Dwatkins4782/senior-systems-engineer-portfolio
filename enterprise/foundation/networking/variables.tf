# Variables for Enterprise Foundation Hub Network

variable "location" {
  description = "Azure region for hub network"
  type        = string
  default     = "eastus"
  
  validation {
    condition     = contains(["eastus", "eastus2", "westus2", "centralus", "northeurope", "westeurope"], var.location)
    error_message = "Location must be a supported Azure region."
  }
}

variable "cost_center" {
  description = "Cost center for billing allocation"
  type        = string
  default     = "CC-PLATFORM"
}

# Hub Network CIDR
variable "hub_vnet_address_space" {
  description = "Address space for hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

# Subnet CIDRs
variable "gateway_subnet_prefix" {
  description = "Address prefix for Gateway subnet (VPN/ExpressRoute)"
  type        = string
  default     = "10.0.0.0/26"  # 64 addresses
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for Azure Firewall subnet"
  type        = string
  default     = "10.0.1.0/26"  # 64 addresses
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for Azure Bastion subnet"
  type        = string
  default     = "10.0.2.0/26"  # 64 addresses
}

variable "shared_services_subnet_prefix" {
  description = "Address prefix for shared services (DNS, AD, monitoring)"
  type        = string
  default     = "10.0.10.0/24"  # 256 addresses
}

variable "management_subnet_prefix" {
  description = "Address prefix for management subnet (jump boxes)"
  type        = string
  default     = "10.0.11.0/24"  # 256 addresses
}

# Feature Flags
variable "enable_ddos_protection" {
  description = "Enable DDoS Protection Standard (costly - ~$3k/month)"
  type        = bool
  default     = false  # Set to true for production
}

variable "enable_vpn_gateway" {
  description = "Deploy VPN Gateway for site-to-site or point-to-site connectivity"
  type        = bool
  default     = true
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Firewall SKU tier must be Standard or Premium."
  }
}

variable "vpn_gateway_sku" {
  description = "VPN Gateway SKU"
  type        = string
  default     = "VpnGw2"
  
  validation {
    condition     = contains(["VpnGw1", "VpnGw2", "VpnGw3", "VpnGw4", "VpnGw5"], var.vpn_gateway_sku)
    error_message = "VPN Gateway SKU must be VpnGw1-5."
  }
}

# VPN Configuration (for site-to-site)
variable "on_premises_networks" {
  description = "On-premises network address spaces for VPN connectivity"
  type        = list(string)
  default     = []
  # Example: ["192.168.0.0/16", "172.16.0.0/12"]
}

variable "vpn_shared_key" {
  description = "Shared key for site-to-site VPN (store in Key Vault)"
  type        = string
  sensitive   = true
  default     = ""
}
