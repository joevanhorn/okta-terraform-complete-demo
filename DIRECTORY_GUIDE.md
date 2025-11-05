# Directory Guide: Which Configuration Should I Use?

This repository contains two distinct Terraform configurations for different use cases. This guide helps you choose the right one.

---

## Quick Comparison

| Feature | `production-ready/` | `terraform/` |
|---------|-------------------|--------------|
| **Purpose** | Import & manage existing basic resources | Demonstrate new OIG features |
| **Status** | ✅ Fully validated & tested | 🎯 Feature demonstration |
| **Terraformer Compatible** | ✅ Yes - designed for imports | ❌ No - OIG not supported |
| **Production Ready** | ✅ Yes - proven workflow | ⚠️ Demo/reference only |
| **Best For** | Existing Okta orgs | New OIG implementations |

---

## Directory 1: `production-ready/`

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

## Directory 2: `terraform/`

### 🚨 Prerequisites for OIG Features

Before using the `terraform/` directory, you **MUST** enable Entitlement Management in your Okta Admin Console:

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

### 📋 What It Contains

**OIG (Okta Identity Governance) Resources:**
- ✅ Entitlements (`okta_principal_entitlements`)
- ✅ Access Reviews (`okta_reviews`)
- ✅ Access Request Settings (`okta_request_settings`)
- ✅ Access Request Conditions (`okta_request_conditions`)
- ✅ Approval Workflows (`okta_request_sequences`)
- ✅ Access Requests (`okta_request_v2`)
- ✅ Catalog Management (`okta_catalog_entry_*`)
- ✅ Resource Owners (API-managed via Python)
- ✅ Governance Labels (API-managed via Python)

**Plus Basic Resources:**
- Users and groups (for demonstration)
- OAuth apps (for catalog entries)

### 🎯 Use This When You Want To:

1. **Implement Okta Identity Governance** features
2. **Learn about OIG capabilities** in Terraform Provider v6.1.0
3. **Set up access review campaigns**
4. **Configure approval workflows** for access requests
5. **Understand API-managed resources** (owners, labels)

### ⚠️ Important Notes

- **Not Terraformer-compatible** - OIG resources cannot be imported
- **Demonstration/reference** - Not a validated production workflow
- **Requires OIG license** - These features need Okta Identity Governance
- **Fresh creation** - Resources must be created new, not imported
- **🚨 Manual Enablement Required** - Entitlement Management (formerly "Governance Engine") **MUST be enabled manually** in the Okta Admin Console **before** you can manage entitlements via API/Terraform. This cannot currently be enabled via API.

### 📚 Documentation

- **[terraform/README.md](./terraform/)** - OIG feature overview
- Examples for each OIG resource type
- API integration patterns

### 💡 Example Use Cases

- "I want to set up quarterly access certification reviews"
- "I need multi-stage approval workflows for sensitive app access"
- "I want to understand what OIG features are available in Terraform"
- "I need to assign resource owners to applications"

---

## Decision Tree

### Start Here: What's Your Goal?

```
Do you have an EXISTING Okta org you want to manage?
├─ YES → Use `production-ready/`
│         Follow the Terraformer import workflow
│
└─ NO → Are you implementing OIG features?
         ├─ YES → Use `terraform/`
         │         Reference for OIG resources
         │
         └─ NO → Use `production-ready/`
                  Start with basic resources
```

### More Specific Scenarios

**Scenario 1: "I have 1000 users in Okta already"**
→ Use `production-ready/`
- Import with Terraformer
- Manage going forward

**Scenario 2: "I want to set up access reviews"**
→ Use `terraform/`
- OIG features demonstration
- Cannot import existing reviews (if any)

**Scenario 3: "I'm starting a new Okta org"**
→ Use `production-ready/`
- Create basic resources
- Add OIG later from `terraform/` examples

**Scenario 4: "I want both basic resources AND OIG"**
→ Use both!
1. Start with `production-ready/` for basic resources
2. Add OIG resources from `terraform/` examples
3. Keep them in separate state files or merge carefully

---

## Combining Both Approaches

You can use both directories together:

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

Last updated: 2025-11-04
