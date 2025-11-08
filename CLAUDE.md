# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository demonstrates Okta Identity Governance (OIG) management using Terraform Provider v6.1.0 with Terraformer import support. It provides a complete infrastructure-as-code solution for managing Okta OIG resources, including access reviews, approval workflows, catalog entries, and entitlements.

**Key Architecture Components:**
1. **Terraform configurations** - OIG resources using Okta Terraform Provider v6.1.0
2. **Python API manager** - Handles Resource Owners and Labels (not yet in Terraform provider)
3. **Terraformer integration** - Imports existing Okta base resources (users, groups, apps, policies)
4. **GitHub Actions workflows** - CI/CD automation for Terraform and Terraformer operations

**Critical Limitation:** Terraformer does NOT support OIG resources. It only imports base resources (users, groups, apps, policies). OIG configurations must be created fresh using Terraform or manually imported (see docs/OIG_MANUAL_IMPORT.md).

## Common Development Commands

### Terraform Operations
```bash
# Initialize Terraform (from production-ready/ directory)
make init
# OR
cd terraform && terraform init

# Plan changes
make plan
# OR
cd terraform && terraform plan

# Apply changes
make apply
# OR
cd terraform && terraform apply

# Destroy resources
make destroy
# OR
cd terraform && terraform destroy

# Validate Terraform syntax
cd terraform && terraform validate

# Format Terraform files
cd terraform && terraform fmt -recursive
```

### Terraformer Import Operations
```bash
# Set required environment variables first
export OKTA_API_TOKEN="your-token"
export OKTA_ORG_NAME="your-org"
export OKTA_BASE_URL="okta.com"

# Import all supported BASE resources (users, groups, apps, policies)
./scripts/import_okta_resources.sh

# Import specific resource types
terraformer import okta --resources=okta_user,okta_group,okta_app_oauth

# Import with filtering
terraformer import okta --resources=okta_group --filter="okta_group=id1:id2:id3"

# NOTE: Terraformer does NOT support OIG resources
# For OIG resources (entitlements, reviews, sequences), use:
python3 scripts/import_oig_resources.py --output-dir imported_oig
# OR use the GitHub Actions workflow:
gh workflow run lowerdecklabs-import-oig.yml
```

### Python API Management
```bash
# Install Python dependencies
pip install -r requirements.txt

# Apply API-managed resources (Resource Owners & Labels)
python3 scripts/okta_api_manager.py --action apply --config config/api_config.json

# Destroy API-managed resources
python3 scripts/okta_api_manager.py --action destroy --config config/api_config.json

# Query resource owners
python3 scripts/okta_api_manager.py --action query --resource-type owners
```

### Cleanup and Refactoring
```bash
# Clean up imported Terraform code (removes tfer-- prefixes, null values, etc.)
python3 scripts/cleanup_terraform.py --input generated/okta --output cleaned

# Clean up generated files
make clean
# OR
rm -rf generated/ cleaned/ imported/
```

### Testing
```bash
# Run Python unit tests
make test
# OR
pytest tests/ -v

# Run specific test file
pytest tests/test_okta_api_manager.py -v

# Complete workflow test (creates, imports, verifies, cleans up)
./scripts/test_complete_workflow.sh

# Build test org resources
./scripts/build_test_org.sh

# Clean up test org resources
./scripts/cleanup_test_org.sh
```

## Code Architecture

### Directory Structure
```
production-ready/       # Production Terraform configurations
  apps/                # OAuth and SAML applications
  groups/              # Okta groups
  users/               # Okta users
  policies/            # Access policies
  auth_servers/        # Authorization servers
  provider.tf          # Okta provider setup
  variables.tf         # Input variables

scripts/               # Automation scripts
  okta_api_manager.py         # Python API manager for Owners & Labels
  apply_admin_labels.py       # Auto-label admin entitlements
  sync_label_mappings.py      # Sync label mappings from Okta
  validate_labels_api.py      # Validate Labels API integration
  import_okta_resources.sh    # Terraformer import wrapper
  cleanup_terraform.py        # Cleans imported Terraform code
  build_test_org.sh          # Creates test resources
  cleanup_test_org.sh        # Removes test resources
  test_complete_workflow.sh   # E2E testing
  archive/                    # Investigation scripts (reference only)

config/                # Configuration files
  api_config.json            # Legacy label config
  label_mappings.json        # Label ID mappings (source of truth)
  README.md                  # Label management guide

docs/                  # Comprehensive documentation
  COMPLETE_SOLUTION.md       # Full solution overview
  API_MANAGEMENT.md          # Python API manager guide
  TERRAFORMER.md             # Terraformer integration guide
  TESTING.md                 # Testing workflows
  PROJECT_STRUCTURE.md       # Repository structure
  TERRAFORMER_OIG_FAQ.md    # Common questions
  OIG_MANUAL_IMPORT.md      # Manual import procedures

.github/workflows/     # CI/CD automation
  terraform.yml        # Terraform plan/apply/destroy
  terraformer.yml      # Weekly imports and drift detection
```

