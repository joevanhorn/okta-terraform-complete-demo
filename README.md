# Okta Terraform Provider Demo - OIG Features + Terraformer

This repository demonstrates the **Okta Terraform Provider v6.1.0** with the new **Okta Identity Governance (OIG)** endpoints, automated through GitHub Actions, with full **Terraformer** support for importing existing Okta configurations.

## 🚨 Important: Terraformer Limitations

**Terraformer does NOT import OIG resources** (the Terraform provider endpoints are new).

**What this means:**
- ✅ Terraformer imports: users, groups, apps, policies, etc.
- ❌ Terraformer cannot import: OIG reviews, catalogs, workflows, etc.
- ✅ Solution: Create OIG resources fresh using our Terraform configs

See [Terraformer + OIG FAQ](./docs/TERRAFORMER_OIG_FAQ.md) for full details.

## ✅ Production-Ready Validated Configuration

**NEW:** The `production-ready/` directory contains a **fully validated** Terraform configuration that proves the complete workflow:

- ✅ Import existing Okta resources with Terraformer
- ✅ Manage imported resources with Terraform
- ✅ Add new resources and apply changes
- ✅ Zero drift after apply

**[→ See Production-Ready Directory](./production-ready/README.md)** for the complete validated setup with:
- Working examples of all resource types
- Comprehensive documentation
- Lessons learned from real implementation
- Forking guide for your own use

This is the **recommended starting point** if you want to use Terraformer with Okta.

### 🗂️ Two Configurations Available

This repo contains two distinct configurations:

| Directory | Purpose | Best For |
|-----------|---------|----------|
| **[`production-ready/`](./production-ready/)** | Import & manage existing basic resources | ✅ Most users - Validated workflow |
| **[`terraform/`](./terraform/)** | OIG features demonstration | Advanced users needing governance features |

**Not sure which to use?** See **[DIRECTORY_GUIDE.md](./DIRECTORY_GUIDE.md)** for a detailed comparison and decision tree.

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
- ✅ Bulk operations with rate limiting
- ✅ Idempotent operations

### Terraformer Integration
- ✅ Import existing Okta configurations
- ✅ Automated cleanup and refactoring
- ✅ Drift detection
- ✅ Weekly sync workflows
- ✅ Resource inventory tracking
- ⚠️ **Note:** OIG resources NOT supported by Terraformer (create fresh instead)

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
