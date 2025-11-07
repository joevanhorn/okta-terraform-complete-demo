# Repository Guide: Okta Infrastructure as Code

This repository provides a complete solution for managing Okta infrastructure as code, including both standard resources and OIG (Okta Identity Governance) features.

---

## Overview

This repository contains:

1. **production-ready/** - Terraform configurations for standard Okta resources
2. **oig-exports/** - Exported OIG resources committed for version control
3. **GitHub Actions workflows** - Automation for imports and OIG exports
4. **scripts/** - Python tools for OIG resource management

---

## `production-ready/` Directory

### 📋 What It Contains

**Basic Okta Resources (Terraformer-importable):**
- ✅ Users (`okta_user`)
- ✅ Groups (`okta_group`)
- ✅ OAuth Applications (`okta_app_oauth`)
- ✅ Authorization Servers (`okta_auth_server_default`)
- ✅ MFA Policies (`okta_policy_mfa_default`)

**Resource Count:** 21 managed resources
- 6 users (3 existing + 3 new)
- 4 OAuth apps (3 existing + 1 new)
- 4 groups
- 1 auth server
- 1 MFA policy

### 🎯 Use This When You Want To:

1. **Import existing Okta infrastructure** into Terraform
2. **Manage day-to-day Okta resources** (users, groups, apps)
3. **Learn the Terraformer workflow** with real examples
4. **Start production IaC** for your existing Okta org
5. **Fork and customize** for your own organization

### ✅ What's Been Validated

- ✅ Terraformer import → Terraform management workflow
- ✅ Adding new resources to imported configuration
- ✅ Zero drift after apply
- ✅ Template string escaping
- ✅ State consolidation
- ✅ Resource filtering (system apps, admin users)

### 📚 Documentation

- **[README.md](./production-ready/README.md)** - Overview and quick start
- **[FORKING_GUIDE.md](./production-ready/FORKING_GUIDE.md)** - Complete setup guide
- **[LESSONS_LEARNED.md](./production-ready/LESSONS_LEARNED.md)** - Issues and solutions
- **[RESOURCE_REFERENCE.md](./production-ready/RESOURCE_REFERENCE.md)** - Attribute reference

### 💡 Example Use Cases

- "I have an existing Okta org with 500 users and want to manage them with Terraform"
- "I need to import our current apps and groups into IaC"
- "I want to learn how Terraformer works with Okta"
- "I need production-ready patterns for Okta Terraform management"

---

## OIG (Identity Governance) Features

### Overview

OIG features (entitlements, labels, resource owners) are managed via:
- **GitHub Actions workflows** (`lowerdecklabs-export-oig.yml`)
- **Python scripts** (`scripts/okta_api_manager.py`)

This approach provides:
- ✅ Modular export functionality
- ✅ Graceful error handling
- ✅ Support for partial OIG availability
- ✅ Export to JSON for documentation and drift detection

### 🚨 Prerequisites for OIG Features

Before exporting OIG resources, you **MUST** enable Entitlement Management in your Okta Admin Console:

#### Step 1: Enable Entitlement Management (GUI Required)

**Location:** Okta Admin Console → Applications → [Application] → General tab

**Important Notes:**
- This **cannot** be enabled via API or Terraform
- Must be done manually by an Okta admin for **each application**
- Required for `okta_principal_entitlements` resource
- Formerly called "Governance Engine"
- **Provisioning must be OFF** before enabling Entitlement Management
- Provisioning **can be re-enabled** after activation completes

**Steps:**
1. Log into Okta Admin Console as super admin
2. Navigate to **Applications** → **Applications**
3. Select the application requiring entitlements
4. **FIRST:** Go to **Provisioning** tab and disable provisioning
5. Go to **General** tab
6. Enable **Entitlement Management**
7. Wait for activation (may take 1-2 minutes)
8. **OPTIONAL:** Re-enable provisioning after activation

#### Step 2: Verify OIG License

Ensure your Okta organization has:
- ✅ Okta Identity Governance (OIG) license
- ✅ Entitlement Management enabled (see Step 1)
- ✅ Access to Identity Governance features

**Without these prerequisites, you will receive API errors when trying to create entitlements.**

**📖 Detailed Setup Guide:** See **[OIG_PREREQUISITES.md](./OIG_PREREQUISITES.md)** for complete step-by-step instructions, common errors, and troubleshooting.

### 📋 What Can Be Exported

**OIG Resources (via API):**
- ✅ Entitlements - Principal entitlements and bundles
- ✅ Resource Owners - Owners assigned to apps/groups/entitlements
- ✅ Governance Labels - Labels and their resource assignments

**Export Features:**
- Modular export (export only what you need)
- Graceful error handling (continues if some features unavailable)
- Status tracking (success/not_available/error per resource type)
- JSON output for documentation and drift detection

### 🎯 Use This When You Want To:

1. **Export existing OIG configurations** for documentation
2. **Detect drift** in OIG resource assignments
3. **Backup** entitlements, owners, and labels
4. **Document** current governance state
5. **Prepare for migration** to another tenant

### ⚠️ Important Notes

- **Read-only operations** - Exports do not modify your tenant
- **Requires approval** - Even read-only operations use GitHub environment protection
- **Modular approach** - Works even if only some apps have entitlement management enabled
- **Not Terraformer-compatible** - OIG resources cannot be imported via Terraformer
- **🚨 Manual Enablement Required** - Entitlement Management must be enabled manually in the Okta Admin Console before entitlements will appear in exports

### 📚 Documentation

- **[docs/LOWERDECKLABS_SETUP.md](./docs/LOWERDECKLABS_SETUP.md)** - Complete setup guide
- **[docs/API_MANAGEMENT.md](./docs/API_MANAGEMENT.md)** - API manager documentation
- **[OIG_PREREQUISITES.md](./OIG_PREREQUISITES.md)** - Prerequisites and setup

### 💡 Example Use Cases

- "Export all entitlements from my production tenant for documentation"
- "Compare OIG configurations between environments"
- "Backup resource owner assignments before making changes"
- "Document which apps have governance labels applied"

---

## Workflow Guide

### Start Here: What's Your Goal?

```
What do you want to do?

├─ Import existing Okta resources into Terraform
│  → Use production-ready/ directory
│  → Follow Terraformer import workflow
│  → See docs/TERRAFORMER.md
│
├─ Export OIG resources (entitlements, labels, owners)
│  → Use GitHub Actions workflow: lowerdecklabs-export-oig.yml
│  → See docs/LOWERDECKLABS_SETUP.md
│  → Download artifacts with exported JSON
│
└─ Manage Okta resources with Terraform
   → Use production-ready/ directory
   → Standard Okta resources only (users, groups, apps, policies)
   → OIG resources are exported via API, not managed by Terraform
```

### Common Scenarios

**Scenario 1: "I have an existing Okta org with 1000 users"**
1. Use production-ready/ with Terraformer to import
2. Review imported configuration
3. Apply to verify zero drift
4. Manage going forward with Terraform

**Scenario 2: "I need to export entitlements for documentation"**
1. Set up LowerDeckLabs GitHub environment (or your environment)
2. Run lowerdecklabs-export-oig.yml workflow
3. Download JSON artifact
4. Review export status and exported resources

**Scenario 3: "I want both standard resources AND OIG"**
1. Import standard resources with production-ready/ + Terraformer
2. Export OIG resources with GitHub Actions workflow
3. Use both for complete infrastructure documentation

---

## Quick Reference

### Standard Resources (Terraform)

| Resource Type | Location | Import Method |
|--------------|----------|---------------|
| Users | production-ready/ | Terraformer |
| Groups | production-ready/ | Terraformer |
| OAuth Apps | production-ready/ | Terraformer |
| SAML Apps | production-ready/ | Terraformer |
| Auth Servers | production-ready/ | Terraformer |
| Policies | production-ready/ | Terraformer |

### OIG Resources (API Export)

| Resource Type | Export Method | Status Tracking |
|--------------|---------------|-----------------|
| Entitlements | GitHub Actions workflow | ✅ Yes |
| Resource Owners | GitHub Actions workflow | ✅ Yes |
| Labels | GitHub Actions workflow | ✅ Yes |

---

## Getting Started

### For Standard Resource Management

```bash
# Clone the repo
git clone <repo-url>

# Navigate to production-ready
cd production-ready/

# Read the documentation
cat README.md
cat FORKING_GUIDE.md

# Initialize and validate
terraform init
terraform plan
```

### For OIG Export

```bash
# Set up GitHub environment
# See docs/LOWERDECKLABS_SETUP.md for complete guide

# Run the workflow
Actions → LowerDeckLabs OIG Export → Run workflow

# Download artifacts
# JSON export with status tracking
```

---

## Summary

| Task | Solution |
|------|----------|
| Import existing Okta resources | production-ready/ + Terraformer |
| Manage users/groups/apps with Terraform | production-ready/ |
| Export OIG entitlements | GitHub Actions workflow |
| Export resource owners | GitHub Actions workflow |
| Export governance labels | GitHub Actions workflow |
| Complete documentation | Combine Terraform IaC + OIG exports |

---

Last updated: 2025-11-07

### Option 1: Separate State Files (Recommended)

```
my-okta-terraform/
├── core/                    # From production-ready/
│   ├── users.tf
│   ├── groups.tf
│   ├── apps.tf
│   └── terraform.tfstate
│
└── governance/              # From terraform/
    ├── entitlements.tf
    ├── reviews.tf
    ├── workflows.tf
    └── terraform.tfstate
```

**Benefits:**
- Independent management
- Easier troubleshooting
- Clear separation of concerns

### Option 2: Single Merged Configuration

```
my-okta-terraform/
├── users.tf                 # From production-ready/
├── groups.tf                # From production-ready/
├── apps.tf                  # From production-ready/
├── entitlements.tf          # From terraform/
├── reviews.tf               # From terraform/
├── workflows.tf             # From terraform/
└── terraform.tfstate        # Single state
```

**Benefits:**
- Single plan/apply
- Resource dependencies possible
- Unified state

**Caution:**
- More complex to manage
- Harder to troubleshoot
- Import workflow more complicated

---

## Migration Path

### From Production-Ready to Full OIG

1. **Start:** Import existing resources with `production-ready/`
   ```bash
   cd production-ready/
   terraform init
   terraform plan  # Verify imports
   ```

2. **Validate:** Ensure zero drift
   ```bash
   terraform plan
   # Should show: "No changes"
   ```

3. **Add OIG:** Copy desired resources from `terraform/`
   ```bash
   # Example: Add entitlements
   cp ../terraform/main.tf ./entitlements.tf
   # Edit to match your resources
   ```

4. **Test:** Plan before applying
   ```bash
   terraform plan
   # Review OIG resource creations
   ```

5. **Apply:** Create OIG resources
   ```bash
   terraform apply
   ```

---

## Resource Type Matrix

| Resource Type | production-ready/ | terraform/ | Terraformer Import |
|--------------|-------------------|------------|-------------------|
| **Users** | ✅ Managed | ✅ Examples | ✅ Supported |
| **Groups** | ✅ Managed | ✅ Examples | ✅ Supported |
| **OAuth Apps** | ✅ Managed | ✅ Examples | ✅ Supported |
| **Auth Servers** | ✅ Managed | ❌ Not shown | ✅ Supported |
| **MFA Policies** | ✅ Managed | ❌ Not shown | ✅ Supported |
| **Entitlements** | ❌ Not included | ✅ Examples | ❌ Not supported |
| **Access Reviews** | ❌ Not included | ✅ Examples | ❌ Not supported |
| **Request Workflows** | ❌ Not included | ✅ Examples | ❌ Not supported |
| **Catalog Config** | ❌ Not included | ✅ Examples | ❌ Not supported |
| **Resource Owners** | ❌ Not included | ✅ API-managed | ❌ Not supported |
| **Gov Labels** | ❌ Not included | ✅ API-managed | ❌ Not supported |

---

## Key Differences

### Technology Stack

**production-ready/**
- Terraform only
- Terraformer for imports
- Standard Okta provider resources

**terraform/**
- Terraform for OIG resources
- Python scripts for API-only features
- `null_resource` for API orchestration
- External data sources

### Complexity Level

**production-ready/**
- 🟢 Beginner-friendly
- Well-documented
- Proven workflow
- Clear examples

**terraform/**
- 🟡 Intermediate
- Multiple technologies
- Reference implementation
- Requires OIG understanding

### Support & Validation

**production-ready/**
- ✅ Fully tested end-to-end
- ✅ Real import validation
- ✅ Comprehensive troubleshooting
- ✅ Production patterns

**terraform/**
- ⚠️ Feature demonstration
- ⚠️ Example/reference code
- ⚠️ May need customization
- ⚠️ OIG license required

---

## Recommendations

### For Most Users: Start with `production-ready/`

**Why?**
1. Proven workflow
2. Comprehensive documentation
3. Real-world validation
4. Easier to understand
5. Works with existing orgs

### When to Use `terraform/`

**Only if you:**
1. Have OIG license
2. Need OIG features specifically
3. Want to learn OIG capabilities
4. Are implementing access governance

### Best Practice

1. **Learn** with `production-ready/`
2. **Import** your existing resources
3. **Validate** the workflow
4. **Add** OIG features from `terraform/` if needed

---

## Getting Started

### Path 1: Basic Resources (Recommended First)

```bash
# Clone the repo
git clone <repo-url>

# Start with production-ready
cd production-ready/

# Read the docs
cat README.md
cat FORKING_GUIDE.md

# Follow the setup
terraform init
terraform plan
```

### Path 2: OIG Features

**⚠️ FIRST: Enable Entitlement Management in Okta Admin Console GUI**
(See Prerequisites section above - this cannot be done via API!)

**Critical Steps:**
1. For each application: Disable provisioning
2. Enable Entitlement Management in application's General tab
3. Wait for activation (1-2 minutes)
4. Re-enable provisioning (optional)

```bash
# Clone the repo
git clone <repo-url>

# Go to OIG examples
cd terraform/

# Review the examples
cat main.tf
cat advanced-oig-examples.tf

# Verify prerequisites are met
# - OIG license active
# - Entitlement Management enabled per application (General tab)
# - Provisioning was disabled during enablement
# - API token has governance scopes

# Customize for your needs
```

---

## Questions?

- **Basic resources & imports:** See [production-ready/FORKING_GUIDE.md](./production-ready/FORKING_GUIDE.md)
- **OIG features:** See [terraform/README.md](./terraform/)
- **Troubleshooting:** See [production-ready/LESSONS_LEARNED.md](./production-ready/LESSONS_LEARNED.md)
- **Resource attributes:** See [production-ready/RESOURCE_REFERENCE.md](./production-ready/RESOURCE_REFERENCE.md)

---

## Summary

| If You Want... | Use This Directory |
|----------------|-------------------|
| Import existing Okta org | `production-ready/` |
| Learn Terraformer workflow | `production-ready/` |
| Manage users, groups, apps | `production-ready/` |
| Production-ready patterns | `production-ready/` |
| Access reviews | `terraform/` |
| Entitlements | `terraform/` |
| Approval workflows | `terraform/` |
| Resource owners/labels | `terraform/` |
| OIG feature reference | `terraform/` |

**Still unsure?** Start with `production-ready/` - it's validated, documented, and production-ready!

---

Last updated: 2025-11-07
