variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the spoke VNet"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string), [])
    delegation = optional(object({
      name         = string
      service_name = string
    }))
  }))
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub VNet to peer with"
  type        = string
  default     = null
}

variable "hub_firewall_private_ip" {
  description = "Private IP of hub firewall for routing"
  type        = string
  default     = null
}

variable "enable_forced_tunneling" {
  description = "Enable forced tunneling through hub firewall"
  type        = bool
  default     = true
}

variable "use_remote_gateway" {
  description = "Use remote gateway from hub for VPN connectivity"
  type        = bool
  default     = true
}

variable "exclude_route_table_subnets" {
  description = "Subnets to exclude from route table association (e.g., AKS)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
