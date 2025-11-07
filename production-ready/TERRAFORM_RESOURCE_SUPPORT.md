# Terraform Okta Provider - Complete Resource Support Matrix

This document provides a comprehensive breakdown of ALL Okta Terraform resources, their support status across different tools, and recommended management approaches.

**Provider Version:** v6.1.0+
**Last Updated:** November 7, 2025

---

## 📊 Quick Summary

| Management Method | Resource Count | Use Case |
|-------------------|----------------|----------|
| **Terraformer Import** | ~90 resources | Existing infrastructure import (automated) |
| **Manual Terraform** | ~100 resources | New resources & OIG governance |
| **API-Only (Python)** | 2 resources | Labels, Resource Owners (no Terraform support) |

---

## 🔧 Management Method Decision Tree

```
┌─ Is this an existing Okta resource?
│  └─ YES ──► Use Terraformer (90+ resources supported)
│  └─ NO ───┐
│          │
│          └─ Is this an OIG governance resource?
│             └─ YES ──┐
│             │        ├─ Entitlement/Campaign/Request? ──► Manual Terraform
│             │        └─ Label/Resource Owner? ──────────► API (Python scripts)
│             │
│             └─ NO ───► Manual Terraform
```

---

## 📋 Complete Resource Support Matrix

### ✅ IDENTITY & ACCESS MANAGEMENT (9 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_user` | ✅ | ✅ | - | Full support |
| `okta_user_schema` | ✅ | ✅ | - | Custom attributes |
| `okta_user_base_schema` | ✅ | ✅ | - | Base schema properties |
| `okta_user_type` | ✅ | ✅ | - | User types |
| `okta_group` | ✅ | ✅ | - | Full support |
| `okta_group_schema` | ✅ | ✅ | - | Custom group attributes |
| `okta_group_rule` | ✅ | ✅ | - | Dynamic membership |
| `okta_group_memberships` | - | ✅ | - | Bulk membership management |
| `okta_user_group_memberships` | - | ✅ | - | User-specific groups |

---

### ✅ APPLICATIONS (14+ resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_app_oauth` | ✅ | ✅ | - | OAuth/OIDC apps |
| `okta_app_oauth_redirect_uri` | - | ✅ | - | Manage URIs separately |
| `okta_app_oauth_post_logout_redirect_uri` | - | ✅ | - | Post-logout URIs |
| `okta_app_saml` | ✅ | ✅ | - | SAML 2.0 apps |
| `okta_app_saml_app_settings` | - | ✅ | - | SAML settings |
| `okta_app_basic_auth` | ✅ | ✅ | - | Basic auth apps |
| `okta_app_bookmark` | ✅ | ✅ | - | Bookmark apps |
| `okta_app_secure_password_store` | ✅ | ✅ | - | SWA apps |
| `okta_app_three_field` | ✅ | ✅ | - | Three-field SWA |
| `okta_app_auto_login` | ✅ | ✅ | - | Auto-login apps |
| `okta_app_user` | - | ✅ | - | User assignments |
| `okta_app_group_assignment` | - | ✅ | - | Group assignments |
| `okta_app_group_assignments` | - | ✅ | - | Bulk group assignments |
| `okta_app_user_schema` | - | ✅ | - | App user profile schema |
| `okta_app_user_base_schema` | - | ✅ | - | Base app user schema |

---

### ✅ AUTHORIZATION SERVERS (7 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_auth_server` | ✅ | ✅ | - | Custom auth servers |
| `okta_auth_server_default` | ✅ | ✅ | - | Default auth server |
| `okta_auth_server_policy` | ✅ | ✅ | - | Policies |
| `okta_auth_server_policy_rule` | ✅ | ✅ | - | Policy rules |
| `okta_auth_server_claim` | ✅ | ✅ | - | Custom claims |
| `okta_auth_server_claim_default` | - | ✅ | - | Default claims |
| `okta_auth_server_scope` | ✅ | ✅ | - | Custom scopes |

---