### Terraform Resource Relationships

The OIG resources have specific dependencies that must be respected:

1. **Request Settings** (`okta_request_settings`) - Global configuration, created first
2. **Request Conditions** (`okta_request_conditions`) - Defines access conditions
3. **Request Sequences** (`okta_request_sequences`) - Approval workflows (can reference conditions)
4. **Catalog Entries** (`okta_catalog_entry_default`) - App catalog configuration (references sequences)
5. **Principal Entitlements** (`okta_principal_entitlements`) - Access definitions
6. **Reviews** (`okta_reviews`) - Access review campaigns (references entitlements)
7. **Requests** (`okta_request_v2`) - Programmatic access requests (references catalog entries)

### Python API Manager Architecture

The `okta_api_manager.py` script uses the OktaAPIManager class with these main capabilities:

**Resource Owners API:**
- `assign_resource_owners()` - Assign owners to apps/groups/entitlements
- `list_resource_owners()` - Query existing owners
- `update_resource_owners()` - PATCH operations for owner updates
- `remove_resource_owners()` - Remove owner assignments

**Labels API:**
- `create_label()` - Create governance label
- `apply_labels_to_resources()` - Apply labels to resources
- `list_labels()` - Query existing labels
- `delete_label()` - Remove label

**Key Features:**
- Automatic rate limit handling with retry logic
- Idempotent operations (safe to run multiple times)
- Bulk operations support
- ORN (Okta Resource Name) builders for proper resource references

### Integration with GitHub Actions

The OIG export functionality is integrated with GitHub Actions workflows:

1. GitHub Actions workflow triggers OIG export
2. Workflow calls `okta_api_manager.py` with appropriate arguments
3. Python script exports labels, entitlements, and resource owners
4. Script generates JSON export with status tracking
5. Artifacts uploaded for download and review

## Important Development Guidelines

### Working with OIG Resources

When modifying OIG resources in Terraform:
- Respect the dependency order listed above
- Use `depends_on` when implicit dependencies aren't clear
- Test with `terraform plan` before applying
- OIG resources are NEW in v6.1.0 - check provider docs for latest changes

### Working with Terraformer

When importing existing BASE resources (users, groups, apps, policies):
- ALWAYS run cleanup script after import: `python3 scripts/cleanup_terraform.py`
- Terraformer adds `tfer--` prefixes - cleanup script removes these
- Generated code may have null values and computed attributes - cleanup script handles this
- Terraformer creates separate directories per resource type - organize as needed
- Remember: OIG resources CANNOT be imported with Terraformer

### Working with OIG Resource Import

When importing OIG resources (entitlements, reviews, approval sequences):
- Use `scripts/import_oig_resources.py` or the GitHub Actions workflow
- Terraformer does NOT support OIG resources
- The import script queries the Okta API directly and generates Terraform configurations
- Generated .tf files include TODO comments for manual configuration
- JSON exports provide full API response data for reference

```bash
# Import OIG resources locally
python3 scripts/import_oig_resources.py --output-dir imported_oig

# Via GitHub Actions (recommended)
gh workflow run lowerdecklabs-import-oig.yml

# Import and auto-update production files
gh workflow run lowerdecklabs-import-oig.yml -f update_terraform=true
```

**Key differences from Terraformer:**
- Direct API queries instead of Terraform provider import
- Generates skeleton configurations that need manual completion
- Provides JSON exports for reference
- No automatic state management (must run `terraform import` manually)
- Only supports OIG-specific resources

### Working with API Manager

