# Terraform Variables
# Define all input parameters for infrastructure deployment

# General Configuration
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "portfolio"
  
  validation {
    condition     = length(var.project_name) <= 10 && can(regex("^[a-z0-9]+$", var.project_name))
    error_message = "Project name must be lowercase alphanumeric and max 10 characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "Infrastructure Team"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Networking Configuration
variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "Subnet prefix for AKS"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_prefix" {
  description = "Subnet prefix for applications"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_prefix" {
  description = "Subnet prefix for databases"
  type        = string
  default     = "10.0.3.0/24"
}

variable "mgmt_subnet_prefix" {
  description = "Subnet prefix for management"
  type        = string
  default     = "10.0.4.0/24"
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection plan (expensive)"
  type        = bool
  default     = false
}

variable "enable_network_watcher" {
  description = "Enable Network Watcher"
  type        = bool
  default     = true
}

# AKS Configuration
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "aks_default_node_count" {
  description = "Default number of nodes in system pool"
  type        = number
  default     = 2
  
  validation {
    condition     = var.aks_default_node_count >= 1 && var.aks_default_node_count <= 100
    error_message = "Node count must be between 1 and 100."
  }
}

variable "aks_min_nodes" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "aks_max_nodes" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 10
}

variable "aks_default_vm_size" {
  description = "VM size for default node pool"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_user_vm_size" {
  description = "VM size for user node pool"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "aks_availability_zones" {
  description = "Availability zones for AKS nodes"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "enable_user_node_pool" {
  description = "Enable additional user node pool"
  type        = bool
  default     = false
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy for AKS"
  type        = bool
  default     = true
}

variable "enable_azure_ad_rbac" {
  description = "Enable Azure AD RBAC for AKS"
  type        = bool
  default     = true
}

variable "enable_private_cluster" {
  description = "Enable private cluster (API server not public)"
  type        = bool
  default     = false
}

# Container Registry Configuration
variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "acr_georeplications" {
  description = "Regions for ACR geo-replication (Premium SKU only)"
  type        = list(string)
  default     = ["westus2", "northeurope"]
}

# Monitoring Configuration
variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
  
  validation {
    condition     = var.log_retention_days >= 7 && var.log_retention_days <= 730
    error_message = "Log retention must be between 7 and 730 days."
  }
}
