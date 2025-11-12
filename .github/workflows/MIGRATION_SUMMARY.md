# Workflow Migration Summary

This document summarizes the migration from environment-specific workflows to environment-agnostic workflows.

## Overview

All workflows have been refactored to support multiple environments (lowerdecklabs, production, staging, development) instead of being hardcoded to the lowerdecklabs environment.

## Changes Made

### 1. Archived Workflows

The following workflows have been moved to `.github/workflows/archive/`:

**Testing/Investigation Workflows:**
- `lowerdecklabs-investigate-labels-api.yml` - Labels API 405 error investigation
- `lowerdecklabs-test-label-endpoints.yml` - Endpoint testing
- `lowerdecklabs-validate-labels.yml` - Old validation (superseded by validate-label-mappings.yml)
- `test-export-oig.yml` - Export testing
- `validate-pr.yml` - Old PR validation

**Legacy Import Workflows:**
- `lowerdecklabs-import.yml` - Basic import with drift detection
- `lowerdecklabs-import-oig.yml` - OIG-specific import
- `lowerdecklabs-import-complete.yml` - Complete environment import

**Replacement:** Use `import-all-resources.yml` which provides comprehensive multi-environment support.

### 2. Converted Workflows

The following workflows have been converted from environment-specific to environment-agnostic:

| Old Workflow Name | New Workflow Name | Key Changes |
|-------------------|-------------------|-------------|
| `lowerdecklabs-apply-admin-labels.yml` | `apply-admin-labels.yml` | Added environment parameter |
| `lowerdecklabs-apply-labels-from-config.yml` | `apply-labels-from-config.yml` | Auto-detects environment from changed files + manual selection |
| `lowerdecklabs-apply-labels.yml` | `apply-labels.yml` | Dynamic path mapping |
| `lowerdecklabs-apply-owners.yml` | `apply-owners.yml` | Added environment parameter |
| `lowerdecklabs-export-oig.yml` | `export-oig.yml` | Dynamic export paths per environment |
| `lowerdecklabs-sync-labels.yml` | `sync-labels.yml` | Environment-specific config paths |
| `lowerdecklabs-governance-setup.yml` | `governance-setup.yml` | Dynamic terraform directory paths |

### 3. Environment Detection Pattern

All converted workflows follow this pattern:

**For workflows with push/PR triggers:**
```yaml
jobs:
  detect-environment:
    name: Detect Environment
    runs-on: ubuntu-latest
    outputs:
      environment: ${{ steps.detect-env.outputs.environment }}
    steps:
      - name: Detect Environment
        id: detect-env
        run: |
          if [ "${{ github.event_name }}" == "workflow_dispatch" ]; then
            echo "environment=${{ inputs.environment }}" >> $GITHUB_OUTPUT
          else
            # Detect from changed files
            if git diff --name-only HEAD~1 HEAD | grep -q "environments/production/"; then
              echo "environment=production" >> $GITHUB_OUTPUT
            elif git diff --name-only HEAD~1 HEAD | grep -q "environments/staging/"; then
              echo "environment=staging" >> $GITHUB_OUTPUT
            # ... etc
            fi
          fi

  apply-job:
    needs: detect-environment
    environment: ${{ needs.detect-environment.outputs.environment }}
    # ... rest of job
```

**For manual-only workflows:**
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options:
          - lowerdecklabs
          - production
          - staging
          - development

jobs:
  job-name:
    environment: ${{ inputs.environment }}
    # ... rest of job
