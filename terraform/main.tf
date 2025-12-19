# Main Terraform Configuration
# Orchestrates all infrastructure modules

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Backend configuration for remote state
  # Uncomment and configure after creating storage account
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "tfstate<unique>"
  #   container_name       = "tfstate"
  #   key                  = "portfolio.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }
  
  skip_provider_registration = false
}

provider "azuread" {}

# Data Sources
data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

# Locals for naming and tagging
locals {
  # Naming
  prefix = "${var.project_name}-${var.environment}"
  
  # Common tags applied to all resources
  common_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Repository  = "senior-systems-engineer-portfolio"
      Owner       = var.owner
      Timestamp   = timestamp()
    }
  )
  
  # Network configuration
  vnet_address_space = var.vnet_address_space
  
  subnets = {
    aks = {
      address_prefix    = var.aks_subnet_prefix
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ContainerRegistry"]
    }
    application = {
      address_prefix    = var.app_subnet_prefix
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
    }
    database = {
      address_prefix    = var.db_subnet_prefix
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
    management = {
      address_prefix    = var.mgmt_subnet_prefix
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }
}

# Networking Module
module "networking" {
  source = "./modules/networking"
  
  prefix              = local.prefix
  location            = var.location
  vnet_address_space  = local.vnet_address_space
  subnets             = local.subnets
  common_tags         = local.common_tags
  
  enable_ddos_protection = var.enable_ddos_protection
}

# AKS Module
module "aks" {
  source = "./modules/aks"
  
  prefix              = local.prefix
  location            = var.location
  environment         = var.environment
  kubernetes_version  = var.kubernetes_version
  subnet_id           = module.networking.subnet_ids["aks"]
  vnet_id             = module.networking.vnet_id
  
  # Node pool configuration
  system_node_count   = var.aks_default_node_count
  system_node_size    = var.aks_default_vm_size
  enable_auto_scaling = true
  system_min_count    = var.aks_min_nodes
  system_max_count    = var.aks_max_nodes
  
  # Networking
  dns_service_ip = "10.1.0.10"
  service_cidr   = "10.1.0.0/16"
  
  # Security
  local_account_disabled  = var.enable_azure_ad_rbac
  enable_azure_policy     = var.enable_azure_policy
  enable_private_cluster  = var.enable_private_cluster
  
  # Monitoring
  log_retention_days = var.log_retention_days
  
  common_tags = local.common_tags
  
  depends_on = [module.networking]
}

# Key Vault for secrets management
resource "azurerm_resource_group" "keyvault" {
  name     = "${local.prefix}-keyvault-rg"
  location = var.location
  tags     = local.common_tags
}

resource "random_integer" "kv_suffix" {
  min = 1000
  max = 9999
}

resource "azurerm_key_vault" "main" {
  name                        = "${var.project_name}-kv-${random_integer.kv_suffix.result}"
  location                    = azurerm_resource_group.keyvault.location
  resource_group_name         = azurerm_resource_group.keyvault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.environment == "prod" ? true : false
  sku_name                    = "standard"
  
  enable_rbac_authorization = true
  
  network_acls {
    bypass         = "AzureServices"
    default_action = var.environment == "prod" ? "Deny" : "Allow"
    
    # Allow AKS subnet
    virtual_network_subnet_ids = [
      module.networking.subnet_ids["aks"],
      module.networking.subnet_ids["application"]
    ]
  }
  
  tags = local.common_tags
  
  depends_on = [module.networking]
}

# Grant current user access to Key Vault
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant AKS managed identity access to Key Vault
resource "azurerm_role_assignment" "aks_kv_secrets" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.aks.kubelet_identity_object_id
  
  depends_on = [module.aks]
}

# Azure Container Registry
resource "azurerm_resource_group" "acr" {
  name     = "${local.prefix}-acr-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_container_registry" "main" {
  name                = "${var.project_name}${var.environment}acr${random_integer.kv_suffix.result}"
  resource_group_name = azurerm_resource_group.acr.name
  location            = azurerm_resource_group.acr.location
  sku                 = var.acr_sku
  admin_enabled       = false
  
  # Enable geo-replication for production
  dynamic "georeplications" {
    for_each = var.environment == "prod" ? var.acr_georeplications : []
    content {
      location                = georeplications.value
      zone_redundancy_enabled = true
      tags                    = local.common_tags
    }
  }
  
  # Network rules
  network_rule_set {
    default_action = var.environment == "prod" ? "Deny" : "Allow"
    
    virtual_network {
      action    = "Allow"
      subnet_id = module.networking.subnet_ids["aks"]
    }
  }
  
  tags = local.common_tags
  
  depends_on = [module.networking]
}

# Grant AKS pull access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_identity_object_id
  
  depends_on = [module.aks, azurerm_container_registry.main]
}

# Log Analytics Workspace for centralized logging
resource "azurerm_resource_group" "monitoring" {
  name     = "${local.prefix}-monitoring-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.prefix}-logs"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  
  tags = local.common_tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "${local.prefix}-appinsights"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
  
  tags = local.common_tags
}

# Storage Account for backups and file shares
resource "azurerm_resource_group" "storage" {
  name     = "${local.prefix}-storage-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${var.environment}st${random_integer.kv_suffix.result}"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "prod" ? "GRS" : "LRS"
  
  # Security
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  
  # Network rules
  network_rules {
    default_action             = var.environment == "prod" ? "Deny" : "Allow"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [
      module.networking.subnet_ids["aks"],
      module.networking.subnet_ids["application"]
    ]
  }
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 30
    }
    
    container_delete_retention_policy {
      days = 30
    }
  }
  
  tags = local.common_tags
  
  depends_on = [module.networking]
}