### ✅ POLICIES (18+ resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_policy_mfa` | ✅ | ✅ | - | MFA policies |
| `okta_policy_mfa_default` | - | ✅ | - | Default MFA policy |
| `okta_policy_rule_mfa` | ✅ | ✅ | - | MFA rules |
| `okta_policy_password` | ✅ | ✅ | - | Password policies |
| `okta_policy_password_default` | - | ✅ | - | Default password policy |
| `okta_policy_rule_password` | ✅ | ✅ | - | Password rules |
| `okta_policy_signon` | ✅ | ✅ | - | Sign-on policies |
| `okta_policy_rule_signon` | ✅ | ✅ | - | Sign-on rules |
| `okta_policy_profile_enrollment` | - | ✅ | - | Enrollment policies |
| `okta_policy_profile_enrollment_apps` | - | ✅ | - | Apps for enrollment |
| `okta_policy_device_assurance_windows` | - | ✅ | - | Windows device trust |
| `okta_policy_device_assurance_macos` | - | ✅ | - | macOS device trust |
| `okta_policy_device_assurance_android` | - | ✅ | - | Android device trust |
| `okta_policy_device_assurance_ios` | - | ✅ | - | iOS device trust |
| `okta_policy_device_assurance_chromeos` | - | ✅ | - | ChromeOS device trust |

---

### ✅ SECURITY (6+ resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_network_zone` | ✅ | ✅ | - | IP allowlists/denylists |
| `okta_trusted_origin` | ✅ | ✅ | - | CORS origins |
| `okta_behavior` | - | ✅ | - | Anomaly detection |
| `okta_threat_insight_settings` | - | ✅ | - | Threat insight |
| `okta_rate_limiting` | - | ✅ | - | Rate limits |
| `okta_authenticator` | - | ✅ | - | Authenticator config |

---

### ✅ IDENTITY PROVIDERS (4 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_idp_saml` | ✅ | ✅ | - | SAML IdPs |
| `okta_idp_saml_key` | - | ✅ | - | SAML keys |
| `okta_idp_oidc` | ✅ | ✅ | - | OIDC IdPs |
| `okta_idp_social` | ✅ | ✅ | - | Social IdPs |

---

### ✅ BRANDS & THEMES (5 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_brand` | - | ✅ | - | Organization brands |
| `okta_theme` | - | ✅ | - | Custom themes |
| `okta_email_customization` | - | ✅ | - | Email templates |
| `okta_domain` | - | ✅ | - | Custom domains |
| `okta_domain_certificate` | - | ✅ | - | SSL certificates |

---

### ✅ HOOKS & EVENT HANDLERS (3 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_inline_hook` | ✅ | ✅ | - | Inline hooks |
| `okta_event_hook` | ✅ | ✅ | - | Event hooks |
| `okta_event_hook_verification` | - | ✅ | - | Verification |

---

### ⚠️ OKTA IDENTITY GOVERNANCE (OIG) - v6.1.0+ (11 total)

#### Terraform-Managed (9 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_reviews` | ❌ | ✅ | - | Access certification campaigns |
| `okta_principal_entitlements` | ❌ | ✅ | - | **Manual entitlements ONLY** |
| `okta_request_conditions` | ❌ | ✅ | - | Request conditions |
| `okta_request_sequences` | ❌ | ✅ | - | Approval workflows |
| `okta_request_settings` | ❌ | ✅ | - | Request settings |
| `okta_request_v2` | ❌ | ✅ | - | Programmatic requests |
| `okta_catalog_entry_default` | ❌ | ✅ | - | Requestable resources |
| `okta_catalog_entry_user_access_request_fields` | ❌ | ✅ | - | Custom request fields |
| `okta_end_user_my_requests` | ❌ | ✅ | - | Data source (read-only) |

**IMPORTANT:** The `okta_principal_entitlements` resource can ONLY manage **manual/custom (BYO) entitlements**. App-managed entitlements (e.g., Salesforce, Workday) are synced from applications and cannot be managed in Terraform.

#### API-Only (2 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| **Labels** | ❌ | ❌ | ✅ | `/api/v1/governance/labels` |
| **Resource Owners** | ❌ | ❌ | ✅ | `/api/v1/governance/resource-owners` |

**Why API-Only?** These resources are not yet supported by the Terraform provider as of v6.1.0. Must use `scripts/okta_api_manager.py`.

---

### ✅ FEATURES & ADMIN (5 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_feature` | - | ✅ | - | Feature flags |
| `okta_admin_role_custom` | - | ✅ | - | Custom admin roles |
| `okta_admin_role_targets` | - | ✅ | - | Role targets |
| `okta_resource_set` | - | ✅ | - | Resource sets |
| `okta_user_admin_roles` | - | ✅ | - | User admin role assignments |

---

