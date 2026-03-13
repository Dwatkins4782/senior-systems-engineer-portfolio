# Azure OIDC Authentication Setup for GitHub Actions

**Document Version:** 1.0
**Last Updated:** March 13, 2026
**Owner:** Portfolio Project
**Status:** Active

---

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Step 1: Register an Azure AD App Registration](#step-1-register-an-azure-ad-app-registration)
- [Step 2: Create a Federated Credential for GitHub Actions](#step-2-create-a-federated-credential-for-github-actions)
- [Step 3: Assign Key Vault Permissions](#step-3-assign-key-vault-permissions)
- [Step 4: Configure GitHub Repository Secrets](#step-4-configure-github-repository-secrets)
- [Step 5: Verify the Pipeline](#step-5-verify-the-pipeline)
- [Troubleshooting](#troubleshooting)

---

## Overview

The PowerShell CI pipeline (`.github/workflows/powershell.yml`) uses **Azure OIDC (OpenID Connect) federated credentials** to authenticate with Azure — no client secrets to manage or rotate. This guide walks through the full setup.

### How OIDC Works with GitHub Actions

```
GitHub Actions Runner
        │
        ├─ Requests OIDC token from GitHub
        │   (includes repo, branch, environment claims)
        │
        ▼
Azure AD (Entra ID)
        │
        ├─ Validates token against federated credential
        ├─ Issues short-lived access token
        │
        ▼
Azure Key Vault
        └─ Runner accesses secrets with scoped permissions
```

Unlike client secret authentication, OIDC tokens are short-lived and scoped to individual workflow runs — no long-lived secrets are stored in GitHub.

---

## Prerequisites

- **Azure subscription** with Owner or Contributor + User Access Administrator role
- **Azure CLI** installed and authenticated (`az login`)
- **GitHub repository** admin access (to configure secrets and environments)

---

## Step 1: Register an Azure AD App Registration

Create a service principal that GitHub Actions will authenticate as.

```bash
# Set variables
APP_NAME="github-actions-portfolio"

# Create the app registration
az ad app create --display-name "$APP_NAME"

# Capture the Application (Client) ID
CLIENT_ID=$(az ad app list --display-name "$APP_NAME" --query "[0].appId" -o tsv)
echo "Client ID: $CLIENT_ID"

# Create a service principal for the app
az ad sp create --id "$CLIENT_ID"

# Capture your Tenant ID and Subscription ID
TENANT_ID=$(az account show --query "tenantId" -o tsv)
SUBSCRIPTION_ID=$(az account show --query "id" -o tsv)

echo "Tenant ID:       $TENANT_ID"
echo "Subscription ID: $SUBSCRIPTION_ID"
```

> **Save these three values** — you will need them for GitHub secrets in Step 4.

---

## Step 2: Create a Federated Credential for GitHub Actions

This tells Azure AD to trust OIDC tokens from your specific GitHub repository and environment.

```bash
# Set your GitHub org/user and repo name
GITHUB_ORG="Dwatkins4782"
GITHUB_REPO="senior-systems-engineer-portfolio"

# Create federated credential for the 'production' environment
az ad app federated-credential create \
  --id "$CLIENT_ID" \
  --parameters '{
    "name": "github-actions-production",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GITHUB_ORG/$GITHUB_REPO"':environment:production",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

### Optional: Additional Federated Credentials

If you also want the pipeline to run on push to `main` (not just from the `production` environment):

```bash
# For the main branch
az ad app federated-credential create \
  --id "$CLIENT_ID" \
  --parameters '{
    "name": "github-actions-main-branch",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GITHUB_ORG/$GITHUB_REPO"':ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

---

## Step 3: Assign Key Vault Permissions

Grant the service principal access to your Key Vault for secret rotation.

```bash
# Set your Key Vault name
KEY_VAULT_NAME="your-keyvault-name"
KEY_VAULT_RG="your-resource-group"

# Option A: RBAC-based access (recommended)
az role assignment create \
  --assignee "$CLIENT_ID" \
  --role "Key Vault Secrets Officer" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$KEY_VAULT_RG/providers/Microsoft.KeyVault/vaults/$KEY_VAULT_NAME"

# Option B: Access policy-based access (if your vault uses access policies)
az keyvault set-policy \
  --name "$KEY_VAULT_NAME" \
  --spn "$CLIENT_ID" \
  --secret-permissions get list set delete
```

---

## Step 4: Configure GitHub Repository Secrets

Navigate to your repository on GitHub:

1. Go to **Settings** > **Secrets and variables** > **Actions**
2. Click **New repository secret** for each of the following:

| Secret Name              | Value                           | Where to Find It                    |
|--------------------------|---------------------------------|-------------------------------------|
| `AZURE_CLIENT_ID`       | Application (Client) ID        | Step 1 output or Azure Portal > App Registrations |
| `AZURE_TENANT_ID`       | Directory (Tenant) ID          | `az account show --query tenantId`  |
| `AZURE_SUBSCRIPTION_ID` | Subscription ID                | `az account show --query id`        |
| `KEY_VAULT_NAME`        | Your Key Vault name            | Azure Portal > Key Vaults           |

Alternatively, use the GitHub CLI:

```bash
gh secret set AZURE_CLIENT_ID --body "$CLIENT_ID"
gh secret set AZURE_TENANT_ID --body "$TENANT_ID"
gh secret set AZURE_SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID"
gh secret set KEY_VAULT_NAME --body "$KEY_VAULT_NAME"
```

### Environment-Scoped Secrets (Recommended)

Since the `rotate-secrets` job uses the `production` environment, you may prefer to scope secrets to that environment:

1. Go to **Settings** > **Environments** > **production** (create if needed)
2. Add the four secrets listed above under the environment
3. Optionally add required reviewers for manual approval before secret rotation

---

## Step 5: Verify the Pipeline

Trigger a manual workflow run to confirm everything works:

```bash
gh workflow run powershell.yml
```

Or navigate to **Actions** > **PowerShell Scripts** > **Run workflow** in the GitHub UI.

### Expected Results

| Job                           | Expected Status |
|-------------------------------|-----------------|
| PSScriptAnalyzer              | Pass            |
| Pester Tests                  | Pass            |
| Rotate Azure Key Vault Secrets| Pass (only on schedule/dispatch) |

---

## Troubleshooting

### "No matching federated identity record found"

The `subject` claim in your federated credential does not match what GitHub sends.

- Verify the subject matches your trigger. For environment-based jobs use:
  `repo:<org>/<repo>:environment:<env-name>`
- The environment name is **case-sensitive** — `production` is not the same as `Production`

### "AADSTS700024: Client assertion is not within its valid time range"

The runner clock is out of sync or the OIDC token expired.

- Re-run the workflow — this is usually transient
- Ensure the `azure/login` step runs before any long-running steps

### "Caller is not authorized to perform action on resource"

The service principal does not have the required Key Vault permissions.

- Verify the role assignment from Step 3: `az role assignment list --assignee "$CLIENT_ID"`
- If using access policies, verify: `az keyvault show --name "$KEY_VAULT_NAME" --query "properties.accessPolicies"`

### "Login failed: Not all parameters are provided in 'creds'"

You are using the old `azure/login@v1` JSON credentials format.

- Ensure the workflow uses `azure/login@v2` with individual `client-id`, `tenant-id`, `subscription-id` parameters
- Ensure the `id-token: write` permission is set at the workflow level
