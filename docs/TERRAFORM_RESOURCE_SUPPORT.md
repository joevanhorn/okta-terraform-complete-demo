# Terraform Okta Provider - Complete Resource Support Matrix

This document provides a comprehensive breakdown of ALL Okta Terraform resources (116 total) and data sources (63 total), their support status, and recommended management approaches.

**Provider Version:** v6.1.0+
**Last Updated:** 2025-11-07

---

## 📊 Quick Summary

| Management Method | Resource Count | Use Case |
|-------------------|----------------|----------|
| **Terraformer Import** | ~90 resources | Existing infrastructure import (automated) |
| **Manual Terraform** | 116 resources | New resources & complete infrastructure |
| **API-Only (Python)** | 2+ resources | Labels, Resource Owners (no Terraform support yet) |
| **Data Sources** | 63 data sources | Read-only queries for existing resources |

**Total Resources Available:** 116
**Total Data Sources Available:** 63

---

## 📖 Table of Contents

### Resources (116 Total)
- [👥 Users & User Management (10)](#-users--user-management-10-resources)
- [👪 Groups & Group Management (6)](#-groups--group-management-5-resources)
- [📱 Applications (24)](#-applications-24-resources)
- [🔐 Authorization Servers & OAuth (7)](#-authorization-servers--oauth-7-resources)
- [🔒 Policies (20)](#-policies-20-resources)
- [🌐 Identity Providers & Social Auth (4)](#-identity-providers--social-auth-4-resources)
- [🛡️ Security & Network (4)](#️-security--network-4-resources)
- [🎨 Brands, Themes & Customization (9)](#-brands-themes--customization-9-resources)
- [🌍 Domains & Certificates (3)](#-domains--certificates-3-resources)
- [🔗 Hooks & Event Handlers (3)](#-hooks--event-handlers-3-resources)
- [👔 OIG - Identity Governance (11)](#-okta-identity-governance-oig---v610-11-resources)
- [👨‍💼 Admin Roles & Permissions (5)](#-admin-roles--permissions-5-resources)
- [⚙️ Org Settings & Configuration (6)](#️-org-settings--configuration-6-resources)
- [🔗 Linking & Associations (3)](#-linking--associations-3-resources)
- [📊 Logging & Monitoring (1)](#-logging--monitoring-1-resource)
- [🌐 Realms (2)](#-realms-beta-2-resources)

### Data Sources (63 Total)
- [👥 User Data Sources (5)](#-user-data-sources-5)
- [👪 Group Data Sources (4)](#-group-data-sources-4)
- [📱 Application Data Sources (8)](#-application-data-sources-8)
- [🔐 Authorization Server Data Sources (5)](#-authorization-server-data-sources-5)
- [🔒 Policy Data Sources (3)](#-policy-data-sources-2)
- [🛡️ Security Data Sources (5)](#️-security-data-sources-4)
- [🌐 Identity Provider Data Sources (4)](#-identity-provider-data-sources-4)
- [🎨 Branding Data Sources (7)](#-branding-data-sources-6)
- [📧 Email Data Sources (4)](#-email-data-sources-4)
- [👔 OIG Data Sources (12)](#-oig-data-sources-7)
- [⚙️ Organization Data Sources (6)](#️-organization-data-sources-5)

### Management & Best Practices
- [🎯 Resource Management Best Practices](#-resource-management-best-practices)
  - [Use Case 1: Import Existing Infrastructure](#use-case-1-import-existing-infrastructure)
  - [Use Case 2: Create New Resources](#use-case-2-create-new-resources)
  - [Use Case 3: OIG Governance via API](#use-case-3-oig-governance-via-api)
- [📖 Additional Resources](#-additional-resources)
- [🔄 Version History](#-version-history)

---

## 📋 Complete Resource Reference (116 Resources)

### 👥 USERS & USER MANAGEMENT (10 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_user` | ✅ | User accounts |
| `okta_user_type` | ✅ | User types/categories |
| `okta_user_base_schema_property` | ✅ | Base schema attributes |
| `okta_user_schema_property` | ✅ | Custom user attributes |
| `okta_user_admin_roles` | - | Admin role assignments |
| `okta_user_group_memberships` | - | User's group memberships |
| `okta_user_factor_question` | - | Security question setup |
| `okta_factor` | ✅ | MFA factors (legacy) |
| `okta_factor_totp` | - | TOTP authenticator |
| `okta_security_notification_emails` | - | Security notification settings |

---

### 👪 GROUPS & GROUP MANAGEMENT (5 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_group` | ✅ | User groups |
| `okta_group_schema_property` | ✅ | Custom group attributes |
| `okta_group_rule` | ✅ | Dynamic membership rules |
| `okta_group_memberships` | - | Bulk membership management |
| `okta_group_owner` | - | Group ownership assignments |
| `okta_group_role` | - | Group role assignments |

---

### 📱 APPLICATIONS (24 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_app_oauth` | ✅ | OAuth/OIDC applications |
| `okta_app_saml` | ✅ | SAML 2.0 applications |
| `okta_app_basic_auth` | ✅ | Basic auth applications |
| `okta_app_bookmark` | ✅ | Bookmark applications |
| `okta_app_secure_password_store` | ✅ | SWA applications (legacy) |
| `okta_app_swa` | ✅ | Secure Web Authentication apps |
| `okta_app_shared_credentials` | - | Shared credentials apps |
| `okta_app_three_field` | ✅ | Three-field SWA apps |
| `okta_app_auto_login` | ✅ | Auto-login applications |
| `okta_app_user` | - | App user assignments |
| `okta_app_user_base_schema_property` | - | Base app user schema |
| `okta_app_user_schema_property` | - | Custom app user attributes |
| `okta_app_group_assignment` | - | Single group assignment |
| `okta_app_group_assignments` | - | Bulk group assignments |
| `okta_app_oauth_api_scope` | - | OAuth API scope grants |
| `okta_app_oauth_redirect_uri` | - | OAuth redirect URIs |
| `okta_app_oauth_post_logout_redirect_uri` | - | Post-logout redirect URIs |
| `okta_app_oauth_role_assignment` | - | OAuth role assignments |
| `okta_app_saml_app_settings` | - | SAML app-specific settings |
| `okta_app_signon_policy` | - | App sign-on policies |
| `okta_app_signon_policy_rule` | - | App sign-on policy rules |
| `okta_app_access_policy_assignment` | - | Access policy assignments |
| `okta_customized_signin_page` | - | Custom sign-in page per app |
| `okta_preview_signin_page` | - | Preview sign-in page |

---

### 🔐 AUTHORIZATION SERVERS & OAUTH (7 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_auth_server` | ✅ | Custom authorization servers |
| `okta_auth_server_default` | ✅ | Default authorization server |
| `okta_auth_server_policy` | ✅ | Auth server policies |
| `okta_auth_server_policy_rule` | ✅ | Auth server policy rules |
| `okta_auth_server_claim` | ✅ | Custom claims |
| `okta_auth_server_claim_default` | - | Default claims configuration |
| `okta_auth_server_scope` | ✅ | Custom OAuth scopes |

---

### 🔒 POLICIES (20 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_policy_mfa` | ✅ | MFA policies |
| `okta_policy_mfa_default` | - | Default MFA policy |
| `okta_policy_rule_mfa` | ✅ | MFA policy rules |
| `okta_policy_password` | ✅ | Password policies |
| `okta_policy_password_default` | - | Default password policy |
| `okta_policy_rule_password` | ✅ | Password policy rules |
| `okta_policy_signon` | ✅ | Sign-on policies |
| `okta_policy_rule_signon` | ✅ | Sign-on policy rules |
| `okta_policy_profile_enrollment` | - | Profile enrollment policies |
| `okta_policy_profile_enrollment_apps` | - | Enrollment policy apps |
| `okta_policy_rule_profile_enrollment` | - | Enrollment policy rules |
| `okta_policy_rule_idp_discovery` | - | IdP discovery rules |
| `okta_policy_device_assurance_windows` | - | Windows device assurance |
| `okta_policy_device_assurance_macos` | - | macOS device assurance |
| `okta_policy_device_assurance_android` | - | Android device assurance |
| `okta_policy_device_assurance_ios` | - | iOS device assurance |
| `okta_policy_device_assurance_chromeos` | - | ChromeOS device assurance |
| `okta_rate_limiting` | - | API rate limiting |
| `okta_threat_insight_settings` | - | Threat insight configuration |
| `okta_authenticator` | - | Authenticator configuration |

---

### 🌐 IDENTITY PROVIDERS & SOCIAL AUTH (4 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_idp_saml` | ✅ | SAML identity providers |
| `okta_idp_saml_key` | - | SAML signing keys |
| `okta_idp_oidc` | ✅ | OIDC identity providers |
| `okta_idp_social` | ✅ | Social identity providers |

---

### 🛡️ SECURITY & NETWORK (4 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_network_zone` | ✅ | Network zones (IP allowlists) |
| `okta_trusted_origin` | ✅ | CORS trusted origins |
| `okta_trusted_server` | - | Trusted servers |
| `okta_behavior` | - | Anomaly detection behaviors |

---

### 🎨 BRANDS, THEMES & CUSTOMIZATION (9 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_brand` | - | Organization brands |
| `okta_theme` | - | Custom themes |
| `okta_email_customization` | - | Email template customizations |
| `okta_email_template_settings` | - | Email template settings |
| `okta_email_domain` | - | Custom email domains |
| `okta_email_domain_verification` | - | Email domain verification |
| `okta_email_sender` | - | Email sender configuration |
| `okta_email_sender_verification` | - | Sender verification |
| `okta_email_smtp_server` | - | Custom SMTP server |

---

### 🌍 DOMAINS & CERTIFICATES (3 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_domain` | - | Custom domains |
| `okta_domain_certificate` | - | SSL certificates for domains |
| `okta_domain_verification` | - | Domain ownership verification |

---

### 🔗 HOOKS & EVENT HANDLERS (3 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_inline_hook` | ✅ | Inline hooks (sync) |
| `okta_event_hook` | ✅ | Event hooks (async) |
| `okta_event_hook_verification` | - | Event hook verification |

---

### 👔 OKTA IDENTITY GOVERNANCE (OIG) - v6.1.0+ (11 resources)

#### Terraform-Managed (11 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_campaign` | ❌ | Access certification campaigns (renamed from okta_reviews) |
| `okta_review` | ❌ | Individual access reviews |
| `okta_entitlement` | ❌ | Manual/custom entitlements only |
| `okta_request_condition` | ❌ | Access request conditions |
| `okta_request_sequence` | ❌ | Multi-stage approval workflows |
| `okta_request_setting_organization` | ❌ | Org-level request settings |
| `okta_request_setting_resource` | ❌ | Resource-level request settings |
| `okta_request_v2` | ❌ | Programmatic access requests |
| `okta_catalog_entry_default` | ❌ | Data source only (read-only) |
| `okta_catalog_entry_user_access_request_fields` | ❌ | Data source only (read-only) |
| `okta_end_user_my_requests` | ❌ | Data source only (read-only) |

**IMPORTANT:**
- `okta_campaign` is the new name for access review campaigns (formerly `okta_reviews`)
- `okta_entitlement` can ONLY manage **manual/custom entitlements**
- App-managed entitlements (Salesforce, Workday, etc.) are read-only
- Principal assignments (grants) should be managed in Okta Admin UI, not Terraform

#### API-Only (No Terraform Support)

| Resource | Management Method | API Endpoint |
|----------|-------------------|--------------|
| **Entitlement Bundles** | ❌ Terraform ✅ API | `/api/v1/governance/entitlement-bundles` |
| **Governance Labels** | ❌ Terraform ✅ API | `/api/v1/governance/labels` |
| **Resource Owners** | ❌ Terraform ✅ API | `/api/v1/governance/resource-owners` |

---

### 👨‍💼 ADMIN ROLES & PERMISSIONS (5 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_admin_role_custom` | - | Custom administrator roles |
| `okta_admin_role_custom_assignments` | - | Custom role assignments |
| `okta_admin_role_targets` | - | Role target restrictions |
| `okta_resource_set` | - | Resource sets for role assignments |
| `okta_role_subscription` | - | Role subscription management |

---

### ⚙️ ORG SETTINGS & CONFIGURATION (6 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_org_configuration` | - | Organization-level settings |
| `okta_org_support` | - | Support access settings |
| `okta_feature` | - | Feature flags/toggles |
| `okta_captcha` | - | CAPTCHA configuration |
| `okta_captcha_org_wide_settings` | - | Org-wide CAPTCHA settings |
| `okta_template_sms` | ✅ | SMS message templates |

---

### 🔗 LINKING & ASSOCIATIONS (3 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_link_definition` | - | Link type definitions |
| `okta_link_value` | - | Link values between resources |
| `okta_profile_mapping` | - | Attribute mapping between sources |

---

### 📊 LOGGING & MONITORING (1 resource)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_log_stream` | - | Log streaming to SIEM |

---

### 🌐 REALMS (BETA) (2 resources)

| Resource | Terraformer | Notes |
|----------|-------------|-------|
| `okta_realm` | - | Workforce Identity Realms |
| `okta_realm_assignment` | - | Realm user/group assignments |

---

## 📚 Complete Data Source Reference (63 Data Sources)

Data sources allow you to query existing resources without managing them in Terraform.

### 👥 User Data Sources (5)

| Data Source | Purpose |
|-------------|---------|
| `okta_user` | Query single user |
| `okta_users` | Query multiple users |
| `okta_user_type` | Query user types |
| `okta_user_profile_mapping_source` | Query profile mapping sources |
| `okta_user_security_questions` | Query available security questions |

---

### 👪 Group Data Sources (4)

| Data Source | Purpose |
|-------------|---------|
| `okta_group` | Query single group |
| `okta_groups` | Query multiple groups |
| `okta_everyone_group` | Query the Everyone group |
| `okta_group_rule` | Query group rules |

---

### 📱 Application Data Sources (8)

| Data Source | Purpose |
|-------------|---------|
| `okta_app` | Query single app (generic) |
| `okta_apps` | Query multiple apps |
| `okta_app_oauth` | Query OAuth app |
| `okta_app_saml` | Query SAML app |
| `okta_app_metadata_saml` | Query SAML metadata |
| `okta_app_signon_policy` | Query app sign-on policy |
| `okta_app_group_assignments` | Query app's group assignments |
| `okta_app_user_assignments` | Query app's user assignments |

---

### 🔐 Authorization Server Data Sources (5)

| Data Source | Purpose |
|-------------|---------|
| `okta_auth_server` | Query custom auth server |
| `okta_auth_server_policy` | Query auth server policy |
| `okta_auth_server_claim` | Query custom claims |
| `okta_auth_server_claims` | Query all claims |
| `okta_auth_server_scopes` | Query all scopes |

---

### 🔒 Policy Data Sources (2)

| Data Source | Purpose |
|-------------|---------|
| `okta_policy` | Query policies by type |
| `okta_default_policy` | Query default policies |
| `okta_device_assurance_policy` | Query device assurance policies |

---

### 🛡️ Security Data Sources (4)

| Data Source | Purpose |
|-------------|---------|
| `okta_authenticator` | Query authenticator config |
| `okta_behavior` | Query single behavior |
| `okta_behaviors` | Query all behaviors |
| `okta_network_zone` | Query network zones |
| `okta_trusted_origins` | Query trusted origins |

---

### 🌐 Identity Provider Data Sources (4)

| Data Source | Purpose |
|-------------|---------|
| `okta_idp_oidc` | Query OIDC IdP |
| `okta_idp_saml` | Query SAML IdP |
| `okta_idp_social` | Query social IdP |
| `okta_idp_metadata_saml` | Query SAML IdP metadata |

---

### 🎨 Branding Data Sources (6)

| Data Source | Purpose |
|-------------|---------|
| `okta_brand` | Query single brand |
| `okta_brands` | Query all brands |
| `okta_theme` | Query single theme |
| `okta_themes` | Query all themes |
| `okta_email_customization` | Query email customization |
| `okta_email_customizations` | Query all email customizations |
| `okta_default_signin_page` | Query default sign-in page |

---

### 📧 Email Data Sources (4)

| Data Source | Purpose |
|-------------|---------|
| `okta_email_template` | Query single email template |
| `okta_email_templates` | Query all email templates |
| `okta_email_smtp_server` | Query SMTP configuration |
| `okta_domain` | Query custom domains |

---

### 👔 OIG Data Sources (7)

| Data Source | Purpose |
|-------------|---------|
| `okta_campaign` | Query access review campaign |
| `okta_review` | Query individual review |
| `okta_entitlement` | Query entitlements |
| `okta_principal_entitlements` | Query principal's entitlements |
| `okta_catalog_entry_default` | Query catalog entries |
| `okta_catalog_entry_user_access_request_fields` | Query request fields |
| `okta_end_user_my_requests` | Query user's access requests |
| `okta_request_condition` | Query request conditions |
| `okta_request_sequence` | Query approval sequences |
| `okta_request_setting_organization` | Query org request settings |
| `okta_request_setting_resource` | Query resource request settings |
| `okta_request_v2` | Query access requests |

---

### ⚙️ Organization Data Sources (5)

| Data Source | Purpose |
|-------------|---------|
| `okta_org_metadata` | Query org metadata |
| `okta_features` | Query enabled features |
| `okta_role_subscription` | Query role subscriptions |
| `okta_log_stream` | Query log streams |
| `okta_realm` | Query realms |
| `okta_realm_assignment` | Query realm assignments |

---

## 🎯 Resource Management Best Practices

### Use Case 1: Import Existing Infrastructure

**Tool:** Terraformer
**Supported:** ~90 resources (basic Okta resources)
**Workflow:** `import-all-resources.yml`

```bash
# Import from existing tenant
gh workflow run import-all-resources.yml \
  -f tenant_environment=LowerDeckLabs \
  -f update_terraform=true \
  -f commit_changes=true

# Resources imported:
# - Users, Groups, Apps, Policies
# - Authorization Servers
# - Identity Providers
# - Network Zones, Hooks, etc.
```

---

### Use Case 2: Create New Resources

**Tool:** Manual Terraform
**Supported:** All 116 resources
**Location:** `environments/<env>/terraform/`

```hcl
# Create any resource type
resource "okta_user" "new_user" {
  email      = "user@example.com"
  first_name = "John"
  last_name  = "Doe"
  login      = "user@example.com"
}

resource "okta_campaign" "quarterly_review" {
  name = "Q1 2025 Access Review"
  # Campaign configuration...
}
```

---

### Use Case 3: OIG Governance via API

**Tool:** Python API Scripts
**Supported:** Entitlement Bundles, Labels, Resource Owners
**Workflow:** API scripts in `scripts/`

```bash
# Import entitlement bundles (read-only documentation)
python3 scripts/import_oig_resources.py \
  --output-dir environments/lowerdecklabs/imports

# Sync resource owners
python3 scripts/sync_owner_mappings.py \
  --output environments/lowerdecklabs/config/owner_mappings.json

# Apply resource owners
python3 scripts/apply_resource_owners.py \
  --config environments/lowerdecklabs/config/owner_mappings.json
```

---

## 📖 Additional Resources

- **Official Docs:** https://registry.terraform.io/providers/okta/okta/latest/docs
- **Provider Repo:** https://github.com/okta/terraform-provider-okta
- **Resource Examples:** `environments/lowerdecklabs/terraform/RESOURCE_EXAMPLES.tf`
- **API Scripts:** `scripts/` directory

---

## 🔄 Version History

| Date | Version | Provider Version | Changes |
|------|---------|------------------|---------|
| 2025-11-07 | 2.0 | v6.1.0+ | Complete resource matrix - all 116 resources + 63 data sources |
| 2025-11-07 | 1.0 | v6.1.0+ | Initial comprehensive resource matrix |

---

**Questions?** Refer to the [Terraform Registry](https://registry.terraform.io/providers/okta/okta/latest/docs) for detailed resource documentation.
