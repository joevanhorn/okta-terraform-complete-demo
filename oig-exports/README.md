# OIG Exports - API-Only Resources

This directory contains exported OIG (Okta Identity Governance) resources that **cannot be managed in Terraform** and are handled via API for documentation and drift detection.

## 🎯 What's Included

### API-Only Resources (No Terraform Support)
- **Labels** - Governance labels for categorizing resources
- **Resource Owners** - Owner assignments for resources

### Read-Only Documentation
- **App-Managed Entitlements** - Synced from provisioning apps (Salesforce, Workday, etc.)
  - These are READ-ONLY
  - Cannot be created or modified manually
  - Exported for documentation purposes only

## ⚠️ What's NOT Included (Manage in Terraform)

These resources ARE supported by Terraform and should be managed there:
- ❌ **Manual Entitlements** - Use `okta_principal_entitlements` in `production-ready/governance/`
- ❌ **Access Reviews** - Use `okta_reviews`
- ❌ **Request Workflows** - Use `okta_request_*`
- ❌ **Resource Catalog** - Use `okta_catalog_*`
- ❌ **Resource Sets** - Use `okta_resource_set`

See `production-ready/governance/` for Terraform-managed OIG resources.

## Directory Structure

```
oig-exports/
├── lowerdecklabs/           # LowerDeckLabs tenant exports
│   ├── latest.json         # Most recent export (symlink or copy)
│   └── YYYY-MM-DD.json     # Historical exports by date
│
└── <other-environments>/   # Other tenant exports
    ├── latest.json
    └── YYYY-MM-DD.json
```

## Export Contents

Each JSON file contains:

```json
{
  "export_date": "2025-11-07T01:59:19Z",
  "okta_org": "demo-lowerdecklabs",
  "okta_base_url": "oktapreview.com",
  "export_status": {
    "labels": "success|not_available|error",
    "entitlements": "success",
    "resource_owners": "skipped|success"
  },
  "labels": [...],
  "entitlements": [
    {
      "id": "ent_abc123",
      "name": "Salesforce - Sales User Profile",
      "_category": "app-managed",
      "resource": {
        "orn": "orn:okta:idp:demo-lowerdecklabs:apps:saml2:salesforce123"
      }
    }
  ],
  "resource_owners": [...],
  "entitlement_categories": {
    "app_managed_count": 450,
    "manual_count": 339,
    "unknown_count": 0,
    "manual_managed_in_terraform": true
  },
  "entitlement_notes": {
    "app_managed_only": true,
    "manual_filtered_count": 339,
    "manual_management": "Manual entitlements should be managed in Terraform using okta_principal_entitlements"
  }
}
```

### Entitlement Filtering

⚠️ **Important**: This export now ONLY includes **app-managed entitlements**.

**App-Managed Entitlements** (included in export):
- ✅ Synced from provisioning-enabled applications
- ✅ Examples: Salesforce profiles, Workday permissions, ServiceNow roles
- ✅ Read-only - cannot be modified manually
- ✅ Identified by resource ORN containing `:apps:`
- ✅ Exported for documentation purposes

**Manual/Custom Entitlements** (NOT in export):
- ❌ NOT exported here
- ✅ Should be managed in Terraform using `okta_principal_entitlements`
- ✅ See `production-ready/governance/entitlements.tf`
- ✅ Can be created and managed via Terraform

### Category Summary

The `entitlement_categories` object shows counts for ALL entitlements (including filtered ones):
- `app_managed_count` - App-managed entitlements (included in export)
- `manual_count` - Manual entitlements (filtered out, manage in Terraform)
- `unknown_count` - Unknown category entitlements (filtered out)
- `manual_managed_in_terraform` - Flag indicating manual entitlements are managed elsewhere

## Usage

### View Current State

```bash
# View latest export
cat oig-exports/lowerdecklabs/latest.json | jq '.'

# Count entitlements
cat oig-exports/lowerdecklabs/latest.json | jq '.entitlements | length'

# View export status
cat oig-exports/lowerdecklabs/latest.json | jq '.export_status'

# View entitlement categorization summary
cat oig-exports/lowerdecklabs/latest.json | jq '.entitlement_categories'
```

### Query Categorized Entitlements

```bash
# List all app-managed entitlements (synced from apps)
cat oig-exports/lowerdecklabs/latest.json | \
  jq '.entitlements[] | select(._category == "app-managed") | {name, id, resource: .resource.orn}'

# List all manual/custom entitlements
cat oig-exports/lowerdecklabs/latest.json | \
  jq '.entitlements[] | select(._category == "manual") | {name, id}'

# Count by category
cat oig-exports/lowerdecklabs/latest.json | \
  jq '.entitlements | group_by(._category) | map({category: .[0]._category, count: length})'

# Find all Salesforce entitlements
cat oig-exports/lowerdecklabs/latest.json | \
  jq '.entitlements[] | select(.resource.orn | contains("salesforce")) | {name, category: ._category}'
```

