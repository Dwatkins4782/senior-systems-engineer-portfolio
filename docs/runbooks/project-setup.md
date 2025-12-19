# Senior Systems Engineer Portfolio - Project Setup Runbook

**Document Version:** 1.0  
**Last Updated:** December 19, 2025  
**Owner:** Portfolio Project  
**Status:** Active

---

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Initial Setup](#initial-setup)
- [Component Details](#component-details)
- [Usage Instructions](#usage-instructions)
- [Troubleshooting](#troubleshooting)
- [Maintenance](#maintenance)

---

## Overview

### Purpose
This portfolio demonstrates enterprise-level systems engineering capabilities including:
- Infrastructure as Code (Terraform)
- Configuration Management (Ansible)
- Azure Cloud Infrastructure (AKS, Networking)
- Security Automation (PowerShell scripts)
- Incident Response procedures
- Interview preparation materials

### Architecture Overview
```
Portfolio Project
├── Infrastructure Layer (Terraform)
│   └── Manages Azure resources (AKS, VNets, etc.)
├── Configuration Layer (Ansible)
│   └── System hardening and configuration
├── Automation Layer (PowerShell)
│   └── Security operations and secret rotation
└── Documentation Layer
    └── Runbooks and guides
```

---

## Prerequisites

### Required Tools

#### 1. Terraform
**Version:** >= 1.0.0  
**Installation:**
```powershell
# Using Chocolatey
choco install terraform

# Verify installation
terraform version
```

#### 2. Ansible
**Version:** >= 2.9  
**Installation:**
```powershell
# Install WSL2 first (Ansible requires Linux)
wsl --install

# Inside WSL, install Ansible
sudo apt update
sudo apt install ansible -y

# Verify installation
ansible --version
```

#### 3. Azure CLI
**Version:** >= 2.40.0  
**Installation:**
```powershell
# Download and run installer
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Verify installation
az --version

# Login to Azure
az login
```

#### 4. PowerShell
**Version:** >= 7.x  
**Installation:**
```powershell
# Using winget
winget install --id Microsoft.Powershell --source winget

# Verify installation
$PSVersionTable.PSVersion
```

#### 5. Git
**Installation:**
```powershell
# Using Chocolatey
choco install git

# Verify installation
git --version
```

#### 6. kubectl (for AKS management)
**Installation:**
```powershell
# Using Azure CLI
az aks install-cli

# Verify installation
kubectl version --client
```

### Required Azure Resources

#### Azure Subscription
- Active Azure subscription with Contributor or Owner role
- Subscription ID noted for later use

#### Service Principal (for Terraform)
```powershell
# Create service principal
az ad sp create-for-rbac --name "terraform-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Save the output (you'll need these values):
# - appId (client_id)
# - password (client_secret)
# - tenant (tenant_id)
```

#### Azure Key Vault (for secrets)
```powershell
# Create resource group
az group create --name "portfolio-rg" --location "eastus"

# Create Key Vault
az keyvault create --name "portfolio-kv-unique" --resource-group "portfolio-rg" --location "eastus"
```

---

## Project Structure

### Complete Directory Tree
```
senior-systems-engineer-portfolio/
│
├── README.md                          # Project overview and documentation
├── INTERVIEW-PREPARATION.md           # Interview prep guide
│
├── ansible/                           # Configuration management
│   └── playbooks/
│       ├── linux-hardening.yml        # Linux security hardening playbook
│       └── site.yml                   # Main playbook orchestrator
│
├── docs/                              # Documentation
│   └── runbooks/
│       ├── incident-response.md       # Incident response procedures
│       └── project-setup.md           # This file
│
├── scripts/                           # Automation scripts
│   └── powershell/
│       └── Rotate-Secrets.ps1         # Azure Key Vault secret rotation
│
└── terraform/                         # Infrastructure as Code
    └── modules/
        ├── aks/                       # Azure Kubernetes Service
        │   └── main.tf
        └── networking/                # Azure networking resources
            ├── main.tf                # Network infrastructure
            ├── outputs.tf             # Export values for other modules
            └── variables.tf           # Input parameters
```

---

## Initial Setup

### Step 1: Clone the Repository
```powershell
# Navigate to your projects directory
cd C:\Projects

# Clone the repository
git clone https://github.com/yourusername/senior-systems-engineer-portfolio.git
cd senior-systems-engineer-portfolio
```

### Step 2: Configure Azure Authentication

#### Option A: Using Azure CLI (Recommended for local testing)
```powershell
# Login to Azure
az login

# Set default subscription
az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Verify current subscription
az account show
```

#### Option B: Using Service Principal (Recommended for CI/CD)
```powershell
# Set environment variables
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"
```

### Step 3: Initialize Terraform Backend

#### Create Backend Storage Account
```powershell
# Variables
$RESOURCE_GROUP_NAME = "terraform-state-rg"
$STORAGE_ACCOUNT_NAME = "tfstateunique$(Get-Random -Maximum 9999)"
$CONTAINER_NAME = "tfstate"
$LOCATION = "eastus"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create `
    --resource-group $RESOURCE_GROUP_NAME `
    --name $STORAGE_ACCOUNT_NAME `
    --sku Standard_LRS `
    --encryption-services blob

# Create blob container
az storage container create `
    --name $CONTAINER_NAME `
    --account-name $STORAGE_ACCOUNT_NAME

Write-Host "Backend Storage Account: $STORAGE_ACCOUNT_NAME"
```

#### Create Backend Configuration File
```powershell
# Create backend.tf in terraform directory
@"
terraform {
  backend "azurerm" {
    resource_group_name  = "$RESOURCE_GROUP_NAME"
    storage_account_name = "$STORAGE_ACCOUNT_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "portfolio.terraform.tfstate"
  }
}
"@ | Out-File -FilePath .\terraform\backend.tf -Encoding UTF8
```

### Step 4: Initialize Terraform
```powershell
# Navigate to Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Expected output: "Terraform has been successfully initialized!"
```

### Step 5: Configure Ansible Inventory

#### Create Inventory File
```powershell
# Create inventory file
@"
[web_servers]
web01 ansible_host=10.0.1.10
web02 ansible_host=10.0.1.11

[db_servers]
db01 ansible_host=10.0.2.10

[all:vars]
ansible_user=azureuser
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
"@ | Out-File -FilePath ..\ansible\inventory.ini -Encoding UTF8
```

### Step 6: Create SSH Key for Ansible
```powershell
# Generate SSH key (if not exists)
if (-not (Test-Path "$env:USERPROFILE\.ssh\id_rsa")) {
    ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N '""'
}

# Display public key (to add to Azure VMs)
Get-Content "$env:USERPROFILE\.ssh\id_rsa.pub"
```

---

## Component Details

### Terraform Modules

#### 1. Networking Module (`terraform/modules/networking/`)

**Purpose:** Creates foundational Azure network infrastructure

**Files:**
- **main.tf** - Defines network resources
- **variables.tf** - Input parameters
- **outputs.tf** - Exported values

**Resources Created:**
```hcl
- Virtual Network (VNet)
- Subnets (AKS, Database, Application)
- Network Security Groups (NSGs)
- Route Tables
- Public IP addresses
```

**Key Variables:**
```hcl
variable "vnet_address_space" {
  description = "Address space for VNet"
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefixes" {
  description = "Subnet CIDR blocks"
  default = {
    aks    = "10.0.1.0/24"
    app    = "10.0.2.0/24"
    db     = "10.0.3.0/24"
  }
}
```

**Outputs:**
```hcl
output "vnet_id" - Virtual Network ID
output "subnet_ids" - Map of subnet IDs
output "nsg_ids" - Network Security Group IDs
```

#### 2. AKS Module (`terraform/modules/aks/`)

**Purpose:** Deploys Azure Kubernetes Service cluster

**Files:**
- **main.tf** - AKS cluster configuration

**Resources Created:**
```hcl
- AKS Cluster
- Node Pools (system and user)
- Managed Identity
- Log Analytics Workspace
- Azure Monitor integration
```

**Key Configurations:**
```hcl
- Kubernetes version: Latest stable
- Network plugin: Azure CNI
- Network policy: Calico
- RBAC: Enabled
- Azure AD integration: Enabled
- Autoscaling: Enabled (1-10 nodes)
```

### Ansible Playbooks

#### 1. Linux Hardening Playbook (`ansible/playbooks/linux-hardening.yml`)

**Purpose:** Applies CIS security benchmarks to Linux servers

**Tasks Performed:**
1. **System Updates**
   - Updates all packages to latest versions
   - Configures automatic security updates

2. **SSH Hardening**
   - Disables root login
   - Disables password authentication
   - Changes default SSH port (optional)
   - Implements key-based authentication only

3. **Firewall Configuration**
   - Installs and enables firewalld/ufw
   - Configures default deny policies
   - Opens only required ports

4. **Audit Logging**
   - Installs auditd
   - Configures audit rules for file access
   - Sets up log rotation

5. **File System Security**
   - Sets proper permissions on sensitive files
   - Configures /tmp with noexec
   - Implements umask restrictions

6. **User Account Security**
   - Enforces password complexity
   - Implements password aging
   - Locks inactive accounts

**Usage:**
```bash
# Test playbook (dry-run)
ansible-playbook -i ../inventory.ini linux-hardening.yml --check

# Execute playbook
ansible-playbook -i ../inventory.ini linux-hardening.yml

# Execute with verbose output
ansible-playbook -i ../inventory.ini linux-hardening.yml -vvv
```

#### 2. Site Playbook (`ansible/playbooks/site.yml`)

**Purpose:** Main orchestration playbook that calls all other playbooks

**Structure:**
```yaml
- name: Configure all servers
  hosts: all
  roles:
    - common
    - security

- name: Configure web servers
  hosts: web_servers
  roles:
    - nginx
    - app_deployment

- name: Configure database servers
  hosts: db_servers
  roles:
    - postgresql
    - backup
```

### PowerShell Scripts

#### 1. Rotate-Secrets.ps1 (`scripts/powershell/Rotate-Secrets.ps1`)

**Purpose:** Automated rotation of secrets in Azure Key Vault

**Features:**
- Connects to Azure Key Vault
- Generates new secure passwords
- Updates secrets with new values
- Maintains secret version history
- Sends notifications on completion
- Logs all rotation activities

**Parameters:**
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$KeyVaultName,
    
    [Parameter(Mandatory=$true)]
    [string[]]$SecretNames,
    
    [Parameter(Mandatory=$false)]
    [int]$PasswordLength = 32
)
```

**Usage:**
```powershell
# Rotate single secret
.\Rotate-Secrets.ps1 -KeyVaultName "my-keyvault" -SecretNames "database-password"

# Rotate multiple secrets
.\Rotate-Secrets.ps1 -KeyVaultName "my-keyvault" -SecretNames @("db-password", "api-key", "admin-password")

# Custom password length
.\Rotate-Secrets.ps1 -KeyVaultName "my-keyvault" -SecretNames "db-password" -PasswordLength 64
```

**Scheduled Rotation:**
```powershell
# Create scheduled task for automatic rotation (90 days)
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File C:\path\to\Rotate-Secrets.ps1 -KeyVaultName 'my-kv' -SecretNames 'db-password'"
$Trigger = New-ScheduledTaskTrigger -Daily -At 2am -DaysInterval 90
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest

Register-ScheduledTask -TaskName "RotateKeyVaultSecrets" -Action $Action -Trigger $Trigger -Principal $Principal
```

### Documentation

#### 1. Incident Response Runbook (`docs/runbooks/incident-response.md`)

**Purpose:** Step-by-step procedures for handling production incidents

**Sections:**
- Incident severity classification
- Escalation procedures
- Communication templates
- Troubleshooting workflows
- Post-mortem template

#### 2. Interview Preparation Guide (`INTERVIEW-PREPARATION.md`)

**Purpose:** Comprehensive guide for senior systems engineer interviews

**Coverage:**
- Technical knowledge areas
- System design scenarios
- Behavioral questions with STAR method
- Common troubleshooting scenarios
- Leadership and communication tips

---

## Usage Instructions

### Deploying Infrastructure with Terraform

#### Step 1: Create tfvars File
```powershell
# Navigate to terraform directory
cd terraform

# Create terraform.tfvars
@"
# Resource naming
environment = "dev"
project_name = "portfolio"
location = "eastus"

# Networking
vnet_address_space = ["10.0.0.0/16"]

# AKS Configuration
kubernetes_version = "1.28"
aks_node_count = 2
aks_vm_size = "Standard_D2s_v3"

# Tags
tags = {
  Environment = "Development"
  Project     = "Portfolio"
  ManagedBy   = "Terraform"
  Owner       = "YourName"
}
"@ | Out-File -FilePath .\terraform.tfvars -Encoding UTF8
```

#### Step 2: Plan Infrastructure
```powershell
# Preview changes
terraform plan -out=tfplan

# Review the plan carefully
# Look for:
# - Number of resources to be created
# - Any unexpected deletions or changes
# - Cost implications
```

#### Step 3: Apply Infrastructure
```powershell
# Apply the plan
terraform apply tfplan

# Or apply directly (will prompt for confirmation)
terraform apply

# Expected duration: 10-15 minutes for AKS cluster
```

#### Step 4: Verify Deployment
```powershell
# Show all resources
terraform show

# Get specific outputs
terraform output

# Verify in Azure Portal
az resource list --resource-group "portfolio-dev-rg" --output table
```

### Configuring Servers with Ansible

#### Step 1: Test Connectivity
```bash
# In WSL/Linux environment
cd ansible

# Ping all hosts
ansible all -i inventory.ini -m ping

# Expected output: SUCCESS for all hosts
```

#### Step 2: Run Playbooks
```bash
# Execute site playbook (all configurations)
ansible-playbook -i inventory.ini playbooks/site.yml

# Execute specific playbook
ansible-playbook -i inventory.ini playbooks/linux-hardening.yml

# Limit to specific hosts
ansible-playbook -i inventory.ini playbooks/linux-hardening.yml --limit web01

# Use tags for partial execution
ansible-playbook -i inventory.ini playbooks/linux-hardening.yml --tags "ssh,firewall"
```

#### Step 3: Verify Configuration
```bash
# Check specific configuration
ansible all -i inventory.ini -m shell -a "systemctl status sshd"

# Gather facts
ansible all -i inventory.ini -m setup
```

### Running PowerShell Scripts

#### Manual Execution
```powershell
# Navigate to scripts directory
cd scripts\powershell

# Execute with ExecutionPolicy bypass if needed
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Run secret rotation
.\Rotate-Secrets.ps1 -KeyVaultName "portfolio-kv" -SecretNames "database-password"
```

#### Scheduled Execution
```powershell
# View scheduled tasks
Get-ScheduledTask | Where-Object {$_.TaskName -like "*Secret*"}

# Run scheduled task manually
Start-ScheduledTask -TaskName "RotateKeyVaultSecrets"

# Check task history
Get-ScheduledTaskInfo -TaskName "RotateKeyVaultSecrets"
```

### Accessing AKS Cluster

#### Get Cluster Credentials
```powershell
# Get credentials
az aks get-credentials --resource-group "portfolio-dev-rg" --name "portfolio-dev-aks"

# Verify access
kubectl get nodes
kubectl get namespaces
```

#### Deploy Sample Application
```powershell
# Create namespace
kubectl create namespace demo

# Deploy nginx
kubectl create deployment nginx --image=nginx:latest -n demo
kubectl expose deployment nginx --port=80 --type=LoadBalancer -n demo

# Check status
kubectl get pods -n demo
kubectl get svc -n demo
```

---

## Troubleshooting

### Terraform Issues

#### Issue 1: "Error: backend initialization required"
**Symptoms:**
```
Error: Backend initialization required: please run "terraform init"
```

**Solution:**
```powershell
# Re-initialize backend
terraform init -reconfigure

# If state is corrupted, force recopy
terraform init -reconfigure -migrate-state
```

#### Issue 2: "Error: Provider configuration not present"
**Symptoms:**
```
Error: Provider configuration not present
```

**Solution:**
```powershell
# Verify Azure CLI login
az account show

# Re-login if needed
az login

# Or set environment variables for service principal
$env:ARM_CLIENT_ID = "your-client-id"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "your-subscription-id"
$env:ARM_TENANT_ID = "your-tenant-id"
```

#### Issue 3: State Lock Errors
**Symptoms:**
```
Error: Error acquiring the state lock
```

**Solution:**
```powershell
# List current leases
az storage blob lease list --container-name tfstate --account-name $STORAGE_ACCOUNT_NAME

# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>

# Or manually break lease
az storage blob lease break --blob-name portfolio.terraform.tfstate --container-name tfstate --account-name $STORAGE_ACCOUNT_NAME
```

#### Issue 4: Resource Quota Exceeded
**Symptoms:**
```
Error: Resource quota exceeded
```

**Solution:**
```powershell
# Check current quotas
az vm list-usage --location eastus --output table

# Request quota increase
# Go to Azure Portal → Subscriptions → Usage + quotas → Request increase

# Or use smaller VM sizes temporarily
# Edit terraform.tfvars
aks_vm_size = "Standard_B2s"
```

### Ansible Issues

#### Issue 1: SSH Connection Failed
**Symptoms:**
```
UNREACHABLE! => {"msg": "Failed to connect to the host via ssh"}
```

**Solution:**
```bash
# Test SSH manually
ssh -i ~/.ssh/id_rsa azureuser@<host-ip>

# Check SSH key permissions
chmod 600 ~/.ssh/id_rsa

# Verify host key in known_hosts
ssh-keyscan <host-ip> >> ~/.ssh/known_hosts

# Add to ansible.cfg
[defaults]
host_key_checking = False
```

#### Issue 2: Python Interpreter Not Found
**Symptoms:**
```
"msg": "/usr/bin/python: not found"
```

**Solution:**
```bash
# Update inventory with correct Python path
ansible_python_interpreter=/usr/bin/python3

# Or discover automatically
ansible all -i inventory.ini -m setup -a "filter=ansible_python_version"
```

#### Issue 3: Permission Denied (Sudo)
**Symptoms:**
```
"msg": "Missing sudo password"
```

**Solution:**
```bash
# Add --ask-become-pass flag
ansible-playbook -i inventory.ini playbooks/site.yml --ask-become-pass

# Or configure passwordless sudo on remote host
echo "azureuser ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/azureuser
```

#### Issue 4: Playbook Syntax Errors
**Symptoms:**
```
ERROR! Syntax Error while loading YAML
```

**Solution:**
```bash
# Validate playbook syntax
ansible-playbook playbooks/site.yml --syntax-check

# Use yamllint for detailed checking
yamllint playbooks/site.yml

# Common fixes:
# - Check indentation (use spaces, not tabs)
# - Ensure proper YAML formatting
# - Quote strings with special characters
```

### PowerShell Script Issues

#### Issue 1: Execution Policy Blocked
**Symptoms:**
```
File cannot be loaded because running scripts is disabled on this system
```

**Solution:**
```powershell
# Check current policy
Get-ExecutionPolicy

# Set for current process only
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process

# Or set for current user
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Issue 2: Azure Authentication Failed
**Symptoms:**
```
Connect-AzAccount : No subscription found in the context
```

**Solution:**
```powershell
# Re-authenticate
Connect-AzAccount

# Set specific subscription
Set-AzContext -SubscriptionId "your-subscription-id"

# Verify context
Get-AzContext
```

#### Issue 3: Key Vault Access Denied
**Symptoms:**
```
The user, group or application does not have secrets get permission
```

**Solution:**
```powershell
# Grant yourself permissions
az keyvault set-policy --name "portfolio-kv" `
    --upn "your-email@domain.com" `
    --secret-permissions get list set delete

# Or use access policies for service principal
az keyvault set-policy --name "portfolio-kv" `
    --spn $env:ARM_CLIENT_ID `
    --secret-permissions get list set delete
```

### AKS Cluster Issues

#### Issue 1: Cannot Connect to Cluster
**Symptoms:**
```
Unable to connect to the server: dial tcp: lookup ... no such host
```

**Solution:**
```powershell
# Re-fetch credentials
az aks get-credentials --resource-group "portfolio-dev-rg" --name "portfolio-dev-aks" --overwrite-existing

# Verify cluster is running
az aks show --resource-group "portfolio-dev-rg" --name "portfolio-dev-aks" --query "powerState"

# Check network connectivity
Test-NetConnection -ComputerName "<aks-fqdn>" -Port 443
```

#### Issue 2: Pods Not Starting
**Symptoms:**
```
kubectl get pods shows CrashLoopBackOff or ImagePullBackOff
```

**Solution:**
```powershell
# Describe pod for detailed error
kubectl describe pod <pod-name> -n <namespace>

# Check events
kubectl get events --sort-by='.lastTimestamp' -n <namespace>

# Check logs
kubectl logs <pod-name> -n <namespace>

# Common fixes:
# - ImagePullBackOff: Check image name and registry credentials
# - CrashLoopBackOff: Check application logs and environment variables
# - Pending: Check node resources and tolerations
```

#### Issue 3: Service Not Accessible
**Symptoms:**
```
Cannot access application via LoadBalancer IP
```

**Solution:**
```powershell
# Check service
kubectl get svc -n <namespace>
kubectl describe svc <service-name> -n <namespace>

# Verify endpoints exist
kubectl get endpoints <service-name> -n <namespace>

# Check NSG rules in Azure
az network nsg rule list --resource-group "MC_portfolio-dev-rg_portfolio-dev-aks_eastus" --nsg-name "aks-agentpool-*" --output table

# Test from within cluster
kubectl run test-pod --image=busybox -it --rm -- wget -O- http://<service-name>.<namespace>
```

### General Troubleshooting Tools

#### Diagnostic Commands
```powershell
# Azure Resource Health
az resource list --query "[?resourceGroup=='portfolio-dev-rg']" --output table

# Azure Activity Log (last 24 hours)
az monitor activity-log list --resource-group "portfolio-dev-rg" --offset 24h --query "[?level=='Error']"

# Check Azure service health
az rest --method get --uri "https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/availabilityStatuses?api-version=2020-05-01"

# Terraform state inspection
terraform show
terraform state list
terraform state show <resource>

# Ansible debug
ansible-playbook playbooks/site.yml -vvv
ansible-playbook playbooks/site.yml --check --diff

# PowerShell transcript for debugging
Start-Transcript -Path "C:\Logs\script-debug.log"
# ... run your script ...
Stop-Transcript
```

#### Log Locations
```
Terraform Logs:
- Crash logs: crash.log (current directory)
- Debug: Set TF_LOG=DEBUG environment variable

Ansible Logs:
- Default: stdout
- Configure in ansible.cfg: log_path = /var/log/ansible.log

PowerShell Logs:
- Event Viewer → Windows PowerShell
- Transcript files (if enabled)

AKS Logs:
- Container logs: kubectl logs
- Node logs: /var/log/syslog on nodes
- Azure Monitor: Log Analytics workspace
```

---

## Maintenance

### Regular Tasks

#### Daily
- [ ] Check Azure service health dashboard
- [ ] Review monitoring alerts
- [ ] Verify backup status

#### Weekly
- [ ] Review cost analysis in Azure
- [ ] Check for AKS cluster updates
- [ ] Review security advisories
- [ ] Test incident response procedures

#### Monthly
- [ ] Update Terraform providers
- [ ] Update Ansible collections
- [ ] Review and update documentation
- [ ] Conduct DR drill
- [ ] Review access permissions

#### Quarterly
- [ ] Rotate secrets (automated via PowerShell script)
- [ ] Review and update network security groups
- [ ] Audit resource tags and naming conventions
- [ ] Update disaster recovery plan
- [ ] Review compliance status

### Update Procedures

#### Updating Terraform
```powershell
# Backup current state
terraform state pull > terraform-state-backup-$(Get-Date -Format 'yyyyMMdd').json

# Update provider versions in versions.tf
# Run terraform init to download new providers
terraform init -upgrade

# Review and apply changes
terraform plan
terraform apply
```

#### Updating Ansible
```bash
# Update Ansible
sudo apt update
sudo apt upgrade ansible

# Update collections
ansible-galaxy collection install --upgrade ansible.posix community.general

# Test playbooks after update
ansible-playbook playbooks/site.yml --syntax-check
```

#### Updating AKS
```powershell
# Check available upgrades
az aks get-upgrades --resource-group "portfolio-dev-rg" --name "portfolio-dev-aks"

# Upgrade cluster (in maintenance window)
az aks upgrade --resource-group "portfolio-dev-rg" --name "portfolio-dev-aks" --kubernetes-version 1.28.x

# Verify upgrade
kubectl get nodes
kubectl version
```

### Backup Procedures

#### Terraform State Backup
```powershell
# Manual backup
terraform state pull > "backups\terraform-state-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"

# Verify state integrity
terraform state list
```

#### AKS Configuration Backup
```powershell
# Backup all Kubernetes resources
kubectl get all --all-namespaces -o yaml > "backups\k8s-backup-$(Get-Date -Format 'yyyyMMdd').yaml"

# Backup specific namespace
kubectl get all -n production -o yaml > "backups\k8s-prod-backup-$(Get-Date -Format 'yyyyMMdd').yaml"

# Use Velero for automated backups (recommended)
# Install Velero: https://velero.io/docs/v1.12/basic-install/
```

#### Documentation Backup
```powershell
# Commit to Git regularly
git add .
git commit -m "Update documentation - $(Get-Date -Format 'yyyy-MM-dd')"
git push origin main
```

---

## Disaster Recovery

### Recovery Procedures

#### Scenario 1: Terraform State Corruption
1. Restore from backup:
   ```powershell
   # Copy backup to current directory
   Copy-Item "backups\terraform-state-20251219.json" -Destination "terraform.tfstate"
   
   # Push to remote backend
   terraform state push terraform.tfstate
   ```

2. Verify state integrity:
   ```powershell
   terraform plan
   # Should show no changes if state is accurate
   ```

#### Scenario 2: AKS Cluster Failure
1. Verify backup exists
2. Deploy new cluster using Terraform
3. Restore Kubernetes resources:
   ```powershell
   kubectl apply -f backups\k8s-backup-latest.yaml
   ```
4. Verify applications are running
5. Update DNS to point to new cluster

#### Scenario 3: Complete Environment Loss
1. Re-authenticate to Azure: `az login`
2. Restore Terraform state from backup
3. Review and update `terraform.tfvars`
4. Deploy infrastructure: `terraform apply`
5. Configure servers: `ansible-playbook playbooks/site.yml`
6. Restore application data from backups
7. Verify all services
8. Update monitoring and alerting

### RTO/RPO Targets

| Component | RTO | RPO | Backup Frequency |
|-----------|-----|-----|------------------|
| Terraform State | 1 hour | 1 day | Daily automated |
| AKS Configuration | 2 hours | 1 day | Daily automated |
| Application Data | 4 hours | 1 hour | Hourly automated |
| Documentation | 24 hours | 1 week | On Git push |

---

## Support and Escalation

### Getting Help

#### Documentation Resources
- Terraform: https://www.terraform.io/docs
- Ansible: https://docs.ansible.com
- Azure: https://docs.microsoft.com/azure
- AKS: https://docs.microsoft.com/azure/aks

#### Community Support
- Terraform Community: https://discuss.hashicorp.com
- Ansible Forum: https://forum.ansible.com
- Azure Q&A: https://docs.microsoft.com/answers

#### Internal Resources
- Runbooks: `docs/runbooks/`
- Interview Prep: `INTERVIEW-PREPARATION.md`
- README: `README.md`

---

## Changelog

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-12-19 | 1.0 | Initial runbook creation | Portfolio Project |

---

## Appendix

### Quick Reference Commands

#### Terraform
```powershell
terraform init          # Initialize
terraform plan          # Preview changes
terraform apply         # Deploy
terraform destroy       # Remove all resources
terraform state list    # List resources in state
terraform output        # Show outputs
```

#### Ansible
```bash
ansible all -m ping                           # Test connectivity
ansible-playbook playbooks/site.yml           # Run playbook
ansible-playbook playbooks/site.yml --check   # Dry run
ansible-inventory --list                      # Show inventory
```

#### Azure CLI
```powershell
az login                                      # Authenticate
az account list                               # List subscriptions
az resource list                              # List all resources
az group list                                 # List resource groups
az aks get-credentials                        # Get AKS credentials
```

#### kubectl
```powershell
kubectl get nodes                             # List nodes
kubectl get pods --all-namespaces            # List all pods
kubectl logs <pod-name>                       # View logs
kubectl describe pod <pod-name>               # Detailed pod info
kubectl exec -it <pod-name> -- /bin/bash     # Shell into pod
```

### Environment Variables Reference

```powershell
# Azure Authentication (Service Principal)
$env:ARM_CLIENT_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$env:ARM_CLIENT_SECRET = "your-client-secret"
$env:ARM_SUBSCRIPTION_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
$env:ARM_TENANT_ID = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# Terraform Debug
$env:TF_LOG = "DEBUG"
$env:TF_LOG_PATH = "terraform-debug.log"

# Ansible Configuration
$env:ANSIBLE_CONFIG = "ansible.cfg"
$env:ANSIBLE_INVENTORY = "inventory.ini"
```

---

**End of Runbook**

*For questions or issues not covered in this runbook, please refer to the troubleshooting section or consult the documentation resources listed above.*
