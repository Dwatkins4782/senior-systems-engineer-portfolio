# Testing Documentation

## Overview
This project includes multiple levels of testing to ensure infrastructure reliability.

## Test Types

### 1. Terraform Validation Tests

**Purpose:** Validate syntax and configuration without deployment

```powershell
# Format check
terraform fmt -check -recursive

# Initialization
terraform init -backend=false

# Validation
terraform validate

# Static analysis
tflint --init
tflint
```

### 2. Security Scanning

**Tools:**
- **Checkov**: Infrastructure as Code security scanner
- **tfsec**: Terraform security scanner

```powershell
# Install tools
pip install checkov
choco install tfsec

# Run scans
checkov -d terraform/
tfsec terraform/
```

### 3. Terratest (Go-based Integration Tests)

**Purpose:** Test actual deployment and resource creation

**Setup:**
```powershell
# Install Go
choco install golang

# Navigate to test directory
cd terraform/test

# Download dependencies
go mod download

# Run tests
go test -v -timeout 30m
```

**Test Scenarios:**
- ✅ Networking module creates VNet and subnets
- ✅ AKS cluster deploys successfully
- ✅ Key Vault is accessible
- ✅ Container Registry is functional

**Cost Warning:** Integration tests deploy real Azure resources and incur costs!

### 4. Ansible Testing

**Molecule:** Test framework for Ansible roles

```bash
# Install molecule
pip install molecule molecule-plugins[docker]

# Test playbook
cd ansible
molecule test
```

**Alternative: Manual Testing**
```bash
# Syntax check
ansible-playbook playbooks/site.yml --syntax-check

# Dry run
ansible-playbook playbooks/site.yml --check --diff -i inventory/example.ini

# Lint
ansible-lint playbooks/
yamllint playbooks/
```

### 5. PowerShell Testing

**Pester:** PowerShell testing framework

```powershell
# Install Pester
Install-Module -Name Pester -Force

# Run tests
Invoke-Pester -Path .\scripts\powershell\tests\

# With code coverage
$config = New-PesterConfiguration
$config.CodeCoverage.Enabled = $true
Invoke-Pester -Configuration $config
```

## CI/CD Testing

All tests run automatically in GitHub Actions:

- **On Pull Request:** Validation, linting, security scans, dry-run
- **On Merge to Develop:** Deploy to dev environment
- **On Merge to Main:** Deploy to production (with approval)

## Manual Testing Workflow

### Before Deployment

```powershell
# 1. Format code
terraform fmt -recursive

# 2. Validate
terraform validate

# 3. Security scan
checkov -d terraform/
tfsec terraform/

# 4. Plan
terraform plan -out=tfplan

# 5. Review plan carefully
terraform show tfplan
```

### After Deployment

```powershell
# 1. Verify resources exist
az resource list --resource-group portfolio-dev-rg

# 2. Test AKS access
az aks get-credentials --resource-group portfolio-dev-rg --name portfolio-dev-aks
kubectl get nodes

# 3. Test Key Vault
az keyvault secret list --vault-name <vault-name>

# 4. Test ACR
az acr login --name <acr-name>
docker pull <acr-name>.azurecr.io/test:latest
```

## Test Data Cleanup

Always destroy test resources to avoid costs:

```powershell
# Terraform
terraform destroy -auto-approve

# Azure CLI (if Terraform state is lost)
az group delete --name test-portfolio-rg --yes --no-wait
```

## Continuous Testing

- **Daily:** Security scans via scheduled GitHub Actions
- **Weekly:** Drift detection (compare actual vs desired state)
- **Monthly:** Disaster recovery drill (deploy from scratch)
- **Quarterly:** Full integration test suite

## Cost Management

**Estimated Test Costs:**
- Validation tests: $0 (local only)
- Security scans: $0 (open source tools)
- Terratest integration: ~$5-10 per run (15-20 min deployment)
- Full environment: ~$100-150/month if left running

**Best Practices:**
- Run integration tests sparingly
- Use `t.Cleanup()` in Go tests
- Set short retention periods
- Use Dev SKUs (cheaper)
- Tear down test resources immediately

## Troubleshooting Tests

### Terratest Timeout
```go
// Increase timeout
terraformOptions.MaxRetries = 3
terraformOptions.TimeBetweenRetries = 5 * time.Second
```

### State Lock Issues
```powershell
# Force unlock
terraform force-unlock <lock-id>
```

### Authentication Failures
```powershell
# Re-authenticate
az login
az account set --subscription <subscription-id>
```

## Further Reading

- [Terratest Documentation](https://terratest.gruntwork.io/)
- [Ansible Molecule](https://molecule.readthedocs.io/)
- [Pester Documentation](https://pester.dev/)
- [Checkov](https://www.checkov.io/)
- [tfsec](https://aquasecurity.github.io/tfsec/)
