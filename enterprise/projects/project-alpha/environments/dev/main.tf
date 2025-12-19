# Project Alpha - Development Environment

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "acme-dev-alpha-rg-eastus-001"
    storage_account_name = "acmedevalphatfstate"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data source for hub network
data "azurerm_virtual_network" "hub" {
  name                = "acme-prod-hub-vnet-eastus-001"
  resource_group_name = "acme-prod-hub-network-rg-eastus-001"
}

data "azurerm_firewall" "hub" {
  name                = "acme-prod-hub-afw-eastus-001"
  resource_group_name = "acme-prod-hub-network-rg-eastus-001"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "acme-dev-alpha-rg-${var.location}-001"
  location = var.location
  
  tags = local.common_tags
}

# Project Spoke Network
module "network" {
  source = "../../modules/networking"
  
  project_name = "alpha"
  environment  = "dev"
  location     = var.location
  
  vnet_address_space = "10.100.0.0/20"
  
  subnets = {
    aks = {
      address_prefix = "10.100.0.0/22"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
    }
    app = {
      address_prefix = "10.100.4.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
    data = {
      address_prefix = "10.100.5.0/24"
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
    mgmt = {
      address_prefix = "10.100.6.0/27"
      service_endpoints = ["Microsoft.KeyVault"]
    }
  }
  
  # Peer to hub
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  hub_firewall_private_ip   = data.azurerm_firewall.hub.ip_configuration[0].private_ip_address
  enable_forced_tunneling   = true
  
  tags = local.common_tags
}

# AKS Cluster
module "aks" {
  source = "../../modules/aks"
  
  prefix      = "acme"
  environment = "dev"
  project     = "alpha"
  location    = var.location
  
  # Network
  vnet_id   = module.network.vnet_id
  subnet_id = module.network.subnet_ids["aks"]
  
  # Kubernetes version
  kubernetes_version = var.kubernetes_version
  
  # System node pool
  system_node_count = 3
  system_node_size  = "Standard_D4s_v3"
  
  # User node pool (optional)
  enable_user_node_pool = true
  user_node_count       = 2
  user_node_size        = "Standard_D4s_v3"
  
  # Scaling
  enable_auto_scaling = true
  system_min_count    = 3
  system_max_count    = 6
  user_min_count      = 2
  user_max_count      = 10
  
  # Security
  enable_azure_policy     = true
  enable_private_cluster  = false  # Set true for production
  local_account_disabled  = false  # Set true after AAD setup
  
  # Azure AD Integration
  admin_group_object_ids = var.aks_admin_group_ids
  
  # Network settings
  service_cidr    = "172.16.0.0/16"
  dns_service_ip  = "172.16.0.10"
  
  # Monitoring
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  
  # Container Registry
  acr_id = azurerm_container_registry.main.id
  
  tags = local.common_tags
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                       = "acme-dev-alpha-kv-eus-001"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  
  enable_rbac_authorization  = true
  purge_protection_enabled   = false  # Can be true in production
  soft_delete_retention_days = 7      # 90 in production
  
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [
      module.network.subnet_ids["aks"],
      module.network.subnet_ids["app"]
    ]
  }
  
  tags = local.common_tags
}

# Grant AKS access to Key Vault
resource "azurerm_role_assignment" "aks_kv_secrets" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.kubelet_identity_object_id
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = "acmedevalphaacr001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Standard"  # Premium in production
  admin_enabled       = false
  
  network_rule_set {
    default_action = "Deny"
    
    virtual_network {
      action    = "Allow"
      subnet_id = module.network.subnet_ids["aks"]
    }
  }
  
  tags = local.common_tags
}

# Grant AKS pull access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "acme-dev-alpha-logs-${var.location}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30  # 90+ in production
  
  tags = local.common_tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "acme-dev-alpha-appinsights-${var.location}-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  
  tags = local.common_tags
}

# Storage Account (for application data)
resource "azurerm_storage_account" "main" {
  name                     = "acmedevalphasteustus001"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # GRS in production
  
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  
  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [
      module.network.subnet_ids["aks"],
      module.network.subnet_ids["app"]
    ]
  }
  
  tags = local.common_tags
}

# Current Azure context
data "azurerm_client_config" "current" {}

# Locals
locals {
  common_tags = {
    Environment    = "development"
    Project        = "alpha"
    ManagedBy      = "Terraform"
    CostCenter     = var.cost_center
    BusinessOwner  = var.business_owner
    TechnicalLead  = var.technical_lead
    CreatedDate    = "2025-12-19"
  }
}
