# Okta Terraform Provider Demo - OIG Features + Terraformer

This repository demonstrates the **Okta Terraform Provider v6.1.0** with the new **Okta Identity Governance (OIG)** endpoints, automated through GitHub Actions, with full **Terraformer** support for importing existing Okta configurations.

## 🚨 Important: Terraformer Limitations

**Terraformer does NOT import OIG resources** (the Terraform provider endpoints are new).

**What this means:**
- ✅ Terraformer imports: users, groups, apps, policies, etc.
- ❌ Terraformer cannot import: OIG reviews, catalogs, workflows, etc.
- ✅ Solution: Create OIG resources fresh using our Terraform configs

See [Terraformer + OIG FAQ](./docs/TERRAFORMER_OIG_FAQ.md) for full details.

## 🏗️ Environment-Based Structure

This repository uses an **environment-based structure** to organize Okta configurations by tenant:

```
environments/
├── lowerdecklabs/      # Primary demo tenant
│   ├── terraform/      # Terraform configurations
│   ├── imports/        # Raw API import data
│   └── config/         # Resource owners and labels
├── production/         # Production tenant
├── staging/            # Staging tenant
└── development/        # Development tenant
```

**Benefits:**
- ✅ Clear separation of tenant configurations
- ✅ Easy to fork and customize for your organization
- ✅ Self-contained environments with independent Terraform state
- ✅ Template structure for multi-environment deployments

**[→ See Environments README](./environments/README.md)** for complete guide including:
- Directory structure and organization
- Import workflows for each environment
- Terraform usage examples
- Best practices for multi-tenant management

**📋 Want to use OIG features?** See **[OIG_PREREQUISITES.md](./OIG_PREREQUISITES.md)** for required setup steps (Entitlement Management must be enabled manually in GUI).

## 🎯 What's New in v6.1.0

The Okta Terraform Provider v6.1.0 introduces comprehensive support for Okta Identity Governance, including:

### New Resources & Data Sources

- **`okta_reviews`** - Access review campaigns for periodic certification
- **`okta_principal_entitlements`** - Define what principals have access to
- **`okta_request_conditions`** - Conditions for access requests
- **`okta_request_sequences`** - Approval workflows with multiple stages
- **`okta_request_settings`** - Global access request configuration
- **`okta_request_v2`** - Create access requests programmatically
- **`okta_catalog_entry_default`** - Configure app catalog entries
- **`okta_catalog_entry_user_access_request_fields`** - Custom request fields
- **`okta_end_user_my_requests`** - Query user's access requests

## 🏗️ Architecture

This demo creates a complete OIG workflow with support for importing existing configurations:

1. **Core Resources**: Groups, users, and an OAuth application
2. **Access Request Configuration**: Settings, conditions, and approval sequences
3. **Catalog Management**: Configurable app catalog with custom fields
4. **Entitlements**: Principal-based access definitions
5. **Access Reviews**: Quarterly certification campaigns
6. **Request Management**: Automated access request creation
7. **Resource Owners & Labels**: API-based management (not in Terraform provider yet)
8. **Terraformer Integration**: Import existing Okta resources into Terraform

## 📦 Features

### Terraform Provider Support
- ✅ All 9 new OIG resources from v6.1.0
- ✅ Advanced approval workflows
- ✅ Risk-based conditional access
- ✅ Access review campaigns

### API Management (Python)
- ✅ Resource Owners assignment
- ✅ Governance Labels creation and assignment
- ✅ Automated admin entitlement labeling
- ✅ Label mapping sync from Okta
- ✅ PR-based label management workflow
- ✅ Bulk operations with rate limiting
- ✅ Idempotent operations

### Terraformer Integration
- ✅ Import existing Okta configurations
- ✅ Automated cleanup and refactoring
- ✅ Drift detection
- ✅ Weekly sync workflows
- ✅ Resource inventory tracking
- ⚠️ **Note:** OIG resources NOT supported by Terraformer (create fresh instead)

### Label Management (NEW)
- ✅ Automatic discovery and labeling of admin entitlements
- ✅ Label mapping files synced from Okta per environment
- ✅ Automated workflow for label assignments
- ✅ GitHub Actions workflows for automated labeling
- ✅ Currently managing 2 governance labels in LowerDeckLabs

See **[environments/lowerdecklabs/config/label_mappings.json](./environments/lowerdecklabs/config/label_mappings.json)** for example configuration.

## 📋 Prerequisites

- **Okta Organization** with OIG enabled
- **Terraform** >= 1.9.0
- **Terraformer** >= 0.8.24 (for import functionality)
- **Python** >= 3.8 (for API management scripts)
- **GitHub** repository with Actions enabled
- **AWS S3** bucket for Terraform state (or alternative backend)
- **Okta API Token** with appropriate permissions

### Required Okta Permissions

Your API token needs these scopes:
- `okta.groups.manage`
- `okta.users.manage`
- `okta.apps.manage`
- `okta.governance.accessRequests.manage`
- `okta.governance.accessReviews.manage`
- `okta.governance.catalogs.manage`

### Installation
```bash
# Install Terraform
brew install terraform  # macOS
# or download from https://www.terraform.io/downloads

# Install Terraformer
brew install terraformer  # macOS
# or download from https://github.com/GoogleCloudPlatform/terraformer/releases

# Install Python dependencies
pip install -r requirements.txt
