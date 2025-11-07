# GitHub Actions Workflows

This document describes all GitHub Actions workflows in this repository.

## Active Production Workflows

### LowerDeckLabs - Apply Admin Labels
**File:** `.github/workflows/lowerdecklabs-apply-admin-labels.yml`

**Purpose:** Automatically finds and labels admin entitlements with the "Privileged" label

**Trigger:** Manual (`workflow_dispatch`)

**Parameters:**
- `dry_run` - Set to `true` to preview changes without applying (default: `true`)

**What It Does:**
1. Queries all entitlement bundles from Okta
2. Filters for bundles with "admin" in name or description
3. Applies "Privileged" label to matching resources
4. Supports batching for API limits (10 resources per request)

**Usage:**
```bash
# Dry run
gh workflow run lowerdecklabs-apply-admin-labels.yml -f dry_run=true

# Apply labels
gh workflow run lowerdecklabs-apply-admin-labels.yml -f dry_run=false
```

**Results:** Creates 16 admin entitlements labeled as Privileged

---

### LowerDeckLabs - Validate Labels API
**File:** `.github/workflows/lowerdecklabs-validate-labels.yml`

**Purpose:** Validates the Labels API integration and verifies label assignments

**Trigger:** Manual (`workflow_dispatch`)

**What It Does:**
1. Tests API connection
2. Lists all labels with their IDs
3. Retrieves individual label details
4. Queries resources assigned to each label
5. Validates data structure
6. Compares with exported data

**Usage:**
```bash
gh workflow run lowerdecklabs-validate-labels.yml
```

**Validation Checks:**
- ✅ API connectivity
- ✅ Label enumeration
- ✅ Label detail retrieval
- ✅ Resource-label queries
- ✅ Data structure validation

---

### LowerDeckLabs - Export OIG Resources
**File:** `.github/workflows/lowerdecklabs-export-oig.yml`

**Purpose:** Exports OIG API-only resources (Labels and Resource Owners) to JSON

**Trigger:** Manual (`workflow_dispatch`)

**Parameters:**
- `export_labels` - Export governance labels (default: `true`)
- `export_owners` - Export resource owners (default: `false`)

**What It Does:**
1. Exports current labels and their assignments
2. Optionally exports resource owner assignments
3. Saves to `oig-exports/{environment}/latest.json`
4. Creates timestamped backup
5. Commits to repository

**Usage:**
```bash
# Export labels only
gh workflow run lowerdecklabs-export-oig.yml

# Export labels and owners
gh workflow run lowerdecklabs-export-oig.yml -f export_owners=true
```

**Output:** JSON file in `oig-exports/lowerdecklabs/`

---

### LowerDeckLabs - Import Okta Resources
**File:** `.github/workflows/lowerdecklabs-import.yml`

**Purpose:** Imports existing Okta base resources using Terraformer

**Trigger:** Manual (`workflow_dispatch`) or scheduled (weekly)

**What It Does:**
1. Runs Terraformer to import existing Okta resources
2. Generates Terraform configuration files
3. Cleans up and refactors generated code
4. Detects drift from previous state
5. Creates detailed import report

**Supported Resources:**
- Users
- Groups
- Apps (OAuth, SAML, etc.)
- Policies
- Authorization servers

**Note:** OIG resources are NOT supported by Terraformer

---

### LowerDeckLabs - Governance Setup
**File:** `.github/workflows/lowerdecklabs-governance-setup.yml`

**Purpose:** Initial setup of OIG governance features

**Trigger:** Manual (`workflow_dispatch`)

**What It Does:**
1. Creates initial OIG configuration
2. Sets up entitlements
3. Configures access reviews
4. Initializes catalog entries

**Usage:** Run once for initial setup

---

## Investigation/Development Workflows

These workflows were used during development and are kept for reference:

### LowerDeckLabs - Investigate Labels API
**File:** `.github/workflows/lowerdecklabs-investigate-labels-api.yml`

**Purpose:** Deep investigation of Labels API to troubleshoot 405 errors

**Status:** Investigation complete. Findings documented in `scripts/archive/README.md`

**Key Findings:**
- Labels API uses `labelId` not `name` in URLs
- Resource queries use `/resource-labels` with filter parameter
- Must use `labelValueId` for filtering, not `labelId`

---

### LowerDeckLabs - Test Label Endpoints
**File:** `.github/workflows/lowerdecklabs-test-label-endpoints.yml`

**Purpose:** Test various endpoint patterns to find correct API syntax

**Status:** Investigation complete. Correct endpoint identified as `POST /resource-labels/assign`

---

### LowerDeckLabs - Apply Labels (Legacy)
**File:** `.github/workflows/lowerdecklabs-apply-labels.yml`

**Purpose:** Original label application workflow

**Status:** Superseded by `lowerdecklabs-apply-admin-labels.yml`

---

## Workflow Dependencies

### Environment Secrets Required

All workflows require these secrets to be configured in the `LowerDeckLabs` GitHub environment:

- `OKTA_API_TOKEN` - API token with governance scopes
- `OKTA_ORG_NAME` - Okta organization name
- `OKTA_BASE_URL` - Base URL (e.g., `okta.com`)

### Permissions

Workflows use these permissions:
- `contents: write` - For committing export files
- `actions: read` - For workflow information

## Workflow Patterns

### Standard Workflow Structure

Most workflows follow this pattern:

1. **Safety Check** - Display environment and operation details
2. **Checkout** - Get latest code
3. **Setup** - Install Python, dependencies
4. **Execute** - Run the main operation
5. **Results** - Parse and display results
6. **Artifacts** - Upload logs and outputs
7. **Summary** - Post GitHub step summary

### Error Handling

- All workflows capture full logs
- Artifacts retained for 30-90 days
- Detailed summaries posted to workflow run
- Failed steps clearly marked

## Best Practices

1. **Always dry-run first** - For workflows with dry-run mode
2. **Review artifacts** - Check uploaded logs for details
3. **Monitor summaries** - GitHub step summaries show key results
4. **Use manual triggers** - Most workflows are manual to prevent accidents
5. **Check permissions** - Ensure environment secrets are configured

## Adding New Workflows

When creating new workflows:

1. Use the `LowerDeckLabs` environment
2. Follow the standard structure pattern
3. Include comprehensive error handling
4. Upload artifacts for debugging
5. Post detailed summaries
6. Document in this file
7. Add appropriate triggers

## Troubleshooting

### Workflow Won't Run
- Check environment is configured
- Verify secrets are set
- Ensure proper permissions

### API Errors
- Verify API token has correct scopes
- Check rate limiting
- Review artifact logs for details

### Unexpected Results
- Download artifacts for full logs
- Check step summaries for errors
- Compare with expected output in documentation

## Related Documentation

- [Labels API Validation](./LABELS_API_VALIDATION.md)
- [API Management Guide](./API_MANAGEMENT.md)
- [OIG Manual Import](./OIG_MANUAL_IMPORT.md)
- [Config README](../config/README.md)
