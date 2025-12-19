# Enterprise Naming Standards

**Version:** 2.0  
**Last Updated:** December 19, 2025  
**Owner:** Cloud Architecture Team

---

## Naming Convention Pattern

### Standard Format
```
{company}-{environment}-{project}-{resource-type}-{region}-{instance}
```

### Component Definitions

| Component | Description | Valid Values | Length |
|-----------|-------------|--------------|--------|
| **company** | Organization identifier | `acme` | 2-6 chars |
| **environment** | Deployment environment | `dev`, `staging`, `prod`, `sandbox` | 3-7 chars |
| **project** | Project/team code | `alpha`, `beta`, `shared` | 3-10 chars |
| **resource-type** | Azure resource type | See table below | 2-10 chars |
| **region** | Azure region abbreviation | `eastus`, `westus2`, `eus`, `wus2` | 3-10 chars |
| **instance** | Instance number (if multiple) | `001`, `002`, `003` | 3 digits |

---

## Resource Type Abbreviations

### Compute
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| Virtual Machine | `vm` | acme-prod-alpha-vm-eastus-001 |
| VM Scale Set | `vmss` | acme-prod-alpha-vmss-eastus-001 |
| AKS Cluster | `aks` | acme-prod-alpha-aks-eastus-001 |
| Container Instance | `aci` | acme-prod-alpha-aci-eastus-001 |
| Function App | `func` | acme-prod-alpha-func-eastus-001 |
| App Service | `app` | acme-prod-alpha-app-eastus-001 |

### Networking
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| Virtual Network | `vnet` | acme-prod-alpha-vnet-eastus-001 |
| Subnet | `snet` | acme-prod-alpha-snet-aks-eastus-001 |
| Network Security Group | `nsg` | acme-prod-alpha-nsg-eastus-001 |
| Application Security Group | `asg` | acme-prod-alpha-asg-web-eastus-001 |
| Public IP | `pip` | acme-prod-alpha-pip-eastus-001 |
| Load Balancer | `lb` | acme-prod-alpha-lb-eastus-001 |
| Application Gateway | `agw` | acme-prod-alpha-agw-eastus-001 |
| VPN Gateway | `vpngw` | acme-prod-hub-vpngw-eastus-001 |
| Azure Firewall | `afw` | acme-prod-hub-afw-eastus-001 |

### Storage
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| Storage Account | `st` | acmeprodalphasteustus001 (no hyphens) |
| Storage Account (blob) | `stblob` | acmeprodalphastblobeustus001 |
| Storage Account (file) | `stfile` | acmeprodalphastfileeustus001 |

### Data
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| SQL Server | `sql` | acme-prod-alpha-sql-eastus-001 |
| SQL Database | `sqldb` | acme-prod-alpha-sqldb-eastus-001 |
| Cosmos DB | `cosmos` | acme-prod-alpha-cosmos-eastus-001 |
| Azure Cache for Redis | `redis` | acme-prod-alpha-redis-eastus-001 |
| Data Factory | `adf` | acme-prod-alpha-adf-eastus-001 |
| Synapse Workspace | `synapse` | acme-prod-alpha-synapse-eastus-001 |

### Monitoring & Security
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| Log Analytics Workspace | `logs` | acme-prod-alpha-logs-eastus-001 |
| Application Insights | `appinsights` | acme-prod-alpha-appinsights-eastus-001 |
| Key Vault | `kv` | acme-prod-alpha-kv-eus-001 (24 char limit) |
| Recovery Services Vault | `rsv` | acme-prod-alpha-rsv-eastus-001 |

### Management
| Resource | Abbreviation | Example |
|----------|-------------|---------|
| Resource Group | `rg` | acme-prod-alpha-rg-eastus-001 |
| Management Group | `mg` | acme-prod-mg |
| Automation Account | `aa` | acme-prod-alpha-aa-eastus-001 |

---

## Region Abbreviations