```

### 4. Path Mappings

All hardcoded paths have been updated:

| Old Path Pattern | New Path Pattern |
|------------------|------------------|
| `environments/lowerdecklabs/` | `environments/${{ inputs.environment }}/` |
| `config/` | `environments/${{ inputs.environment }}/config/` |
| `production-ready/` | `environments/${{ inputs.environment }}/terraform/` |

### 5. Documentation Updates

Updated 9 documentation files to reference new workflow names:

1. `CLAUDE.md` - Updated all workflow commands
2. `docs/API_MANAGEMENT.md` - Environment parameter documentation
3. `docs/GITOPS_WORKFLOW.md` - Workflow diagrams updated
4. `docs/LABEL_MANAGEMENT.md` - Command examples updated
5. `docs/LESSONS_LEARNED.md` - Workflow references updated
6. `docs/PROJECT_STRUCTURE.md` - Workflow listing updated
7. `docs/WORKFLOWS.md` - Complete workflow documentation rewrite
8. `testing/DEMO_BUILD_GUIDE.md` - Demo commands updated
9. `testing/MANUAL_VALIDATION_PLAN.md` - Validation steps updated

## Usage Examples

### Before (Environment-Specific)
```bash
# Only worked for lowerdecklabs
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false
```

### After (Environment-Agnostic)
```bash
# Works for any environment
gh workflow run apply-owners.yml -f environment=lowerdecklabs -f dry_run=false
gh workflow run apply-owners.yml -f environment=production -f dry_run=false
gh workflow run apply-owners.yml -f environment=staging -f dry_run=false
```

## Environment Mapping

Workflows use GitHub Environments for secrets. The environment parameter maps to GitHub Environment names:

| Parameter Value | GitHub Environment | Okta Tenant |
|----------------|-------------------|-------------|
| `lowerdecklabs` | `LowerDeckLabs` | lowerdecklabs.oktapreview.com |
| `production` | `Production` | your-org.okta.com |
| `staging` | `Staging` | your-org-staging.okta.com |
| `development` | `Development` | your-org-dev.okta.com |

## Benefits

1. **Multi-Tenant Support:** Single set of workflows for all environments
2. **Reduced Duplication:** No need to copy/paste workflows for each environment
3. **Consistent Behavior:** All environments use the same tested workflow logic
4. **Better Organization:** Cleaner workflow directory (24 workflows vs 32 previously)
5. **Easier Maintenance:** Update once, applies to all environments
6. **PR Auto-Detection:** Workflows automatically detect which environment changed
7. **Environment Protection:** GitHub Environments provide approval gates and secret isolation

## Migration Checklist for Adding New Environments

To add a new environment (e.g., `demo`):

1. Create directory structure: `mkdir -p environments/demo/{terraform,config,imports}`
2. Create GitHub Environment in repository settings: "Demo"
3. Add secrets to GitHub Environment:
   - `OKTA_API_TOKEN`
   - `OKTA_ORG_NAME`
   - `OKTA_BASE_URL`
4. Update workflow choice options to include `demo`
5. Add environment detection logic if needed (for PR triggers)
6. Import initial configuration: `gh workflow run import-all-resources.yml -f tenant_environment=Demo`

## Breaking Changes

### Command Changes Required

All environment-specific workflow commands need updating:

```bash
# OLD - Will no longer work
gh workflow run lowerdecklabs-apply-owners.yml -f dry_run=false

# NEW - Required format
gh workflow run apply-owners.yml -f environment=lowerdecklabs -f dry_run=false
```

### Workflow File Names

If you have any automation or scripts that reference the old workflow names, update them:

- Any CI/CD pipelines
- Documentation links
- Shell scripts
- Repository documentation

## Rollback Procedure

If needed, old workflows are preserved in `.github/workflows/archive/` and can be restored:

```bash
cd .github/workflows
cp archive/lowerdecklabs-apply-owners.yml .
git add lowerdecklabs-apply-owners.yml
git commit -m "chore: Restore legacy workflow"
```

## Questions or Issues

If you encounter issues with the new workflows:

1. Check that the `environment` parameter is specified
2. Verify GitHub Environment exists with correct name
3. Confirm secrets are configured in the GitHub Environment
4. Review archive/README.md for details on archived workflows
5. Consult CLAUDE.md for updated usage patterns

---

**Migration Date:** 2025-11-12
**Migration Author:** Claude Code
**Approved By:** [Your Name]
