# OIG Configuration - Labels & Resource Owners

This directory contains configuration for managing Okta Identity Governance (OIG) labels and resource owners via the Okta API.

## 📋 Overview

This configuration enables GitOps-style management of:
- **Labels** - Categorize and govern access to resources (Privileged, Standard, Sensitive-Data, Compliance-Required)
- **Resource Owners** - Assign ownership to apps, groups, and entitlement bundles for governance and access reviews
- **Auto-Labeling Rules** - Automatically apply labels based on resource name patterns

## 📁 Files in This Directory

- **`api_config.json`** - Legacy label configuration (deprecated, use label_mappings.json)
- **`label_mappings.json`** - **Source of truth** for label IDs and assignments (synced from Okta)
- **`owner_mappings.json`** - **Source of truth** for resource owner assignments (synced from Okta)

## 🆕 PR-Based Label Management (Recommended)

**New workflow:** Manage label assignments via pull requests using `label_mappings.json`

### How It Works

1. **Sync from Okta** - Run `sync_label_mappings.py` to update local mappings
2. **Make Changes** - Edit `config/label_mappings.json` to add/remove assignments
3. **Submit PR** - Create pull request for review
4. **Apply** - After merge, run workflow to apply changes to Okta

### Quick Start

```bash
# Sync current state from Okta
python3 scripts/sync_label_mappings.py

# Edit label_mappings.json to add a new assignment
# Add ORN to the appropriate array under assignments

# Commit and push
git add config/label_mappings.json
git commit -m "feat: Add Privileged label to new admin entitlement"
git push

# After PR merge, labels are applied automatically via GitHub Actions
```

### label_mappings.json Structure

```json
{
  "labels": {
    "Privileged": {
      "labelId": "lbc11keklyNa6KhMi1d7",
      "labelValueId": "lbl11keklzHO41LJ11d7",
      "description": "High-privilege access",
      "color": "red"
    }
  },
  "assignments": {
    "entitlement_bundles": {
      "Privileged": [
        "orn:okta:governance:org:entitlement-bundles:id1",
        "orn:okta:governance:org:entitlement-bundles:id2"
      ]
    }
  }
}
```

---

## 👥 PR-Based Resource Owner Management (Recommended)

**New workflow:** Manage resource owner assignments via pull requests using `owner_mappings.json`

### How It Works

1. **Sync from Okta** - Run `sync_owner_mappings.py` to update local mappings
2. **Make Changes** - Edit `config/owner_mappings.json` to add/remove owner assignments
3. **Submit PR** - Create pull request for review
4. **Apply** - After merge, run workflow to apply changes to Okta

### Quick Start

```bash
# Sync current state from Okta
python3 scripts/sync_owner_mappings.py

# Edit owner_mappings.json to add/modify owner assignments
# Add new owner to a resource or create new resource entry

# Commit and push
git add config/owner_mappings.json
git commit -m "feat: Assign ownership for new applications"
git push

# After PR merge, run the apply workflow
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false
```

### owner_mappings.json Structure

```json
{
  "assignments": {
    "apps": [
      {
        "resource_orn": "orn:okta:idp:org:apps:oauth2:0oa123",
        "resource_name": "Production App",
        "resource_type": "oauth2",
        "owners": [
          {
            "principal_orn": "orn:okta:directory:org:users:00u456",
            "principal_type": "user",
            "principal_name": "john.doe@example.com"
          }
        ]
      }
    ],
    "groups": [
      {
        "resource_orn": "orn:okta:directory:org:groups:00g789",
        "resource_name": "Engineering Team",
        "owners": [
          {
            "principal_orn": "orn:okta:directory:org:users:00u456",
            "principal_type": "user",
            "principal_name": "team.lead@example.com"
          }
        ]
      }
    ],
    "entitlement_bundles": [
      {
        "resource_orn": "orn:okta:governance:org:entitlement-bundles:enb012",
        "resource_name": "Admin Access Bundle",
        "owners": [
          {
            "principal_orn": "orn:okta:directory:org:users:00u456",
            "principal_type": "user",
            "principal_name": "security.admin@example.com"
          }
        ]
      }
    ]
  }
}
```

### Owner Types