### Detect Drift

```bash
# Compare with previous export
diff oig-exports/lowerdecklabs/2025-11-06.json oig-exports/lowerdecklabs/latest.json

# Or use jq for structured comparison
diff \
  <(cat oig-exports/lowerdecklabs/2025-11-06.json | jq -S '.entitlements') \
  <(cat oig-exports/lowerdecklabs/latest.json | jq -S '.entitlements')
```

### Git History

```bash
# View changes over time
git log --follow oig-exports/lowerdecklabs/

# See what changed in last commit
git show HEAD:oig-exports/lowerdecklabs/latest.json
```

## Workflow

The export workflow runs:
- **Manually**: Via GitHub Actions
- **Automatically**: Updates this directory with latest export
- **Commits**: Creates a commit with export results

### Commit Message Format

```
feat(oig): Export OIG resources for lowerdecklabs

- Entitlements: 789 (success)
  - App-managed (synced): 450
  - Manual/Custom (BYO): 339
- Labels: 0 (not_available)

Export date: 2025-11-07
Workflow run: 43
```

The commit message automatically includes:
- Total entitlement count with export status
- Breakdown of app-managed vs manually created entitlements
- Label count and status
- Export date and workflow run number

## Security Notes

⚠️ **These files contain tenant configuration:**
- Entitlement assignments
- Resource owner mappings
- Governance labels
- User/group ORNs (Okta Resource Names)

✅ **Safe to commit** because:
- Read-only export (no secrets or credentials)
- Configuration data, not sensitive PII
- Useful for audit trail and drift detection

❌ **Do NOT commit** if your exports include:
- API tokens or credentials
- Sensitive PII beyond basic ORNs
- Custom fields with confidential data

## Automation

Exports are automatically updated by the GitHub Actions workflow:
- `.github/workflows/lowerdecklabs-export-oig.yml`

The workflow:
1. Runs export via `scripts/okta_api_manager.py`
2. Copies export to `oig-exports/<tenant>/`
3. Creates `latest.json` and dated backup
4. Commits changes to repository
5. Still uploads as artifact for backup

## Best Practices

1. **Review exports** before merging PRs
2. **Document significant changes** in commit messages
3. **Keep historical exports** for trend analysis
4. **Run exports regularly** (weekly/monthly) for drift detection
5. **Compare exports** before major changes to tenant

## Terraform Support for Entitlements

### Available Since Terraform Provider v6.1.0

The Terraform Okta provider now supports managing entitlements using the `okta_entitlement` resource. However, **only manual/custom entitlements can be managed in Terraform**.

### Which Entitlements Can Be Managed in Terraform?

Use the `_category` field to determine this:

✅ **Manual entitlements** (`_category: "manual"`):
- Can be managed as `okta_entitlement` Terraform resources
- Created via entitlement bundles or API
- Fully editable in Terraform

❌ **App-managed entitlements** (`_category: "app-managed"`):
- CANNOT be managed in Terraform
- Synced from provisioning-enabled applications (Salesforce, Workday, etc.)
- Read-only - structure and values controlled by the app
- Should only be documented via API exports

### Example: Converting Manual Entitlements to Terraform

```bash
# 1. Export current entitlements
cat oig-exports/lowerdecklabs/latest.json | \
  jq '.entitlements[] | select(._category == "manual")' > manual_entitlements.json

# 2. Use these as reference for creating okta_entitlement resources
# Example Terraform resource:
```

```hcl
resource "okta_entitlement" "custom_access_bundle" {
  name        = "Custom Access Bundle"
  description = "Manually managed entitlement for special access"

  # Additional configuration based on your entitlement structure
}
```

### Why This Categorization Matters

1. **Hybrid Approach**: Manage manual entitlements in Terraform, document app-managed ones via exports
2. **Avoid Conflicts**: Prevents attempting to manage read-only app-synced entitlements in Terraform
3. **Clear Ownership**: Shows which entitlements are under your control vs managed by apps
4. **Import Strategy**: Helps identify which entitlements to import into Terraform state

### Recommended Workflow

1. **Export all entitlements** to understand current state
2. **Identify manual entitlements** using `_category: "manual"`
3. **Create Terraform resources** for manual entitlements you want to manage
4. **Keep app-managed entitlements** in exports only (documentation)
5. **Use drift detection** to compare Terraform state vs API reality

---

Last updated: 2025-11-07
