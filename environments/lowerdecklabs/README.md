# LowerDeckLabs Environment

Primary demo and testing tenant for Okta Identity Governance (OIG).

## Environment Details

- **Tenant:** lowerdecklabs.oktapreview.com
- **GitHub Environment:** LowerDeckLabs
- **Purpose:** Primary demo, development, and testing
- **Last Import:** 2025-11-08

## Current Resources

| Resource Type | Count | File |
|--------------|-------|------|
| Entitlement Bundles | 31 | `terraform/oig_entitlements.tf` |
| Access Reviews | 200 | `terraform/oig_reviews.tf` |
| Governance Labels | 2 | `config/label_mappings.json` |
| Resource Owners | 3 | `config/owner_mappings.json` |

## Directory Structure

```
lowerdecklabs/
├── terraform/              # Terraform configurations
│   ├── oig_entitlements.tf    # 31 entitlement bundle definitions
│   └── oig_reviews.tf         # 200 access review campaigns
├── imports/                # Raw API import data
│   ├── entitlements.json      # Entitlement bundles API response
│   └── reviews.json           # Access reviews API response
└── config/                 # Configuration files
    ├── label_mappings.json    # Governance labels
    ├── owner_mappings.json    # Resource owners
    └── api_config.json        # API configuration
```

## Quick Start

### Import Latest from Okta
```bash
gh workflow run import-all-resources.yml \
  -f tenant_environment=LowerDeckLabs \
  -f update_terraform=true \
  -f commit_changes=true
```

### Apply Terraform
```bash
cd environments/lowerdecklabs/terraform
terraform init
terraform plan
terraform apply
```

### Sync Resource Owners
```bash
# Sync from Okta
python3 scripts/sync_owner_mappings.py \
  --output environments/lowerdecklabs/config/owner_mappings.json

# Apply to Okta
python3 scripts/apply_resource_owners.py \
  --config environments/lowerdecklabs/config/owner_mappings.json
```

### Sync Governance Labels
```bash
# Sync from Okta
python3 scripts/sync_label_mappings.py \
  --output environments/lowerdecklabs/config/label_mappings.json

# Apply labels to resources
python3 scripts/apply_admin_labels.py
```

## Terraform Resources

### Entitlement Bundles (`oig_entitlements.tf`)

Manages the **definitions** of entitlement bundles. Example:

```hcl
resource "okta_entitlement_bundle" "datadog_read_only" {
  name = "Datadog Read Only"
  target_resource_orn = "orn:okta:governance:..."
  status = "ACTIVE"

  target {
    external_id = "0oanitkncxGbbNwrl1d7"
    type        = "APPLICATION"
  }

  entitlements {
    id = "esp12zbv44vDNoeIU1d7"
    values {
      id = "ent12zbv46MO7EWrw1d7"
    }
  }
}
```

**IMPORTANT:** This manages bundle DEFINITIONS only. Principal assignments (which users/groups have the bundles) are managed in Okta Admin UI.

### Access Reviews (`oig_reviews.tf`)

Access review campaign configurations. Most are skeleton configurations that need manual completion:

```hcl
resource "okta_reviews" "quarterly_review" {
  name = "Quarterly Access Review"

  # TODO: Add schedule, scope, and reviewer configuration
  # See: https://registry.terraform.io/providers/okta/okta/latest/docs/resources/reviews
}
```

## API-Only Resources

These resources cannot be managed in Terraform and are configured via JSON files:

### Resource Owners (`config/owner_mappings.json`)

Assigns owners to apps, groups, and entitlement bundles for governance workflows.

```json
{
  "apps": {
    "orn:okta:idp:org:apps:oauth2:0oa...": {
      "owners": ["orn:okta:directory:org:users:00u..."]
    }
  }
}
```

### Governance Labels (`config/label_mappings.json`)

Labels for categorizing and filtering resources in governance workflows.

```json
{
  "labels": [
    {
      "id": "lbl...",
      "name": "Privileged",
      "type": "OKTA_ACCESS_CERTIFICATION"
    }
  ]
}
```

## Workflows

### Import All Resources
**Workflow:** `import-all-resources.yml`

Imports all OIG resources from this tenant:
1. Entitlement bundles → `terraform/`
2. Access reviews → `terraform/`
3. Resource owners → `config/`
4. Governance labels → `config/`

### Export OIG Resources
**Workflow:** `export-oig.yml`

Exports labels and resource owners to JSON for backup/audit.

```bash
gh workflow run export-oig.yml \
  -f environment=lowerdecklabs \
  -f export_labels=true \
  -f export_owners=true
```

### Apply Resource Owners
**Workflow:** `apply-owners.yml`

Applies resource owner assignments from `config/owner_mappings.json`.

```bash
gh workflow run apply-owners.yml \
  -f environment=lowerdecklabs \
  -f dry_run=false
```

## Notes

- **Principal Assignments:** Do NOT manage user/group assignments in Terraform. Use Okta Admin UI or API.
- **Backups:** Workflows create timestamped backups before overwriting files.
- **Drift:** Run import regularly to detect configuration drift.
- **Testing:** This is a preview tenant - safe for testing and experimentation.

## Related Documentation

- [Main Environments README](../README.md)
- [OIG Import Guide](../../docs/OIG_MANUAL_IMPORT.md)
- [API Management Guide](../../docs/API_MANAGEMENT.md)
- [Terraform Provider Docs](https://registry.terraform.io/providers/okta/okta/latest/docs)