When modifying `okta_api_manager.py`:
- Maintain backward compatibility with existing config files
- Add comprehensive error handling for all API calls
- Use the `_make_request()` helper for consistent retry/rate-limit handling
- Test idempotency - script should be safe to run multiple times
- Update docs/API_MANAGEMENT.md when adding new capabilities

### Working with Label Management

**New PR-based workflow for managing label assignments:**

#### Syncing Labels from Okta
```bash
# Sync current label mappings from Okta
python3 scripts/sync_label_mappings.py

# This updates config/label_mappings.json with:
# - Label IDs and label value IDs
# - Current assignments by resource type
# - Metadata (colors, descriptions)
```

#### Adding Label Assignments
```bash
# 1. Edit config/label_mappings.json
# Add ORN to appropriate label array under assignments

# 2. Commit and create PR
git add config/label_mappings.json
git commit -m "feat: Add Privileged label to new admin role"
git push

# 3. After PR merge, apply via GitHub Actions workflow
```

#### Auto-Labeling Admin Entitlements
```bash
# Find and label all entitlements with "admin" in name
python3 scripts/apply_admin_labels.py

# Dry run mode (preview changes)
python3 scripts/apply_admin_labels.py --dry-run
```

#### Key Files
- `config/label_mappings.json` - Source of truth for label IDs and assignments
- `scripts/sync_label_mappings.py` - Sync mappings from Okta
- `scripts/apply_admin_labels.py` - Auto-label admin entitlements
- `scripts/validate_labels_api.py` - Validate API integration

#### Important Notes
- Always sync before making changes to get latest labelIds
- Label operations use `/resource-labels/assign` endpoint
- Batch requests in groups of 10 (API limit)
- Use `labelValueId` not `labelId` for filtering

### Working with Resource Owner Management

**New PR-based workflow for managing resource owner assignments:**

#### Syncing Resource Owners from Okta
```bash
# Sync current owner assignments from Okta (all resources)
python3 scripts/sync_owner_mappings.py

# Sync specific resources only
python3 scripts/sync_owner_mappings.py --resource-orns \
  "orn:okta:idp:org:apps:oauth2:0oa123" \
  "orn:okta:directory:org:groups:00g456"

# This updates config/owner_mappings.json with:
# - Current owner assignments by resource type
# - Principal ORNs and names
# - Resource metadata
```

#### Adding/Modifying Owner Assignments
```bash
# 1. Edit config/owner_mappings.json
# Add or modify owners for resources

# 2. Commit and create PR
git add config/owner_mappings.json
git commit -m "feat: Assign owners to production applications"
git push

# 3. After PR merge, apply via GitHub Actions workflow
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false
```

#### Applying Resource Owners
```bash
# Preview changes (dry-run)
python3 scripts/apply_resource_owners.py --dry-run

# Apply owner assignments
python3 scripts/apply_resource_owners.py

# Via GitHub Actions
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=true
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false
```

#### Key Files
- `config/owner_mappings.json` - Source of truth for resource owner assignments
- `scripts/sync_owner_mappings.py` - Sync owner mappings from Okta
- `scripts/apply_resource_owners.py` - Apply owner assignments to Okta
- `.github/workflows/lowerdecklabs-apply-owners.yml` - Apply owners workflow
- `.github/workflows/lowerdecklabs-export-oig.yml` - Export owners workflow

#### Owner ORN Formats
- **User owners**: `orn:okta:directory:<org>:users:<user-id>`
- **Group owners**: `orn:okta:directory:<org>:groups:<group-id>`
- **App resources**: `orn:okta:idp:<org>:apps:<type>:<app-id>`
- **Group resources**: `orn:okta:directory:<org>:groups:<group-id>`
- **Entitlement bundles**: `orn:okta:governance:<org>:entitlement-bundles:<bundle-id>`

#### Important Notes
- Always sync before making changes to get current state
- Owner operations use `PUT /governance/api/v1/resource-owners` endpoint
- Owners are critical for access reviews and approval workflows
- Both user and group ownership are supported
- Multiple owners can be assigned to a single resource

### State Management

- Backend is configured in `production-ready/backend.tf` (comment out for local development)
- Update backend configuration for your environment before first use
- State files from Terraformer imports are stored in `generated/okta/*/terraform.tfstate`
- After cleanup, state should be consolidated into main state file
- Never commit state files or `terraform.tfvars` to git

