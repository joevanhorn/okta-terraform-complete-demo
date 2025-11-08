# GitOps Workflow Guide

This repository implements a complete GitOps workflow for managing Okta infrastructure as code with Terraform.

## Table of Contents

1. [Overview](#overview)
2. [Branch Protection](#branch-protection)
3. [Development Workflow](#development-workflow)
4. [Automated Workflows](#automated-workflows)
5. [Manual Workflows](#manual-workflows)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

---

## Overview

### GitOps Principles

This repository follows GitOps best practices:

- **Git as single source of truth** - All infrastructure changes are version controlled
- **Pull request workflow** - All changes require review before merging
- **Automated validation** - Terraform plan runs on every PR
- **Controlled deployments** - Manual approval required for apply
- **Audit trail** - Complete history of all infrastructure changes

### Workflow Summary

```
┌─────────────────┐
│  Create Branch  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Make Changes   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Push Branch    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Create PR      │◄─── Terraform Plan runs automatically
└────────┬────────┘     Plan results posted as PR comment
         │
         ▼
┌─────────────────┐
│  Code Review    │◄─── Required: 1 approval
└────────┬────────┘     All conversations resolved
         │              Terraform Plan must pass
         ▼
┌─────────────────┐
│  Merge to Main  │◄─── Terraform Plan runs on main
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Manual Trigger │◄─── terraform-apply-with-approval
│  (Apply)        │     Requires manual approval
└─────────────────┘     Applies changes to Okta
```

---

## Branch Protection

The `main` branch is protected with the following rules:

### Required Status Checks
- **Terraform Plan** must pass before merging
- Branch must be **up to date** with main before merging

### Pull Request Requirements
- **1 approval** required before merging
- **Stale reviews dismissed** when new commits are pushed
- **All conversations must be resolved** before merging

### Branch Restrictions
- **No force pushes** to main
- **No deletions** of main branch
- **No direct commits** to main (must use PRs)

### Configuration

Branch protection is configured via GitHub API. To view current settings:

```bash
gh api repos/joevanhorn/okta-terraform-complete-demo/branches/main/protection
```

---

## Development Workflow

### Step 1: Create a Feature Branch

Never commit directly to `main`. Always create a branch:

```bash
# Create and switch to new branch
git checkout -b feature/add-new-users

# Or for bug fixes
git checkout -b fix/update-group-rules
```

**Branch naming conventions:**
- `feature/*` - New features or additions
- `fix/*` - Bug fixes or corrections
- `docs/*` - Documentation updates
- `refactor/*` - Code refactoring without functionality changes

### Step 2: Make Your Changes

Edit Terraform files in the appropriate environment:

```bash
# Example: Add new users
vim environments/lowerdecklabs/terraform/users.tf

# Example: Update applications
vim environments/lowerdecklabs/terraform/apps.tf
```

**Always validate locally:**

```bash
cd environments/lowerdecklabs/terraform

# Format code
terraform fmt

# Validate syntax
terraform validate

# Optional: Run local plan (requires API token)
terraform plan
```

### Step 3: Commit and Push

```bash
# Stage changes
git add environments/lowerdecklabs/terraform/

# Commit with descriptive message
git commit -m "feat: Add 5 new marketing users

- Added marketing team members
- Created Marketing-Advanced group
- Updated group assignments"

# Push to GitHub
git push -u origin feature/add-new-users
```

### Step 4: Create Pull Request

```bash
# Using GitHub CLI
gh pr create \
  --title "Add marketing team users" \
  --body "Adds 5 new marketing users and Marketing-Advanced group"

# Or use GitHub web interface
open https://github.com/joevanhorn/okta-terraform-complete-demo/compare
```

### Step 5: Wait for Automated Checks

GitHub Actions will automatically:

1. Run `terraform fmt -check` to verify formatting
2. Run `terraform validate` to check syntax
3. Run `terraform plan` to show proposed changes
4. Post plan results as a PR comment

**What to look for:**

```
✅ Terraform Plan - All checks passed

Plan: 5 to add, 0 to change, 0 to destroy
```

### Step 6: Code Review

Request review from a teammate or approve yourself (if you have permissions):

1. Reviewer examines Terraform plan output
2. Reviewer checks for:
   - Unintended deletions
   - Security issues
   - Naming conventions
   - Resource organization
3. Reviewer approves or requests changes

### Step 7: Resolve Conversations

If reviewer leaves comments:

1. Address all feedback
2. Push new commits to same branch
3. Terraform Plan will run again automatically
4. Previous approvals are dismissed (due to `dismiss_stale_reviews`)
5. Request re-review

### Step 8: Merge to Main

Once all checks pass and you have approval:

```bash
# Using GitHub CLI
gh pr merge --squash

# Or use GitHub web interface
```

**What happens on merge:**

1. PR is squashed and merged to main
2. Feature branch is deleted (optional)
3. Terraform Plan runs on main branch
4. Plan results are saved as artifacts
5. Ready for apply (manual step)

---

## Automated Workflows

### Terraform Plan (On Pull Request)

**Trigger:** Opened, updated, or synchronized PR to `main`

**File:** `.github/workflows/terraform-plan.yml`

**What it does:**

1. Detects which environment changed based on file paths
2. Checks out code
3. Sets up Terraform
4. Configures variables from GitHub secrets
5. Runs `terraform init`
6. Runs `terraform validate`
7. Runs `terraform fmt -check`
8. Runs `terraform plan`
9. Posts plan results as PR comment
10. Uploads plan artifact for review

**Example PR comment:**

```markdown
## Terraform Plan Results

<details>
<summary>Show Plan</summary>

```terraform
Terraform will perform the following actions:

  # okta_user.john_doe will be created
  + resource "okta_user" "john_doe" {
      + email      = "john.doe@example.com"
      + first_name = "John"
      + last_name  = "Doe"
      + login      = "john.doe@example.com"
      + status     = "ACTIVE"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

</details>

*Environment: lowerdecklabs*
```

### Terraform Plan (On Push to Main)

**Trigger:** Push to `main` branch that modifies terraform files

**File:** `.github/workflows/terraform-plan.yml`

**What it does:**

Same as PR workflow, but:
- Runs on the committed code
- Does not post PR comment
- Saves plan artifact for later apply
- Validates that merged code still plans correctly

**Protects against:**
- Merge conflicts affecting Terraform state
- Changes to secrets between PR and merge
- Concurrent merges causing plan drift

---

## Manual Workflows

### 1. Terraform Apply (with Approval)

**When to use:** After merging PR to main, to apply changes to Okta

**File:** `.github/workflows/terraform-apply-with-approval.yml`

**Steps:**

```bash
# Option 1: Use GitHub CLI
gh workflow run terraform-apply-with-approval.yml \
  -f environment=lowerdecklabs

# Option 2: Use GitHub web interface
# 1. Go to Actions tab
# 2. Click "Terraform Apply (with Approval)"
# 3. Click "Run workflow"
# 4. Select environment
# 5. Click "Run workflow" button
```

**Process:**

1. **Approval Gate** - Workflow pauses and waits for manual approval
   - GitHub sends notification to approvers
   - Approver reviews the plan
   - Approver clicks "Approve and run" or "Reject"

2. **Apply Execution** (after approval)
   - Checks out code
   - Sets up Terraform
   - Generates fresh plan
   - Displays plan for final review
   - Runs `terraform apply -auto-approve`
   - Uploads apply output as artifact
   - Commits updated state file (if local state)

**Approval configuration:**

Approvers are configured in GitHub Settings > Environments:

```
Repository Settings
  └─ Environments
      └─ lowerdecklabs-approval
          └─ Required reviewers: [Add approvers here]
```

### 2. Terraform Plan (Manual)

**When to use:**
- Testing workflow changes
- Planning for specific environment
- Investigating plan issues

**File:** `.github/workflows/terraform-plan.yml`

**Steps:**

```bash
gh workflow run terraform-plan.yml \
  -f environment=lowerdecklabs
```

### 3. Terraform Apply (Legacy)

**When to use:** Emergency changes (bypasses approval)

**File:** `.github/workflows/terraform-apply.yml`

**Steps:**

```bash
# Dry run (plan only, no apply)
gh workflow run terraform-apply.yml \
  -f environment=lowerdecklabs \
  -f dry_run=true \
  -f auto_approve=false

# Real apply (USE WITH CAUTION)
gh workflow run terraform-apply.yml \
  -f environment=lowerdecklabs \
  -f dry_run=false \
  -f auto_approve=true
```

**Warning:** This workflow bypasses the approval gate. Only use for emergencies.

---

## Best Practices

### 1. Always Use Feature Branches

**Good:**
```bash
git checkout -b feature/add-users
# make changes
git push origin feature/add-users
# create PR
```

**Bad:**
```bash
git checkout main
# make changes
git push origin main  # ❌ BLOCKED by branch protection
```

### 2. Write Descriptive PR Titles

**Good:**
- `feat: Add 5 engineering users and GitHub OAuth app`
- `fix: Update Salesforce redirect URIs`
- `refactor: Organize users by department`

**Bad:**
- `Updates`
- `Fix`
- `Changes to terraform`

### 3. Review Terraform Plans Carefully

Before approving a PR, check:

- ✅ Only expected resources are being created/modified/deleted
- ✅ No accidental deletions of critical resources
- ✅ Sensitive data is not hardcoded
- ✅ Naming conventions are followed
- ✅ Resource counts make sense

**Example - Dangerous plan:**

```terraform
Plan: 1 to add, 0 to change, 50 to destroy.  # ⚠️ INVESTIGATE!
```

### 4. Use Conventional Commits

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `refactor:` - Code refactoring
- `test:` - Test updates
- `chore:` - Maintenance tasks

**Example:**

```
feat(users): Add marketing team members

Added 5 new users:
- Jane Smith (Marketing Manager)
- Bob Jones (Content Strategist)
- Alice Chen (Social Media Specialist)
- Mike Davis (Marketing Coordinator)
- Sarah Lee (Campaign Manager)

Created Marketing-Advanced group and assigned users.

Closes #42
```

### 5. Keep PRs Focused

**Good PR:**
- Adds 5 users
- Creates 1 group
- Assigns users to group

**Bad PR:**
- Adds 20 users
- Creates 10 groups
- Modifies 5 applications
- Updates 3 group rules
- Changes authentication policies

**Why:** Smaller PRs are easier to review and safer to merge.

### 6. Test Locally When Possible

Before pushing:

```bash
cd environments/lowerdecklabs/terraform

# Format
terraform fmt

# Validate
terraform validate

# Plan (if you have API token)
export OKTA_API_TOKEN="your-token"
terraform plan
```

### 7. Resolve All Conversations

Don't merge until:
- All reviewer comments are addressed
- All conversations are marked as resolved
- All questions are answered

### 8. Monitor Apply Jobs

After triggering apply:

```bash
# Watch the workflow
gh run watch

# Or view in browser
open https://github.com/joevanhorn/okta-terraform-complete-demo/actions
```

### 9. Document Infrastructure Changes

For significant changes, update:
- `README.md` - If adding new features
- `docs/TERRAFORM_RESOURCES.md` - If using new resources
- `testing/DEMO_BUILD_GUIDE.md` - If affecting demo builds

---

## Troubleshooting

### PR is Blocked - "Branch is out of date"

**Cause:** Someone else merged to main after you created your branch

**Solution:**

```bash
# Update your branch
git checkout main
git pull origin main
git checkout your-feature-branch
git merge main

# Resolve any conflicts
git add .
git commit -m "Merge main into feature branch"
git push
```

### PR is Blocked - "Terraform Plan failed"

**Cause:** Syntax error, validation error, or plan error

**Solution:**

1. Click "Details" on failed check
2. Review error message
3. Fix the issue locally
4. Commit and push fix
5. Plan will run again automatically

**Common errors:**

```terraform
Error: Invalid interpolation syntax
# Fix: Check for unescaped $ characters (use $$ in Okta templates)

Error: Duplicate resource
# Fix: Resource with same name exists elsewhere

Error: Missing required argument
# Fix: Add the required attribute
```

### PR is Blocked - "Requires approving review"

**Cause:** No one has approved your PR yet

**Solution:**

1. Request review from teammate
2. Or approve yourself (if you have permissions)
3. Or ask repo admin to approve

### Apply Fails - "Error acquiring state lock"

**Cause:** Another apply is running or didn't finish cleanly

**Solution:**

```bash
# Wait 5-10 minutes for lock to expire
# Or manually unlock (use with caution)
cd environments/lowerdecklabs/terraform
terraform force-unlock <lock-id>
```

### Apply Fails - "API token is invalid"

**Cause:** GitHub secret is wrong or expired

**Solution:**

```bash
# Update secret via GitHub CLI
gh secret set OKTA_API_TOKEN

# Or via web interface
# Settings > Secrets and variables > Actions > Update OKTA_API_TOKEN
```

### Branch Protection Bypass Needed

**Scenario:** Emergency hotfix needed immediately

**Solution:**

Repository admins can temporarily disable branch protection:

```bash
# Disable enforcement
gh api -X PUT /repos/joevanhorn/okta-terraform-complete-demo/branches/main/protection \
  -f enforce_admins=false

# Make emergency change

# Re-enable enforcement
gh api -X PUT /repos/joevanhorn/okta-terraform-complete-demo/branches/main/protection \
  -f enforce_admins=true
```

**Better approach:** Use environment-specific approval bypass for emergencies

---

## Workflow Files Reference

### Terraform Plan
- **File:** `.github/workflows/terraform-plan.yml`
- **Triggers:** PR to main, push to main, manual
- **Purpose:** Validate and preview infrastructure changes
- **Outputs:** Plan artifact, PR comment

### Terraform Apply (with Approval)
- **File:** `.github/workflows/terraform-apply-with-approval.yml`
- **Triggers:** Manual only
- **Purpose:** Apply infrastructure changes with approval gate
- **Requires:** Manual approval from authorized users

### Terraform Apply (Legacy)
- **File:** `.github/workflows/terraform-apply.yml`
- **Triggers:** Manual only
- **Purpose:** Emergency apply without approval
- **Warning:** Bypasses approval process

---

## Environment Configuration

### GitHub Secrets Required

All environments need these secrets:

| Secret | Description | Example |
|--------|-------------|---------|
| `OKTA_ORG_NAME` | Okta organization name | `dev-12345678` |
| `OKTA_BASE_URL` | Okta base URL | `okta.com` or `oktapreview.com` |
| `OKTA_API_TOKEN` | Okta API token | `00abc...xyz` |

### Environment-Specific Approvers

Configure in: Settings > Environments

| Environment | Approval Required | Approvers |
|-------------|-------------------|-----------|
| `lowerdecklabs` | No | N/A |
| `lowerdecklabs-approval` | Yes | [Configure here] |
| `production` | Yes | [Configure here] |
| `production-approval` | Yes | [Configure here] |

---

## Security Considerations

### 1. Secrets Management

- Never commit API tokens
- Use GitHub encrypted secrets
- Rotate tokens regularly
- Use least-privilege tokens

### 2. State Files

- Never commit `terraform.tfstate`
- Use remote backend (S3, Terraform Cloud) for production
- Current setup uses local state for demo purposes

### 3. Code Review

- Always require review before merge
- Focus on security implications
- Check for overly permissive permissions

### 4. Audit Trail

- All changes are tracked in Git history
- All approvals are logged in PR timeline
- All applies create workflow run artifacts

---

## Related Documentation

- **[Manual Validation Plan](../testing/MANUAL_VALIDATION_PLAN.md)** - Testing checklist
- **[Demo Build Guide](../testing/DEMO_BUILD_GUIDE.md)** - Step-by-step tutorials
- **[Terraform Resources](TERRAFORM_RESOURCES.md)** - Resource reference
- **[Main README](../README.md)** - Repository overview

---

**Last Updated:** 2025-11-08

**Questions?** Review the troubleshooting section or check workflow run logs in the Actions tab.