- **User Ownership** - Individual users as resource owners
  - Format: `orn:okta:directory:<org>:users:<user-id>`
  - Use for: Direct ownership, small teams, personal responsibility

- **Group Ownership** - Delegated ownership to a group
  - Format: `orn:okta:directory:<org>:groups:<group-id>`
  - Use for: Team-based ownership, shared responsibility

### Workflows

```bash
# Sync owners from Okta (updates owner_mappings.json)
python3 scripts/sync_owner_mappings.py

# Sync specific resources only
python3 scripts/sync_owner_mappings.py --resource-orns \
  "orn:okta:idp:org:apps:oauth2:0oa123" \
  "orn:okta:directory:org:groups:00g456"

# Apply owners (dry-run first)
python3 scripts/apply_resource_owners.py --dry-run

# Apply owners (actual changes)
python3 scripts/apply_resource_owners.py

# Via GitHub Actions
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=true
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false
```

---

## 🏷️ Label Definitions

### Privileged
- **Purpose**: High-privilege access requiring enhanced monitoring and approval
- **Color**: Red (#FF0000)
- **Applied To**: Resources with "admin" in the name
- **Use Cases**:
  - Administrator accounts
  - Elevated permissions
  - System-level access

### Standard
- **Purpose**: Standard user access with normal approval workflows
- **Color**: Green (#00FF00)
- **Applied To**: Regular user access
- **Use Cases**:
  - Standard user permissions
  - Default access levels

### Sensitive-Data
- **Purpose**: Access to sensitive or regulated data (PII, PHI, financial)
- **Color**: Orange (#FFA500)
- **Applied To**: Resources handling sensitive information
- **Use Cases**:
  - HR system access
  - Financial data access
  - Customer PII access

### Compliance-Required
- **Purpose**: Access subject to compliance requirements (SOX, HIPAA, etc.)
- **Color**: Blue (#0000FF)
- **Applied To**: Resources requiring compliance oversight
- **Use Cases**:
  - Super admin access
  - Audit-critical systems
  - Regulated data access

## 🔍 Finding Admin Resources

Use the `find_admin_resources.py` script to scan Terraform configurations for resources with "admin" in the name:

```bash
# Scan and display results
python3 scripts/find_admin_resources.py --config-dir production-ready

# Scan and update api_config.json automatically
python3 scripts/find_admin_resources.py --config-dir production-ready --apply-labels

# Output as JSON for processing
python3 scripts/find_admin_resources.py --config-dir production-ready --json
```

### Example Output

```
================================================================================
ADMIN RESOURCE SCAN RESULTS
================================================================================

Total admin resources found: 4

CRITICAL PRIORITY:
--------------------------------------------------------------------------------
  📋 okta_principal_entitlements.okta_super_admin
     File: oig_entitlements.tf
     Recommended Labels: Privileged, Compliance-Required

HIGH PRIORITY:
--------------------------------------------------------------------------------
  📋 okta_principal_entitlements.salesforce_admin
     File: oig_entitlements.tf
     Recommended Labels: Privileged

  📋 okta_principal_entitlements.workday_admin
     File: oig_entitlements.tf
     Recommended Labels: Privileged

  📋 okta_principal_entitlements.aws_admin
     File: oig_entitlements.tf
     Recommended Labels: Privileged
```

## 🚀 Applying Labels to Okta

### Local Application (with credentials)

```bash
# Export Okta credentials
export OKTA_API_TOKEN="your-token-here"
export OKTA_ORG_NAME="your-org"
export OKTA_BASE_URL="okta.com"

# Apply labels from config
python3 scripts/okta_api_manager.py --action apply --config config/api_config.json

# Export current labels for review
python3 scripts/okta_api_manager.py --action export --export-labels --output labels_export.json
```

### GitHub Actions Workflow

Labels can be applied automatically via GitHub Actions:

1. **Trigger Workflow**: Go to Actions → "LowerDeckLabs - Export OIG Labels"
2. **Review Run**: The workflow will export current state and apply label changes
3. **Verify**: Check the workflow summary for applied labels

## 📝 Configuration File Structure

```json
{
  "labels": {
    "definitions": [
      {
        "name": "Privileged",
        "description": "High-privilege access",
        "color": "#FF0000"
      }
    ],
    "assignments": {
      "entitlements": {
        "resource_name_or_id": ["Privileged", "Compliance-Required"]
      },
      "apps": {},
      "groups": {}
    },
    "auto_labeling_rules": {
      "enabled": true,
      "rules": [
        {
          "pattern": ".*admin.*",
          "case_sensitive": false,
          "resource_types": ["entitlement", "app", "group"],
          "labels": ["Privileged"]
        }
      ]
    }
  },
  "resource_owners": {
    "assignments": []
  }
}
```

## 🔄 Workflow: From Terraform to Okta

### Step 1: Define Entitlements in Terraform

```hcl
# production-ready/oig_entitlements.tf
resource "okta_principal_entitlements" "salesforce_admin" {
  # Configuration here
}
```

### Step 2: Find Admin Resources

```bash
python3 scripts/find_admin_resources.py --config-dir production-ready --apply-labels
```

This automatically updates `config/api_config.json` with recommended labels.

### Step 3: Review Configuration

```bash
cat config/api_config.json
```

Verify the label assignments are correct.

### Step 4: Apply to Okta

**Option A: Local**
```bash
python3 scripts/okta_api_manager.py --action apply --config config/api_config.json
```

**Option B: GitHub Actions**
- Commit changes
- Trigger workflow manually
- Review and approve deployment

### Step 5: Verify in Okta

1. Log into Okta Admin Console
2. Navigate to **Identity Governance**
3. Check resource labels are applied correctly

## 🎯 Auto-Labeling Rules

The configuration supports pattern-based auto-labeling:

### Rule: Admin Resources → Privileged Label

```json
{
  "pattern": ".*admin.*",
  "case_sensitive": false,
  "resource_types": ["entitlement", "app", "group"],
  "labels": ["Privileged"]
}
```

**How it works:**
1. Scans Terraform resources for names matching pattern
2. Automatically recommends "Privileged" label
3. Applied when you run `find_admin_resources.py --apply-labels`

### Rule: Super Admin → Multiple Labels

```json
{
  "pattern": ".*super.*admin.*",
  "case_sensitive": false,
  "resource_types": ["entitlement"],
  "labels": ["Privileged", "Compliance-Required"]
}
```

Super admin access gets both Privileged and Compliance-Required labels for extra oversight.

## 🔐 Security Considerations

- **Label Changes**: All label changes are tracked in git history
- **Approval Required**: GitHub Actions workflow requires environment approval
- **Audit Trail**: Export before/after snapshots for compliance
- **Review Access**: Privileged labels should trigger enhanced access review frequency

## 🛠️ Troubleshooting

### Labels Not Showing in Okta

1. **Check API Token Scopes**: Ensure token has `okta.governance.labels.manage` scope
2. **Verify OIG Feature**: Confirm Identity Governance is enabled on your tenant
3. **Check Logs**: Review GitHub Actions logs for errors

### Auto-Labeling Not Working

1. **Pattern Matching**: Verify regex pattern matches your resource names
2. **Case Sensitivity**: Check if case_sensitive setting is correct
3. **Resource Types**: Ensure resource_types includes the type you're scanning

### Configuration Errors

```bash
# Validate JSON syntax
python3 -m json.tool config/api_config.json

# Test with dry-run (if implemented)
python3 scripts/okta_api_manager.py --action apply --config config/api_config.json --dry-run
```

## 📚 Related Documentation

- [API Management Guide](../docs/API_MANAGEMENT.md)
- [OIG Manual Import](../docs/OIG_MANUAL_IMPORT.md)
- [Okta Labels API](https://developer.okta.com/docs/api/iga/)

## ✅ Best Practices

1. **Scan Regularly**: Run `find_admin_resources.py` after adding new Terraform resources
2. **Review Labels**: Periodically review label assignments for accuracy
3. **Consistent Naming**: Use consistent naming conventions (e.g., `*_admin` for admin access)
4. **Multiple Labels**: Apply multiple labels when appropriate (e.g., Privileged + Compliance-Required)
5. **Document Changes**: Commit label config changes with descriptive messages
