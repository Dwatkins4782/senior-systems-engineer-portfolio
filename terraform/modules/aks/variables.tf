# AKS Module Variables

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID"
  type        = string
}

variable "system_node_count" {
  description = "System node pool count"
  type        = number
  default     = 2
}

variable "system_node_size" {
  description = "System node VM size"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "enable_auto_scaling" {
  description = "Enable autoscaling"
  type        = bool
  default     = true
}

variable "system_min_count" {
  description = "Minimum nodes for autoscaling"
  type        = number
  default     = 1
}

variable "system_max_count" {
  description = "Maximum nodes for autoscaling"
  type        = number
  default     = 10
}

variable "admin_group_object_ids" {
  description = "Azure AD admin group object IDs"
  type        = list(string)
  default     = []
}

variable "dns_service_ip" {
  description = "DNS service IP for Kubernetes"
  type        = string
  default     = "10.1.0.10"
}

variable "service_cidr" {
  description = "Service CIDR for Kubernetes"
  type        = string
  default     = "10.1.0.0/16"
}

variable "local_account_disabled" {
  description = "Disable local accounts"
  type        = bool
  default     = true
}

variable "enable_azure_policy" {
  description = "Enable Azure Policy"
  type        = bool
  default     = true
}

variable "enable_private_cluster" {
  description = "Enable private cluster"
  type        = bool
  default     = false
}

variable "acr_id" {
  description = "Azure Container Registry ID (optional)"
  type        = string
  default     = null
}

variable "user_node_size" {
  description = "User node pool VM size"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "user_node_count" {
  description = "User node pool count"
  type        = number
  default     = 2
}

variable "user_min_count" {
  description = "User node pool min count"
  type        = number
  default     = 1
}

variable "user_max_count" {
  description = "User node pool max count"
  type        = number
  default     = 5
}

variable "log_retention_days" {
  description = "Log retention days"
  type        = number
  default     = 30
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