| Azure Region | Full Code | Short Code |
|--------------|-----------|------------|
| East US | `eastus` | `eus` |
| East US 2 | `eastus2` | `eus2` |
| West US | `westus` | `wus` |
| West US 2 | `westus2` | `wus2` |
| Central US | `centralus` | `cus` |
| North Europe | `northeurope` | `neu` |
| West Europe | `westeurope` | `weu` |
| Southeast Asia | `southeastasia` | `sea` |
| Australia East | `australiaeast` | `aue` |

**Note:** Use short code for resources with strict character limits (e.g., Key Vault, Storage Account)

---

## Special Cases

### Storage Accounts
**Rules:**
- No hyphens or special characters
- All lowercase
- 3-24 characters
- Globally unique

**Pattern:**
```
{company}{env}{project}{type}{region}{instance}

Example: acmeprodalphasteustus001
```

### Key Vaults
**Rules:**
- 3-24 characters
- Alphanumeric and hyphens only
- Globally unique

**Pattern:**
```
{company}-{env}-{project}-kv-{short-region}-{instance}

Example: acme-prod-alpha-kv-eus-001
```

### Container Registries
**Rules:**
- 5-50 characters
- Alphanumeric only
- Globally unique

**Pattern:**
```
{company}{env}{project}acr{region}{instance}

Example: acmeprodalphaacreastus001
```

---

## Environment Codes

| Environment | Code | Description |
|-------------|------|-------------|
| Sandbox | `sbx` or `sandbox` | Temporary experimentation |
| Development | `dev` | Active development |
| QA/Test | `qa` or `test` | Quality assurance |
| Staging | `staging` or `stg` | Pre-production |
| Production | `prod` | Live production |
| DR | `dr` | Disaster recovery |

---

## Project Codes

### Assignment Rules
1. 3-10 characters
2. Lowercase alphanumeric only
3. Registered in project database
4. Unique across organization

### Examples
| Project Name | Code | Team |
|--------------|------|------|
| Customer Portal | `portal` | Web Team |
| Data Analytics Platform | `dataplatform` | Data Team |
| Mobile App API | `mobileapi` | Mobile Team |
| Internal HR System | `hrportal` | HR Team |
| Shared Platform Services | `shared` | Platform Team |
| Foundation/Hub | `hub` | Platform Team |

---

## Azure AD Naming

### Security Groups
```
SG-{PROJECT}-{ROLE}

Examples:
- SG-ALPHA-Owners
- SG-ALPHA-Contributors
- SG-ALPHA-Readers
- SG-ALPHA-DevOps
- SG-ALPHA-Data-Admins
```

### Service Principals
```
spn-{project}-{purpose}

Examples:
- spn-alpha-terraform
- spn-alpha-cicd
- spn-alpha-monitoring
```

### Managed Identities
```
id-{project}-{resource}-{purpose}

Examples:
- id-alpha-aks-keyvault
- id-alpha-func-storage
- id-alpha-vm-backup
```

---

## Tagging Standards

### Required Tags (Enforced via Policy)

| Tag Name | Description | Example |
|----------|-------------|---------|
| **Environment** | Deployment environment | `prod`, `dev`, `staging` |
| **Project** | Project identifier | `alpha`, `beta` |
| **CostCenter** | Cost allocation | `CC-12345` |
| **BusinessOwner** | Business owner email | `jane.doe@company.com` |
| **TechnicalLead** | Technical lead email | `john.smith@company.com` |
| **ManagedBy** | Management tool | `Terraform`, `ARM`, `Portal` |

### Optional Tags

| Tag Name | Description | Example |
|----------|-------------|---------|
| **Application** | Application name | `CustomerPortal` |
| **Tier** | Architecture tier | `Web`, `App`, `Data` |
| **Compliance** | Compliance requirements | `HIPAA`, `PCI-DSS`, `SOC2` |
| **DataClassification** | Data sensitivity | `Public`, `Internal`, `Confidential`, `Restricted` |
| **BackupPolicy** | Backup schedule | `Daily`, `Weekly`, `Monthly` |
| **DR** | Disaster recovery | `Required`, `Not-Required` |
| **CreatedDate** | Resource creation date | `2025-12-19` |
| **CriticalityLevel** | Business criticality | `Critical`, `High`, `Medium`, `Low` |

