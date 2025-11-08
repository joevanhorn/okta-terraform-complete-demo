# Manual Validation Plan - Okta Terraform Complete Demo

This document provides a comprehensive manual validation plan for testing the Okta Terraform configuration across all environments and workflows.

**Last Updated:** 2025-11-07
**Estimated Time:** 2-3 hours for complete validation
**Required Access:** Okta Admin Console, GitHub Actions, Local Terminal

---

## 📋 Table of Contents

1. [Pre-Validation Checklist](#1-pre-validation-checklist)
2. [Environment Validation](#2-environment-validation)
3. [Import Workflow Validation](#3-import-workflow-validation)
4. [Resource Management Validation](#4-resource-management-validation)
5. [OIG Governance Validation](#5-oig-governance-validation)
6. [State Management Validation](#6-state-management-validation)
7. [Documentation Validation](#7-documentation-validation)
8. [Security Validation](#8-security-validation)
9. [Cleanup and Rollback](#9-cleanup-and-rollback)
10. [Validation Sign-Off](#10-validation-sign-off)

---

## 1. Pre-Validation Checklist

### 1.1 Environment Setup

**Objective:** Verify all required tools and access are configured

- [ ] **Terraform Installed**
  ```bash
  terraform version
  # Expected: Terraform v1.9.0 or higher
  ```
  - ✅ Pass: Version >= 1.9.0
  - ❌ Fail: Version < 1.9.0 or not installed

- [ ] **Okta Provider Version**
  ```bash
  cd environments/lowerdecklabs/terraform
  terraform version
  # Expected: provider registry.terraform.io/okta/okta v6.1.0
  ```
  - ✅ Pass: Provider v6.1.0 or higher
  - ❌ Fail: Older version or missing

- [ ] **Python 3.8+ Installed**
  ```bash
  python3 --version
  # Expected: Python 3.8 or higher
  ```
  - ✅ Pass: Version >= 3.8
  - ❌ Fail: Version < 3.8

- [ ] **GitHub CLI Installed**
  ```bash
  gh --version
  # Expected: gh version 2.0.0 or higher
  ```
  - ✅ Pass: gh installed and authenticated
  - ❌ Fail: Not installed or not authenticated

- [ ] **jq Installed**
  ```bash
  jq --version
  # Expected: jq-1.6 or higher
  ```
  - ✅ Pass: jq installed
  - ❌ Fail: Not installed

### 1.2 Access Verification

- [ ] **Okta Admin Console Access**
  - Navigate to: https://lowerdecklabs.oktapreview.com/admin
  - ✅ Pass: Can log in with super admin privileges
  - ❌ Fail: Cannot access or insufficient permissions

- [ ] **GitHub Repository Access**
  - Navigate to: https://github.com/joevanhorn/okta-terraform-complete-demo
  - ✅ Pass: Can view repository and trigger actions
  - ❌ Fail: No access or read-only

- [ ] **GitHub Environments Configured**
  ```bash
  gh api repos/joevanhorn/okta-terraform-complete-demo/environments | jq -r '.environments[].name'
  # Expected: LowerDeckLabs, Production, Staging, Development
  ```
  - ✅ Pass: All 4 environments exist
  - ❌ Fail: Missing environments

### 1.3 Secrets Validation

- [ ] **LowerDeckLabs Secrets Present**
  - Check in GitHub: Settings → Environments → LowerDeckLabs
  - Required secrets:
    - `OKTA_API_TOKEN`
    - `OKTA_ORG_NAME`
    - `OKTA_BASE_URL`
  - ✅ Pass: All 3 secrets configured
  - ❌ Fail: Missing secrets

- [ ] **API Token Permissions**
  ```bash
  # Test API token with a simple call
  curl -X GET "https://lowerdecklabs.oktapreview.com/api/v1/users?limit=1" \
    -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
    -H "Accept: application/json"
  ```
  - ✅ Pass: Returns user data (HTTP 200)
  - ❌ Fail: Permission denied or error

---

## 2. Environment Validation

### 2.1 Directory Structure

**Objective:** Verify repository structure matches documentation

- [ ] **Main Directories Present**
  ```bash
  ls -la
  # Expected directories:
  # - environments/
  # - scripts/
  # - docs/
  # - .github/workflows/
  # - testing/
  ```
  - ✅ Pass: All directories exist
  - ❌ Fail: Missing directories

- [ ] **Environment Structure**
  ```bash
  ls -la environments/lowerdecklabs/
  # Expected:
  # - terraform/
  # - imports/
  # - config/
  # - README.md
  ```
  - ✅ Pass: Complete structure
  - ❌ Fail: Missing subdirectories

### 2.2 Configuration Files

- [ ] **Terraform Configuration**
  ```bash
  cd environments/lowerdecklabs/terraform
  ls *.tf
  # Expected files:
  # - provider.tf
  # - variables.tf
  # - backend.tf (optional)
  # - oig_entitlements.tf
  # - oig_reviews.tf
  # - app_oauth.tf
  # - user.tf
  # - group.tf
  ```
  - ✅ Pass: Key files present
  - ❌ Fail: Missing critical files

- [ ] **Terraform Init**
  ```bash
  terraform init
  # Expected: Successful initialization
  ```
  - ✅ Pass: Initializes without errors
  - ❌ Fail: Errors during initialization

- [ ] **Terraform Validate**
  ```bash
  terraform validate
  # Expected: Success! The configuration is valid.
  ```
  - ✅ Pass: Configuration is valid
  - ❌ Fail: Validation errors

---

## 3. Import Workflow Validation

### 3.1 GitHub Actions Workflow - Import All Resources

**Objective:** Test the complete import workflow

- [ ] **Trigger Workflow**
  ```bash
  gh workflow run import-all-resources.yml \
    -f tenant_environment=LowerDeckLabs \
    -f update_terraform=false \
    -f commit_changes=false
  ```
  - ✅ Pass: Workflow triggered successfully
  - ❌ Fail: Workflow failed to trigger

- [ ] **Monitor Workflow**
  ```bash
  gh run list --workflow=import-all-resources.yml --limit 1
  gh run watch <RUN_ID>
  ```
  - ✅ Pass: Workflow completes successfully (status: completed)
  - ❌ Fail: Workflow fails or times out
  - **Expected Duration:** 1-2 minutes
  - **Note Warnings:** Document any warnings in output

- [ ] **Download Artifacts**
  ```bash
  gh run download <RUN_ID>
  ls -la import-results-*/
  ```
  - Expected files:
    - `imports/entitlements.json`
    - `imports/reviews.json`
    - `terraform/oig_entitlements.tf`
    - `terraform/oig_reviews.tf`
    - `config/owner_mappings.json`
    - `config/label_mappings.json`
  - ✅ Pass: All expected files present
  - ❌ Fail: Missing files

### 3.2 Validate Import Results

- [ ] **Check Resource Counts**
  ```bash
  # Count entitlement bundles
  jq '. | length' import-results-*/imports/entitlements.json
  # Expected: 31 (based on current LowerDeckLabs tenant)

  # Count reviews
  jq '. | length' import-results-*/imports/reviews.json
  # Expected: 200 (based on current LowerDeckLabs tenant)
  ```
  - ✅ Pass: Counts match expected values (±5%)
  - ❌ Fail: Significant discrepancy (>10%)

- [ ] **Validate Terraform Syntax**
  ```bash
  cd import-results-*/terraform
  terraform fmt -check
  terraform validate
  ```
  - ✅ Pass: Valid Terraform syntax
  - ❌ Fail: Syntax errors

- [ ] **Check for Sensitive Data**
  ```bash
  # Search for potential secrets in generated files
  grep -r "SSWS" import-results-*/
  grep -r "api_token" import-results-*/
  ```
  - ✅ Pass: No secrets found
  - ❌ Fail: Secrets detected in files

---

## 4. Resource Management Validation

### 4.1 Terraform Plan (Read-Only)

**Objective:** Verify Terraform can plan without making changes

- [ ] **Initial Plan**
  ```bash
  cd environments/lowerdecklabs/terraform
  terraform plan -out=tfplan
  ```
  - ✅ Pass: Plan succeeds, shows existing resources
  - ❌ Fail: Plan errors or shows unexpected changes
  - **Expected Output:** Should show current state, no pending changes (or only additions if new resources imported)

- [ ] **Plan Output Analysis**
  ```bash
  terraform show -json tfplan | jq '.resource_changes | length'
  # Expected: 0 (if no changes) or count of new resources
  ```
  - ✅ Pass: Output matches expectations
  - ❌ Fail: Unexpected resource modifications or deletions

### 4.2 Create Test Resources

**Objective:** Verify ability to create new resources

- [ ] **Create Test User**
  ```bash
  # Add to user.tf or create test_user.tf
  cat > test_resources.tf <<'EOF'
  resource "okta_user" "validation_test_user" {
    email      = "validation.test@example.com"
    first_name = "Validation"
    last_name  = "Test"
    login      = "validation.test@example.com"
    status     = "STAGED"  # Won't send activation email
  }
  EOF

  terraform plan
  # Expected: Shows 1 resource to add
  ```
  - ✅ Pass: Plan shows 1 addition
  - ❌ Fail: Errors or unexpected changes

- [ ] **Apply Test User**
  ```bash
  terraform apply -auto-approve
  # Expected: Successfully created
  ```
  - ✅ Pass: User created successfully
  - ❌ Fail: Apply failed
  - **Record User ID:** `______________________`

- [ ] **Verify in Okta Admin Console**
  - Navigate to: Directory → People
  - Search for: validation.test@example.com
  - ✅ Pass: User exists in Okta
  - ❌ Fail: User not found

- [ ] **Verify State File**
  ```bash
  terraform state list | grep validation_test_user
  # Expected: okta_user.validation_test_user
  ```
  - ✅ Pass: Resource in state
  - ❌ Fail: Not in state

### 4.3 Update Test Resources

**Objective:** Verify ability to update existing resources

- [ ] **Modify Test User**
  ```bash
  # Update test_resources.tf
  # Change first_name from "Validation" to "Updated"

  terraform plan
  # Expected: Shows 1 resource to update
  ```
  - ✅ Pass: Shows in-place update
  - ❌ Fail: Shows replacement or errors

- [ ] **Apply Update**
  ```bash
  terraform apply -auto-approve
  ```
  - ✅ Pass: Update successful
  - ❌ Fail: Update failed

- [ ] **Verify Update in Okta**
  - Check user profile in Okta Admin Console
  - ✅ Pass: First name updated to "Updated"
  - ❌ Fail: Change not reflected

### 4.4 Drift Detection

**Objective:** Verify Terraform detects manual changes

- [ ] **Manual Change in Okta**
  - In Okta Admin Console:
    - Navigate to validation test user
    - Change last name to "ManualChange"
    - Save

- [ ] **Detect Drift**
  ```bash
  terraform plan -refresh-only
  # Expected: Shows drift detected
  ```
  - ✅ Pass: Drift detected
  - ❌ Fail: No drift detected

- [ ] **Refresh State**
  ```bash
  terraform apply -refresh-only -auto-approve
  terraform plan
  # Expected: Shows change to revert last_name back to "Test"
  ```
  - ✅ Pass: Plan shows correction needed
  - ❌ Fail: No changes detected

---

## 5. OIG Governance Validation

### 5.1 Entitlement Bundles

**Objective:** Verify OIG entitlement bundle import and management

- [ ] **Review Imported Bundles**
  ```bash
  cd environments/lowerdecklabs/imports
  jq '.[0]' entitlements.json
  # Review structure of first bundle
  ```
  - ✅ Pass: Valid JSON structure with expected fields
  - ❌ Fail: Malformed or missing data

- [ ] **Check Terraform Configuration**
  ```bash
  cd ../terraform
  grep -c "resource \"okta_entitlement_bundle\"" oig_entitlements.tf
  # Expected: 31 (or current count)
  ```
  - ✅ Pass: Resource count matches import count
  - ❌ Fail: Mismatch

- [ ] **Verify in Okta Admin Console**
  - Navigate to: Identity Governance → Entitlements
  - ✅ Pass: Can see entitlement bundles
  - ❌ Fail: Page not accessible or empty

### 5.2 Access Reviews

- [ ] **Review Imported Campaigns**
  ```bash
  jq '.[0]' ../imports/reviews.json
  # Review structure
  ```
  - ✅ Pass: Valid structure
  - ❌ Fail: Invalid or missing data

- [ ] **Check Terraform Configuration**
  ```bash
  grep -c "resource \"okta_reviews\"" oig_reviews.tf
  # Expected: 200 (or current count)
  ```
  - ✅ Pass: Count matches
  - ❌ Fail: Mismatch

### 5.3 Resource Owners (API-Only)

**Objective:** Verify API-based resource owner management

- [ ] **Sync Resource Owners**
  ```bash
  python3 ../../scripts/sync_owner_mappings.py \
    --output ../config/owner_mappings.json
  ```
  - ✅ Pass: Completes successfully
  - ❌ Fail: Script errors

- [ ] **Validate JSON Structure**
  ```bash
  jq '.' ../config/owner_mappings.json
  # Expected: Valid JSON with apps, groups, bundles sections
  ```
  - ✅ Pass: Valid structure
  - ❌ Fail: Malformed JSON

- [ ] **Test Apply Owners**
  ```bash
  python3 ../../scripts/apply_resource_owners.py \
    --config ../config/owner_mappings.json \
    --dry-run
  ```
  - ✅ Pass: Dry run successful, shows changes
  - ❌ Fail: Errors during dry run

### 5.4 Governance Labels (API-Only)

- [ ] **Sync Governance Labels**
  ```bash
  python3 ../../scripts/sync_label_mappings.py \
    --output ../config/label_mappings.json
  ```
  - ✅ Pass: Completes successfully
  - ❌ Fail: Script errors

- [ ] **Validate Labels**
  ```bash
  jq '.labels | length' ../config/label_mappings.json
  # Expected: 2 (or current count)
  ```
  - ✅ Pass: Labels present
  - ❌ Fail: Empty or error

---

## 6. State Management Validation

### 6.1 State File Integrity

**Objective:** Verify Terraform state is valid and consistent

- [ ] **Validate State**
  ```bash
  cd environments/lowerdecklabs/terraform
  terraform state list | wc -l
  # Count resources in state
  ```
  - ✅ Pass: Returns resource count
  - ❌ Fail: Error or empty
  - **Resource Count:** `______`

- [ ] **Check for State Corruption**
  ```bash
  terraform state pull > /tmp/state_backup.json
  jq '.version' /tmp/state_backup.json
  # Expected: 4 (Terraform state version)
  ```
  - ✅ Pass: Valid state version
  - ❌ Fail: Corrupted or invalid

- [ ] **Verify State Matches Reality**
  ```bash
  terraform plan -refresh-only
  # Expected: No changes if state is accurate
  ```
  - ✅ Pass: State matches Okta
  - ❌ Fail: Drift detected (may indicate state issue)

### 6.2 State Backup

- [ ] **Create State Backup**
  ```bash
  terraform state pull > state_backup_$(date +%Y%m%d).json
  ls -lh state_backup_*.json
  ```
  - ✅ Pass: Backup created successfully
  - ❌ Fail: Backup failed

- [ ] **Verify Backup Integrity**
  ```bash
  jq '.' state_backup_*.json > /dev/null
  echo $?
  # Expected: 0 (valid JSON)
  ```
  - ✅ Pass: Valid JSON
  - ❌ Fail: Invalid JSON (exit code != 0)

---

## 7. Documentation Validation

### 7.1 README Accuracy

**Objective:** Verify documentation matches actual implementation

- [ ] **Quick Start Commands Work**
  ```bash
  # Test commands from environments/lowerdecklabs/README.md
  cd environments/lowerdecklabs/terraform
  terraform init
  terraform plan
  ```
  - ✅ Pass: All commands execute successfully
  - ❌ Fail: Commands fail or produce errors

- [ ] **Resource Counts Match Documentation**
  - Check `environments/lowerdecklabs/README.md`
  - Expected counts:
    - Entitlement Bundles: 31
    - Access Reviews: 200
    - Governance Labels: 2
  - Compare with actual:
  ```bash
  jq '. | length' ../imports/entitlements.json
  jq '. | length' ../imports/reviews.json
  jq '.labels | length' ../config/label_mappings.json
  ```
  - ✅ Pass: Counts match (±5%)
  - ❌ Fail: Significant discrepancy

### 7.2 Resource Documentation

- [ ] **TERRAFORM_RESOURCES.md Complete**
  - Open: `docs/TERRAFORM_RESOURCES.md`
  - Verify sections present:
    - [ ] Part 1: Complete Resource Catalog (116 resources)
    - [ ] Part 2: Data Source Catalog (63 data sources)
    - [ ] Part 3: Detailed Attribute Guides
    - [ ] Part 4: Management Best Practices
  - ✅ Pass: All sections complete
  - ❌ Fail: Missing sections

- [ ] **Table of Contents Works**
  - Click various TOC links in TERRAFORM_RESOURCES.md
  - ✅ Pass: All links navigate correctly
  - ❌ Fail: Broken links

### 7.3 Workflow Documentation

- [ ] **Workflow Files Match Documentation**
  ```bash
  ls .github/workflows/*.yml | wc -l
  # Compare with docs/PROJECT_STRUCTURE.md
  ```
  - ✅ Pass: All documented workflows exist
  - ❌ Fail: Missing workflows

---

## 8. Security Validation

### 8.1 Secrets Management

**Objective:** Ensure no secrets are committed to repository

- [ ] **Search for API Tokens**
  ```bash
  git grep -i "SSWS" || echo "No tokens found"
  git grep -i "api_token" || echo "No explicit tokens found"
  ```
  - ✅ Pass: No secrets found
  - ❌ Fail: Secrets detected

- [ ] **Check .gitignore**
  ```bash
  grep -E "terraform.tfvars|.tfstate|.env" .gitignore
  ```
  - ✅ Pass: Critical files are ignored
  - ❌ Fail: Missing .gitignore entries

- [ ] **Verify State Files Not Committed**
  ```bash
  git ls-files | grep -E "\.tfstate$|terraform.tfvars$"
  echo $?
  # Expected: 1 (no matches)
  ```
  - ✅ Pass: No state files in git
  - ❌ Fail: State files committed

### 8.2 Workflow Security

- [ ] **GitHub Environment Protection**
  - Check: Settings → Environments → LowerDeckLabs
  - Verify:
    - [ ] Required reviewers: At least 1
    - [ ] Deployment branches: Protected
  - ✅ Pass: Protection rules enabled
  - ❌ Fail: No protection

- [ ] **Workflow Permissions**
  - Review: `.github/workflows/import-all-resources.yml`
  - Verify `permissions:` block exists and is minimal
  - ✅ Pass: Minimal permissions
  - ❌ Fail: Excessive permissions

---

## 9. Cleanup and Rollback

### 9.1 Remove Test Resources

**Objective:** Clean up resources created during validation

- [ ] **Remove Test User**
  ```bash
  cd environments/lowerdecklabs/terraform
  rm test_resources.tf
  terraform plan
  # Expected: Shows 1 resource to destroy
  ```
  - ✅ Pass: Plan shows destruction
  - ❌ Fail: Errors or no changes

- [ ] **Apply Destruction**
  ```bash
  terraform apply -auto-approve
  ```
  - ✅ Pass: Resource destroyed
  - ❌ Fail: Destruction failed

- [ ] **Verify Removal in Okta**
  - Check Okta Admin Console
  - ✅ Pass: Test user no longer exists
  - ❌ Fail: User still present

### 9.2 Restore Original State

- [ ] **Verify Clean State**
  ```bash
  terraform plan
  # Expected: No changes
  ```
  - ✅ Pass: No pending changes
  - ❌ Fail: Unexpected changes remain

- [ ] **Remove Backup Files**
  ```bash
  rm -f state_backup_*.json
  rm -rf import-results-*/
  ```
  - ✅ Pass: Cleanup successful
  - ❌ Fail: Files remain

---

## 10. Validation Sign-Off

### 10.1 Summary Checklist

- [ ] All pre-validation checks passed
- [ ] Environment structure validated
- [ ] Import workflow completed successfully
- [ ] Resource management (CRUD operations) validated
- [ ] OIG governance features tested
- [ ] State management verified
- [ ] Documentation accurate and complete
- [ ] Security checks passed
- [ ] Cleanup completed successfully

### 10.2 Test Results Summary

**Validation Date:** `____________________`
**Validator Name:** `____________________`
**Environment:** `LowerDeckLabs`

**Results:**
- Total Tests: `____/85`
- Passed: `____`
- Failed: `____`
- Skipped: `____`

**Pass Rate:** `____%`

### 10.3 Issues Found

| Issue # | Severity | Description | Status |
|---------|----------|-------------|--------|
| 1 | | | |
| 2 | | | |
| 3 | | | |

**Severity Levels:**
- **Critical:** Blocks core functionality
- **High:** Significant issue, workaround available
- **Medium:** Minor issue, does not block usage
- **Low:** Cosmetic or documentation issue

### 10.4 Recommendations

Based on validation results, document any recommendations:

1.
2.
3.

### 10.5 Sign-Off

**Validated By:** `____________________`
**Date:** `____________________`
**Signature:** `____________________`

**Approved By:** `____________________`
**Date:** `____________________`
**Signature:** `____________________`

---

## Appendix A: Troubleshooting Common Issues

### Issue: Workflow fails with "Environment not found"

**Solution:**
1. Verify environment exists in GitHub: Settings → Environments
2. Check spelling matches exactly (case-sensitive)
3. Ensure secrets are configured

### Issue: Terraform plan shows unexpected changes

**Solution:**
1. Run `terraform refresh` to sync state
2. Check for manual changes in Okta Admin Console
3. Verify `.tf` files haven't been manually edited

### Issue: Import returns 0 resources

**Solution:**
1. Verify API token has correct permissions
2. Check OKTA_ORG_NAME and OKTA_BASE_URL are correct
3. Verify resources exist in Okta tenant

### Issue: State file conflicts

**Solution:**
1. Ensure only one person/process is running Terraform
2. Use state locking (remote backend)
3. If corrupted, restore from backup

---

## Appendix B: Validation Automation

For automated validation, consider creating test scripts:

```bash
#!/bin/bash
# validate_all.sh - Automated validation runner

set -e

echo "Running validation tests..."

# Run all validation steps programmatically
# (Can be expanded based on this manual plan)

echo "✅ All validations passed!"
```

---

## Appendix C: References

- [Terraform Okta Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)
- [Okta API Documentation](https://developer.okta.com/docs/reference/)
- [Project README](../README.md)
- [Resource Documentation](../docs/TERRAFORM_RESOURCES.md)
- [Environment README](../environments/lowerdecklabs/README.md)

---

**End of Validation Plan**
