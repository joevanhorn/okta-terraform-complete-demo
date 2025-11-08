# Environments

This directory contains environment-specific Okta configurations organized by tenant.

## Directory Structure

```
environments/
├── lowerdecklabs/      # Primary demo tenant (oktapreview.com)
│   ├── terraform/      # Terraform configurations (.tf files)
│   ├── imports/        # Raw API import data (.json files)
│   └── config/         # Resource owners, labels, and API configs
├── production/         # Production tenant
│   ├── terraform/
│   ├── imports/
│   └── config/
├── staging/            # Staging tenant
│   ├── terraform/
│   ├── imports/
│   └── config/
└── development/        # Development tenant
    ├── terraform/
    ├── imports/
    └── config/
```

## What Goes Where

### `/terraform/`
Terraform configuration files for managing OIG resources:
- `oig_entitlements.tf` - Entitlement bundle definitions
- `oig_reviews.tf` - Access review campaigns
- `oig_request_sequences.tf` - Approval workflows
- `oig_catalog_entries.tf` - Catalog entries
- `oig_request_settings.tf` - Request settings

**NOTE:** These manage the DEFINITION of resources, not assignments. Principal assignments (grants) should be managed in Okta Admin UI.

### `/imports/`
Raw JSON data from API imports for reference and auditing:
- `entitlements.json` - Entitlement bundles API response
- `reviews.json` - Access reviews API response
- `request_sequences.json` - Approval workflows API response
- `catalog_entries.json` - Catalog entries API response

### `/config/`
Configuration files for API-only resources:
- `owner_mappings.json` - Resource ownership assignments
- `label_mappings.json` - Governance label assignments
- `api_config.json` - Legacy API configuration

## Workflows

The **"Existing Tenant - Import All Resources"** workflow automatically organizes imports by environment:

```bash
gh workflow run import-all-resources.yml \
  -f tenant_environment=LowerDeckLabs \
  -f update_terraform=true \
  -f commit_changes=true
```

This will populate the corresponding environment directory with:
- Terraform configurations in `terraform/`
- Import data in `imports/`
- Config files in `config/`

## Environment Details

### LowerDeckLabs
- **Purpose:** Primary demo and testing tenant
- **Domain:** lowerdecklabs.oktapreview.com
- **GitHub Environment:** LowerDeckLabs
- **Current Resources:**
  - 31 entitlement bundles
  - 200 access review campaigns
  - 2 governance labels

### Production
- **Purpose:** Production tenant
- **Domain:** TBD
- **GitHub Environment:** Production
- **Status:** Not yet configured

### Staging
- **Purpose:** Staging/pre-production tenant
- **Domain:** TBD
- **GitHub Environment:** Staging
- **Status:** Not yet configured

### Development
- **Purpose:** Development tenant
- **Domain:** TBD
- **GitHub Environment:** Development
- **Status:** Not yet configured

## Working with Multiple Environments

### Import from Specific Environment
```bash
# Import from LowerDeckLabs
gh workflow run import-all-resources.yml -f tenant_environment=LowerDeckLabs

# Import from Production
gh workflow run import-all-resources.yml -f tenant_environment=Production
```

### Apply Terraform for Specific Environment
```bash
cd environments/lowerdecklabs/terraform
terraform init
terraform plan
terraform apply
```

### Sync Resource Owners for Specific Environment
```bash
# Sync from LowerDeckLabs
python3 scripts/sync_owner_mappings.py \
  --output environments/lowerdecklabs/config/owner_mappings.json

# Apply to LowerDeckLabs
python3 scripts/apply_resource_owners.py \
  --config environments/lowerdecklabs/config/owner_mappings.json
```

## Best Practices

1. **One Environment Per Workflow Run** - Don't mix resources from different environments
2. **Use GitHub Environments** - Leverage environment-specific secrets and approvals
3. **Review Before Applying** - Always run `terraform plan` before `terraform apply`
4. **Keep Configs Synced** - Regularly sync owners and labels from Okta
5. **Backup Before Changes** - Workflows automatically create timestamped backups

## Migration from Legacy Structure

Previous structure:
- `production-ready/` - Mixed configurations
- `config/` - Global config files

New structure:
- `environments/<env>/terraform/` - Environment-specific Terraform
- `environments/<env>/config/` - Environment-specific configs

Legacy files will be migrated automatically by workflows.