---

## Validation & Enforcement

### Automated Validation
All resources validated via:
1. **Azure Policy:** Enforce naming patterns
2. **Terraform Validation:** Pre-deployment checks
3. **CI/CD Pipeline:** Automated naming validation

### Naming Convention Checker

```powershell
# PowerShell function to validate resource name
function Test-AzureResourceName {
    param(
        [string]$Name,
        [string]$ResourceType
    )
    
    $pattern = "^[a-z]{2,6}-(?:dev|staging|prod|sbx)-[a-z]{3,10}-[a-z]{2,10}-(?:eastus|westus2|eus|wus2)-\d{3}$"
    
    if ($Name -match $pattern) {
        Write-Host "✓ Valid name: $Name" -ForegroundColor Green
        return $true
    } else {
        Write-Host "✗ Invalid name: $Name" -ForegroundColor Red
        Write-Host "  Expected pattern: company-env-project-type-region-###"
        return $false
    }
}

# Test examples
Test-AzureResourceName -Name "acme-prod-alpha-vm-eastus-001" -ResourceType "vm"
Test-AzureResourceName -Name "bad-name-format" -ResourceType "vm"
```

---

## Naming Decision Tree

```
1. Is it a storage account or ACR?
   └─ YES → Use no-hyphen format
   └─ NO  → Continue

2. Is it a Key Vault?
   └─ YES → Use short region code (24 char limit)
   └─ NO  → Continue

3. Is it regionally deployed?
   └─ YES → Include region
   └─ NO  → Omit region (e.g., management groups)

4. Are there multiple instances?
   └─ YES → Include instance number (001, 002, 003)
   └─ NO  → Use 001 for consistency

5. Apply standard pattern:
   company-environment-project-resourcetype-region-instance
```

---

## Examples by Scenario

### Single Region Deployment
```
acme-prod-alpha-aks-eastus-001
acme-prod-alpha-vnet-eastus-001
acme-prod-alpha-sql-eastus-001
acmeprodalphasteustus001
```

### Multi-Region Deployment
```
Primary:
- acme-prod-alpha-aks-eastus-001
- acme-prod-alpha-vnet-eastus-001

Secondary (DR):
- acme-prod-alpha-aks-westus2-001
- acme-prod-alpha-vnet-westus2-001
```

### Multiple Instances
```
acme-prod-alpha-vm-eastus-001
acme-prod-alpha-vm-eastus-002
acme-prod-alpha-vm-eastus-003
```

### Hub-and-Spoke
```
Hub:
- acme-prod-hub-vnet-eastus-001
- acme-prod-hub-vpngw-eastus-001
- acme-prod-hub-afw-eastus-001

Spokes:
- acme-prod-alpha-vnet-eastus-001
- acme-prod-beta-vnet-eastus-001
- acme-prod-gamma-vnet-eastus-001
```

---

## Non-Compliance Resolution

### Process
1. **Detection:** Automated scanning via Azure Policy
2. **Notification:** Alert sent to resource owner
3. **Remediation Window:** 30 days to rename or justify
4. **Escalation:** After 30 days, automatic ticket to platform team
5. **Enforcement:** Non-compliant resources may be tagged for deletion

### Exception Process
1. Submit exception request with business justification
2. Architecture review board approval required
3. Document exception in central registry
4. Annual review of all exceptions

---

## FAQ

**Q: What if a name exceeds character limits?**  
A: Use abbreviations or short codes. For example, use `kv` instead of `keyvault`, or `eus` instead of `eastus`.

**Q: How do I handle legacy resources?**  
A: Legacy resources should be gradually migrated to new naming standards during maintenance windows.

**Q: Can I use custom project codes?**  
A: Yes, but they must be registered with the platform team and added to the official project registry.

**Q: What about globally unique resources?**  
A: Add random suffix if needed: `acmeprodalphasteustus001xyz` or use random_id in Terraform.

**Q: How strictly are these enforced?**  
A: Enforced via Azure Policy for all new resources. Existing resources have 180-day grace period.

---

**Questions?** Contact cloud-architecture@company.com
