# Project Alpha Infrastructure

Production infrastructure for Project Alpha team.

## Environments

- **Development:** acme-dev-alpha-rg-eastus-001
- **Staging:** acme-staging-alpha-rg-eastus-001  
- **Production:** acme-prod-alpha-rg-eastus-001

## Team Access

### Azure AD Groups
- **SG-ALPHA-Owners:** jane.doe@company.com, john.smith@company.com
- **SG-ALPHA-Contributors:** Team developers
- **SG-ALPHA-Readers:** Auditors, stakeholders

### Request Access
Submit request at: https://access.company.com/request?project=alpha

## Infrastructure

### Network
- **Dev VNet:** 10.100.0.0/20 (peered to hub 10.0.0.0/16)
- **Staging VNet:** 10.110.0.0/20
- **Prod VNet:** 10.120.0.0/19

### Core Resources
- AKS Clusters (1 per environment)
- Azure SQL Database
- Azure Cache for Redis
- Storage Accounts
- Application Gateway
- Key Vault

## Deployment

### Prerequisites
```bash
# Install tools
az login
terraform --version  # >= 1.6.0
kubectl version      # >= 1.28

# Get credentials
az account set --subscription "SUB-Project-Alpha"
```

### Deploy Infrastructure
```bash
cd environments/dev
terraform init
terraform plan
terraform apply

# Get AKS credentials
az aks get-credentials --resource-group acme-dev-alpha-rg-eastus-001 --name acme-dev-alpha-aks-eastus-001
```

### CI/CD
All deployments run through GitHub Actions:
- **Dev:** Auto-deploy on merge to `develop`
- **Staging:** Auto-deploy on merge to `main`
- **Prod:** Manual approval required

## Cost Budget

- **Development:** $1,500/month
- **Staging:** $2,000/month
- **Production:** $10,000/month

Alerts at 80% and 100% threshold.

## Support

- **Team Lead:** john.smith@company.com
- **Platform Team:** platform-support@company.com
- **Emergency:** 1-800-555-PROD

## Documentation

- [Architecture Diagram](./docs/architecture.md)
- [Runbooks](./docs/runbooks/)
- [API Documentation](./docs/api/)