### ✅ ORG SETTINGS (4 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_org_configuration` | - | ✅ | - | Org-level settings |
| `okta_org_support` | - | ✅ | - | Support settings |
| `okta_captcha` | - | ✅ | - | CAPTCHA config |
| `okta_captcha_org_wide_settings` | - | ✅ | - | Org-wide CAPTCHA |

---

### ✅ LINKING & ASSOCIATIONS (3 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_link_definition` | - | ✅ | - | Link type definitions |
| `okta_link_value` | - | ✅ | - | Link values |
| `okta_profile_mapping` | - | ✅ | - | Attribute mappings |

---

### ✅ TEMPLATES & LOGS (2 resources)

| Resource | Terraformer | Manual TF | API-Only | Notes |
|----------|-------------|-----------|----------|-------|
| `okta_template_sms` | ✅ | ✅ | - | SMS templates |
| `okta_log_stream` | - | ✅ | - | Log streaming |

---

## 🎯 Recommended Workflow by Use Case

### Use Case 1: Importing Existing Infrastructure

**Tool:** Terraformer
**Supported:** ~90 resources (all basic Okta resources)
**Workflow:** `.github/workflows/lowerdecklabs-import.yml`

```bash
# Import existing resources
./scripts/import_okta_resources.sh

# Resources imported:
# - Users, Groups, Apps, Policies
# - Authorization Servers
# - Identity Providers
# - Network Zones, Trusted Origins
# - Hooks, Templates
```

---

### Use Case 2: Creating New Governance Resources

**Tool:** Manual Terraform
**Supported:** All 9 OIG resources
**Workflow:** Manual creation in `production-ready/governance/`

```hcl
# Example: Create manual entitlement
resource "okta_principal_entitlements" "custom_bundle" {
  # Only manual/custom entitlements
  # App-managed entitlements are read-only
}

# Example: Create access certification campaign
resource "okta_reviews" "quarterly_review" {
  name = "Q1 Access Review"
  # ...
}
```

**See:** `production-ready/RESOURCE_EXAMPLES.tf` for complete examples

---

### Use Case 3: Documenting App-Managed Entitlements & Labels

**Tool:** Python API Scripts
**Supported:** Labels, Resource Owners, App-managed Entitlements (read-only)
**Workflow:** `.github/workflows/lowerdecklabs-export-oig.yml`

```bash
# Export for documentation/drift detection
python3 scripts/okta_api_manager.py \
  --action export \
  --export-labels \
  --export-resource-owners \
  --export-entitlements  # Includes categorization

# Exports saved to: oig-exports/lowerdecklabs/latest.json
```

**Why?**
- Labels: No Terraform support yet
- Resource Owners: No Terraform support yet
- App-managed Entitlements: Read-only (Salesforce, Workday, etc.)

---

## 📚 Important Distinctions

### Entitlements: Manual vs. App-Managed

The `okta_principal_entitlements` Terraform resource can ONLY manage **manual/custom entitlements**:

| Type | Can Manage in Terraform? | Example | Source |
|------|-------------------------|---------|--------|
| **Manual** | ✅ YES | Custom access bundles, BYO entitlements | Created via API/Workflows |
| **App-Managed** | ❌ NO (read-only) | Salesforce profiles, Workday permissions | Synced from provisioning apps |

**How to Identify:**
- Manual entitlements: `_category: "manual"` in API exports
- App-managed entitlements: `_category: "app-managed"` in API exports
- Use `oig-exports/` JSON files to determine category

---

## 📖 Additional Resources

- **Resource Examples:** `production-ready/RESOURCE_EXAMPLES.tf` - Commented examples for all ~100 resources
- **API Scripts:** `scripts/okta_api_manager.py` - Labels, Resource Owners, Entitlements
- **Workflows:**
  - `.github/workflows/lowerdecklabs-import.yml` - Terraformer imports
  - `.github/workflows/lowerdecklabs-export-oig.yml` - API exports
- **Documentation:**
  - `docs/TERRAFORMER.md` - Terraformer usage
  - `oig-exports/README.md` - OIG export documentation
  - Official Docs: https://registry.terraform.io/providers/okta/okta/latest/docs

---

## 🔄 Version History

| Date | Version | Changes |
|------|---------|---------|
| 2025-11-07 | 1.0 | Initial comprehensive resource matrix for v6.1.0+ |

---

**Questions?** See `production-ready/RESOURCE_EXAMPLES.tf` for implementation examples.