### Testing Changes

Before committing changes:
1. Run `terraform validate` to check syntax
2. Run `terraform plan` to verify expected changes
3. Test Python scripts with `pytest tests/`
4. Run `terraform fmt -recursive` to format code
5. Test complete workflow in non-production org if possible

### Environment Variables

Required for Terraform operations:
- `OKTA_API_TOKEN` - API token with appropriate scopes
- `OKTA_ORG_NAME` - Okta org name (e.g., "dev-12345678")
- `OKTA_BASE_URL` - Base URL (e.g., "okta.com" or "oktapreview.com")

Can be set via:
- Environment variables (for scripts and CLI)
- `terraform.tfvars` file (for Terraform)
- GitHub Secrets (for CI/CD)

### Required Okta API Permissions

API token needs these scopes:
- `okta.groups.manage`
- `okta.users.manage`
- `okta.apps.manage`
- `okta.governance.accessRequests.manage`
- `okta.governance.accessReviews.manage`
- `okta.governance.catalogs.manage`

## Workflow Scenarios

### Scenario 1: Greenfield (New Okta Org)
```bash
# 1. Configure variables
cd terraform && cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 2. Initialize and apply
terraform init
terraform plan
terraform apply

# 3. API-managed resources are applied automatically via provisioners
```

### Scenario 2: Brownfield (Existing Okta Org)
```bash
# 1. Import existing base resources
export OKTA_API_TOKEN="token"
export OKTA_ORG_NAME="org"
export OKTA_BASE_URL="okta.com"
./scripts/import_okta_resources.sh

# 2. Clean up imported code
python3 scripts/cleanup_terraform.py --input generated/okta --output cleaned

# 3. Add OIG configuration (create fresh, not imported)
cd cleaned
cp ../production-ready/apps/okta_app_oauth.tf ./
terraform init
terraform plan
terraform apply
```

### Scenario 3: Adding New OIG Resource Type

When adding support for a new OIG resource:
1. Add resource definition to appropriate `.tf` file in `production-ready/`
2. Update `variables.tf` if new variables needed
3. Update `api_config.json` structure if API integration needed
4. Update `okta_api_manager.py` if new API endpoints needed
5. Add examples to `advanced-oig-examples.tf`
6. Update documentation in `docs/`
7. Add tests to `tests/`

## Common Patterns

### Creating Access Review Campaigns
```hcl
resource "okta_reviews" "quarterly_review" {
  name        = "Quarterly Access Review"
  description = "Review all application access quarterly"

  schedule {
    frequency = "QUARTERLY"
    timezone  = "America/New_York"
  }

  scope {
    resource_type = "APP"
    resource_ids  = [okta_app_oauth.demo_app.id]
  }

  reviewers {
    type = "RESOURCE_OWNER"
  }
}
```

### Creating Approval Workflows
```hcl
resource "okta_request_sequences" "multi_stage_approval" {
  name = "Multi-Stage Approval"

  stages {
    approvers {
      type = "MANAGER"
    }
  }

  stages {
    approvers {
      type = "RESOURCE_OWNER"
    }
  }
}
```

### Assigning Resource Owners via Python
```python
# In api_config.json
{
  "resource_owners": {
    "principals": ["orn:okta:user:00u1a2b3c4d5e6f7g8h9"],
    "resources": [
      "orn:okta:app:00a1b2c3d4e5f6g7h8i9:oauth2",
      "orn:okta:directory:00g1a2b3c4d5e6f7g8h9:group"
    ]
  }
}
```

## Troubleshooting Tips

- **Terraformer import fails:** Check environment variables are set correctly
- **Rate limit errors:** Script has built-in retry logic, but may need to wait
- **State conflicts:** Run `terraform refresh` to sync state with actual resources
- **OIG resources not found in import:** This is expected - Terraformer doesn't support OIG
- **Python script errors:** Check `requirements.txt` dependencies are installed
- **Approval workflows not working:** Ensure request_settings is created first

## Additional Resources

- Okta Terraform Provider Docs: https://registry.terraform.io/providers/okta/okta/latest/docs
- Terraformer Documentation: https://github.com/GoogleCloudPlatform/terraformer
- Okta OIG API Docs: Check Okta developer documentation for governance APIs
- Project Documentation: See `docs/` directory for comprehensive guides
