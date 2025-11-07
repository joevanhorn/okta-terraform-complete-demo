# Testing OIG Export to Repository

## What Was Implemented

The OIG export workflow now commits exports directly to the repository, similar to `.tf` files.

### Changes Made

1. **Directory Structure**
   - Created `oig-exports/lowerdecklabs/` directory
   - Added `.gitkeep` to track empty directory
   - Added comprehensive README

2. **Workflow Updates**
   - Exports now include `--export-labels` and `--export-entitlements` explicitly
   - Creates two files per export:
     - `latest.json` - Always the most recent export
     - `YYYY-MM-DD.json` - Historical export for that date
   - Automatically commits to repository
   - Still uploads artifact as backup

3. **What Gets Exported**
   - ✅ **Entitlements** - All principal entitlements
   - ✅ **Labels** - Governance labels (if available)
   - ❌ **Resource Owners** - Not included (requires specific ORNs)

## How to Test

### Step 1: Commit and Push Changes

```bash
cd /Users/joevanhorn/projects/okta-terraform-complete-demo

# Stage all changes
git add .

# Commit
git commit -m "feat(oig): Add repository-managed OIG exports

- Create oig-exports/ directory structure
- Update workflow to commit exports to repo
- Add README with usage examples
- Export includes labels and entitlements

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
git push
```

### Step 2: Trigger the Workflow

1. Go to GitHub: `https://github.com/<your-org>/okta-terraform-complete-demo/actions`
2. Click on **"LowerDeckLabs OIG Export"** workflow
3. Click **"Run workflow"** button
4. Select branch: `main`
5. Click **"Run workflow"** (green button)

### Step 3: Approve the Deployment

Since this uses the LowerDeckLabs environment:
1. Wait for approval request notification
2. Review the workflow run
3. Click **"Review deployments"**
4. Select **LowerDeckLabs**
5. Click **"Approve and deploy"**

### Step 4: Watch the Export

The workflow will:
1. ✅ Export labels and entitlements from LowerDeckLabs
2. ✅ Copy to `oig-exports/lowerdecklabs/`
3. ✅ Commit with summary message
4. ✅ Push to repository
5. ✅ Upload artifact as backup

### Step 5: Review Results

After the workflow completes:

```bash
# Pull the new commit
git pull

# View the export
cat oig-exports/lowerdecklabs/latest.json | jq '.'

# Count entitlements
cat oig-exports/lowerdecklabs/latest.json | jq '.entitlements | length'

# Check export status
cat oig-exports/lowerdecklabs/latest.json | jq '.export_status'

# View the commit
git log --oneline -1 oig-exports/lowerdecklabs/
```

## Expected Results

### Entitlements
- **Status**: `success`
- **Count**: ~789 (based on previous export)
- Includes all principal entitlements with full details

### Labels
- **Status**: `not_available` or `success`
- **Count**: Depends on whether labels endpoint is enabled
- If not available, gracefully continues with empty array

### Resource Owners
- **Status**: `skipped` (not requested)
- **Count**: 0
- Can be enabled by adding `--export-owners` and `--resource-orns` to workflow

## What the Commit Will Look Like

```
feat(oig): Export OIG resources for lowerdecklabs

- Entitlements: 789 (success)
- Labels: 0 (not_available)

Export date: 2025-11-07
Workflow run: 43

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
```

## Files Created

```
oig-exports/lowerdecklabs/
├── latest.json           # Most recent export
└── 2025-11-07.json      # Historical export for today
```

## Troubleshooting

### No Commit Created

If the export is identical to the previous one, no commit is created:
```
ℹ️  No changes detected - export is identical to previous
```

This is **expected behavior** - prevents noisy commits.

### Workflow Fails

Check the workflow logs:
1. Export step - Did the export complete?
2. Commit step - Were files copied correctly?
3. Push step - Did git push succeed?

### Permission Errors

The workflow needs permissions to push:
- Ensure GitHub Actions has write access
- Check environment protection rules

## Next Steps

After successful test:

1. **Review the export** in the repository
2. **Set up drift detection** - compare exports over time
3. **Add to PR reviews** - review OIG changes like code
4. **Schedule regular exports** - add cron trigger to workflow

## Adding Resource Owners (Future)

To export resource owners, update the workflow:

```yaml
python3 scripts/okta_api_manager.py \
  --action export \
  --org-name "${OKTA_ORG_NAME}" \
  --base-url "${OKTA_BASE_URL}" \
  --api-token "${OKTA_API_TOKEN}" \
  --output "${EXPORT_DIR}/lowerdecklabs_oig_export.json" \
  --export-labels \
  --export-entitlements \
  --export-owners \
  --resource-orns "orn:okta:idp:demo-lowerdecklabs:apps:oauth2:app123"
```

---

Last updated: 2025-11-07
