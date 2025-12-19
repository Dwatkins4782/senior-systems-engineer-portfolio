# Terraform Outputs
# Export important resource information

# Networking Outputs
output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.networking.vnet_id
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.networking.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value       = module.networking.subnet_ids
}

output "nsg_ids" {
  description = "Map of Network Security Group IDs"
  value       = module.networking.nsg_ids
}

# AKS Outputs
output "aks_cluster_id" {
  description = "AKS Cluster ID"
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "AKS Cluster name"
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "AKS Cluster FQDN"
  value       = module.aks.cluster_fqdn
}

output "aks_node_resource_group" {
  description = "AKS Node Resource Group"
  value       = module.aks.node_resource_group
}

output "aks_kubelet_identity" {
  description = "AKS Kubelet Managed Identity"
  value       = module.aks.kubelet_identity_object_id
  sensitive   = true
}

output "aks_get_credentials_command" {
  description = "Command to get AKS credentials"
  value       = "az aks get-credentials --resource-group ${module.aks.resource_group_name} --name ${module.aks.cluster_name}"
}

# Key Vault Outputs
output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.main.id
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.main.vault_uri
}

# Container Registry Outputs
output "acr_id" {
  description = "Container Registry ID"
  value       = azurerm_container_registry.main.id
}

output "acr_name" {
  description = "Container Registry name"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "Container Registry login server"
  value       = azurerm_container_registry.main.login_server
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Log Analytics Workspace name"
  value       = azurerm_log_analytics_workspace.main.name
}

output "application_insights_id" {
  description = "Application Insights ID"
  value       = azurerm_application_insights.main.id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "Application Insights Connection String"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

# Storage Outputs
output "storage_account_id" {
  description = "Storage Account ID"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.main.name
}

output "storage_primary_blob_endpoint" {
  description = "Storage Account primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

# Summary Output
output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    environment        = var.environment
    location           = var.location
    vnet_name          = module.networking.vnet_name
    aks_cluster_name   = module.aks.cluster_name
    key_vault_name     = azurerm_key_vault.main.name
    acr_login_server   = azurerm_container_registry.main.login_server
    storage_account    = azurerm_storage_account.main.name
  }
}
