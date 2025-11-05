# LowerDeckLabs Environment Setup Guide

This guide walks you through setting up the **LowerDeckLabs** GitHub environment for safe, import-only operations on your primary demo tenant.

---

## 🚨 Critical Safety Notice

**LowerDeckLabs is a PRIMARY DEMO TENANT** - we use strict safeguards to prevent accidental modifications:

- ✅ **Import-only operations** by default
- ✅ **Manual approval required** for any apply operations
- ✅ **Protected workflows** that cannot modify resources without explicit approval
- ✅ **Comprehensive resource export** including OIG features (entitlements, labels, owners)

---

## Table of Contents

1. [GitHub Environment Setup](#github-environment-setup)
2. [Secrets Configuration](#secrets-configuration)
3. [Protection Rules](#protection-rules)
4. [Workflow Usage](#workflow-usage)
5. [Importing OIG Resources](#importing-oig-resources)

---

## GitHub Environment Setup

### Step 1: Create the Environment

1. **Navigate** to your GitHub repository
2. Go to **Settings** → **Environments**
3. Click **New environment**
4. Name it: `LowerDeckLabs`
5. Click **Configure environment**

### Step 2: Configure Protection Rules

**Deployment Protection Rules:**

1. ☑️ **Required reviewers**
   - Add yourself and/or team members
   - Minimum: 1 reviewer required

2. ☑️ **Wait timer** (Optional but recommended)
   - Set to: 5 minutes
   - Gives you time to cancel accidental deployments

3. ☑️ **Deployment branches** (Recommended)
   - Select: **Protected branches only**
   - Or specify: `main` branch only
   - Prevents deployments from feature branches

**Why these rules?**
- **Required reviewers**: No automated apply can run without human approval
- **Wait timer**: Buffer time to catch mistakes
- **Branch restrictions**: Only trusted branches can deploy

---

## Secrets Configuration

Add these secrets specifically to the **LowerDeckLabs** environment:

### Navigate to Secrets

1. In the **LowerDeckLabs** environment settings
2. Scroll to **Environment secrets**
3. Click **Add secret** for each:

### Required Secrets

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `OKTA_ORG_NAME` | `demo-terraform-test-example` | Your Okta org subdomain |
| `OKTA_BASE_URL` | `oktapreview.com` | Your Okta base URL |
| `OKTA_API_TOKEN` | `00KSc7lwIHIrJO8nHGacIu9Q3cA_C-OAa3BBD3Shdg` | API token with governance scopes |

### API Token Permissions Required

Your API token must have these scopes:

**Basic Resources:**
- `okta.users.read`
- `okta.groups.read`
- `okta.apps.read`
- `okta.authorizationServers.read`
- `okta.policies.read`
- `okta.idps.read`
- `okta.trustedOrigins.read`
- `okta.networkZones.read`

**OIG/Governance (for export):**
- `okta.governance.accessRequests.read`
- `okta.governance.accessReviews.read`
- `okta.governance.catalogs.read`

**Note:** Read-only scopes are sufficient for import/export operations. We do NOT use `manage` scopes to prevent accidental modifications.

---

## Protection Rules

### Environment Configuration

```yaml
Environment: LowerDeckLabs
├── Protection Rules:
│   ├── Required Reviewers: 1+ (YOU)
│   ├── Wait Timer: 5 minutes (optional)
│   └── Deployment Branches: main only
│
├── Secrets:
│   ├── OKTA_ORG_NAME: demo-terraform-test-example
│   ├── OKTA_BASE_URL: oktapreview.com
│   └── OKTA_API_TOKEN: <redacted>
│
└── Workflows Allowed:
    ├── lowerdecklabs-import.yml (import-only)
    ├── lowerdecklabs-export-oig.yml (export OIG resources)
    └── lowerdecklabs-plan.yml (read-only plan)
```

### What Gets Protected

✅ **terraform apply** - Requires manual approval
✅ **terraform destroy** - Blocked entirely
✅ **Resource modifications** - Requires approval
❌ **terraform plan** - Allowed (read-only)
❌ **terraform import** - Allowed (read-only)
❌ **Export scripts** - Allowed (read-only)

---

## Workflow Usage

### Available Workflows

#### 1. **Import Existing Resources** (Safe - Read-only)

```bash
# Triggers: Manual or scheduled weekly
# File: .github/workflows/lowerdecklabs-import.yml
```

**What it does:**
- Imports ALL existing Okta resources using Terraformer
- Filters out admin users and system apps
- Organizes resources by type
- Creates import report
- **Does NOT apply changes** - import-only

**How to run:**
1. Go to **Actions** → **LowerDeckLabs - Import Resources**
2. Click **Run workflow**
3. Select branch: `main`
4. Click **Run workflow**

**No approval needed** - this is read-only

#### 2. **Export OIG Resources** (Safe - Read-only)

```bash
# Triggers: Manual
# File: .github/workflows/lowerdecklabs-export-oig.yml
```

**What it does:**
- Exports entitlements, resource owners, and labels
- Creates JSON files with current state
- Uploads as artifacts
- **Does NOT modify anything** - export-only

**How to run:**
1. Go to **Actions** → **LowerDeckLabs - Export OIG**
2. Click **Run workflow**
3. Download artifacts after completion

**No approval needed** - this is read-only

#### 3. **Plan Changes** (Safe - Read-only)

```bash
# Triggers: Manual or on PR to main
# File: .github/workflows/lowerdecklabs-plan.yml
```

**What it does:**
- Runs `terraform plan` to show what WOULD change
- Posts plan as PR comment
- **Does NOT apply** - planning only

**How to run:**
- Automatically runs on PRs
- Or manually trigger from Actions tab

**No approval needed** - this is read-only

#### 4. **Apply Changes** (DANGEROUS - Requires Approval)

```bash
# Triggers: Manual only
# File: .github/workflows/lowerdecklabs-apply.yml
```

**What it does:**
- Applies Terraform changes to LowerDeckLabs
- **CAN MODIFY YOUR TENANT** - use with extreme caution

**How to run:**
1. Go to **Actions** → **LowerDeckLabs - Apply Changes**
2. Click **Run workflow**
3. **WAIT** for required reviewer approval
4. Reviewer must explicitly approve
5. Optional 5-minute wait timer
6. Then applies

**⚠️ REQUIRES APPROVAL** - protected operation

---

## Importing OIG Resources

LowerDeckLabs includes **Okta Integration Network** apps and other complex resources not supported by Terraformer. We have custom scripts for these:

### Supported OIG Imports

| Resource Type | Import Method | Output Format |
|--------------|---------------|---------------|
| **Entitlements** | API export script | JSON |
| **Resource Owners** | API export script | JSON |
| **Labels** | API export script | JSON |
| **Access Reviews** | Terraformer (if available) | `.tf` files |
| **Request Settings** | Terraformer (if available) | `.tf` files |

### Running OIG Export

**Method 1: GitHub Actions (Recommended)**

```bash
# Trigger the export workflow
Actions → LowerDeckLabs - Export OIG → Run workflow
```

**Method 2: Local Export**

```bash
# Set environment variables
export OKTA_ORG_NAME="demo-terraform-test-example"
export OKTA_BASE_URL="oktapreview.com"
export OKTA_API_TOKEN="00KSc7lwIHIrJO8nHGacIu9Q3cA_C-OAa3BBD3Shdg"

# Run export script
python3 scripts/export_oig_resources.py \
  --org-name $OKTA_ORG_NAME \
  --base-url $OKTA_BASE_URL \
  --api-token $OKTA_API_TOKEN \
  --output lowerdecklabs_oig_export.json
```

**Output:**

```json
{
  "export_date": "2025-11-04T10:30:00Z",
  "okta_org": "demo-terraform-test-example",
  "entitlements": [
    {
      "id": "ent123",
      "principals": ["usr_abc", "grp_xyz"],
      "resources": ["app_oauth_123"]
    }
  ],
  "resource_owners": [
    {
      "resource_orn": "orn:okta:idp:demo:apps:oauth2:app123",
      "owners": ["usr_owner1", "usr_owner2"]
    }
  ],
  "labels": [
    {
      "name": "Critical",
      "description": "Critical business applications",
      "resources": ["app_123", "app_456"]
    }
  ]
}
```

### Importing Exported Data

**To import the exported OIG data into a new environment:**

```bash
# Import entitlements, owners, and labels
python3 scripts/import_oig_resources.py \
  --input lowerdecklabs_oig_export.json \
  --target-org <new-org-name> \
  --target-token <new-api-token> \
  --dry-run  # Preview changes first

# After reviewing, run without --dry-run
python3 scripts/import_oig_resources.py \
  --input lowerdecklabs_oig_export.json \
  --target-org <new-org-name> \
  --target-token <new-api-token>
```

---

## Special Considerations for LowerDeckLabs

### Okta Integration Network Apps

**Challenge:** OIN apps have special configurations that Terraformer may not fully capture.

**Solution:**

1. **Export app settings** using custom script:
   ```bash
   python3 scripts/export_oin_apps.py \
     --org-name demo-terraform-test-example
   ```

2. **Review app configurations** manually
   - Some OIN apps require manual setup
   - Custom SAML/OIDC configurations may need adjustment
   - Provisioning settings are app-specific

3. **Document custom configurations** in separate files
   - See `docs/OIN_APPS.md` for detailed configurations
   - Include screenshots for complex setups

### Entitlement Management

**Important:** Entitlement Management must be enabled per-application:

1. **Identify apps with entitlements:**
   ```bash
   # Export will show which apps have entitlement management enabled
   python3 scripts/export_oig_resources.py --list-entitlement-apps
   ```

2. **For each app:**
   - Note current provisioning status
   - Document entitlement bundles
   - Export entitlement assignments

3. **When recreating:**
   - Disable provisioning
   - Enable entitlement management (GUI)
   - Wait 1-2 minutes
   - Re-enable provisioning

---

## Troubleshooting

### Issue: Workflow requires approval but none requested

**Solution:**
1. Check GitHub Settings → Environments → LowerDeckLabs
2. Ensure "Required reviewers" includes active users
3. Check email for approval notification

### Issue: API token errors during export

**Solution:**
1. Verify token has governance scopes:
   ```bash
   curl -H "Authorization: SSWS $OKTA_API_TOKEN" \
     https://demo-terraform-test-example.oktapreview.com/api/v1/governance/entitlements
   ```
2. Token may have expired - generate new token
3. Update GitHub secret with new token

### Issue: Some resources not imported

**Possible causes:**
- Resource type not supported by Terraformer
- API token lacks read permissions
- Resource is Okta-managed (system apps)

**Solution:**
- Check import log for errors
- Use custom export scripts for OIG resources
- Review `docs/TERRAFORMER_OIG_FAQ.md` for limitations

---

## Workflow Files Reference

### Created for LowerDeckLabs

```
.github/workflows/
├── lowerdecklabs-import.yml      # Import all resources (safe)
├── lowerdecklabs-export-oig.yml  # Export OIG resources (safe)
├── lowerdecklabs-plan.yml        # Plan changes (safe)
└── lowerdecklabs-apply.yml       # Apply changes (PROTECTED)
```

### Scripts Used

```
scripts/
├── import_okta_resources.sh      # Standard Terraformer import
├── export_oig_resources.py       # Export entitlements/owners/labels (NEW)
├── import_oig_resources.py       # Import OIG data to new tenant (NEW)
├── export_oin_apps.py            # Export OIN app configs (NEW)
└── okta_api_manager.py           # Updated with entitlements support
```

---

## Quick Reference

### Safe Operations (No Approval Needed)

```bash
# Import all resources
Actions → LowerDeckLabs - Import Resources → Run

# Export OIG resources
Actions → LowerDeckLabs - Export OIG → Run

# Plan changes
Actions → LowerDeckLabs - Plan → Run
```

### Protected Operations (Requires Approval)

```bash
# Apply terraform changes
Actions → LowerDeckLabs - Apply → Run → WAIT FOR APPROVAL → Approves
```

### Local Operations

```bash
# Export OIG locally
python3 scripts/export_oig_resources.py --org-name demo-terraform-test-example

# View current state
terraform plan  # Safe - read-only

# Apply changes (USE WITH CAUTION)
terraform apply  # Dangerous - modifies tenant
```

---

## Next Steps

1. ✅ **Create LowerDeckLabs environment** in GitHub UI (Settings → Environments)
2. ✅ **Add secrets** (OKTA_ORG_NAME, OKTA_BASE_URL, OKTA_API_TOKEN)
3. ✅ **Configure protection rules** (required reviewers, wait timer)
4. ✅ **Run initial import** to baseline current state
5. ✅ **Export OIG resources** to capture entitlements/owners/labels
6. ✅ **Review imported resources** and document customizations
7. ✅ **Test plan workflow** to verify everything works
8. ⚠️ **Never run apply** without explicit approval and review

---

## Support

**Questions or issues?**
- Check existing import logs in Actions → Workflow runs
- Review `docs/TERRAFORMER_OIG_FAQ.md` for known limitations
- See `production-ready/LESSONS_LEARNED.md` for common issues
- Open GitHub issue for repository-specific problems

---

Last updated: 2025-11-04
