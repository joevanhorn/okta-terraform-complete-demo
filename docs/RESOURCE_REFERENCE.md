# Okta Terraform Resource Reference

This document provides detailed explanations of all attributes used in the Okta Terraform resources in this configuration.

---

## Table of Contents

1. [okta_user](#okta_user)
2. [okta_group](#okta_group)
3. [okta_app_oauth](#okta_app_oauth)
4. [okta_auth_server_default](#okta_auth_server_default)
5. [okta_policy_mfa_default](#okta_policy_mfa_default)

---

## okta_user

Manages Okta user accounts.

### Basic Attributes

#### `email` (Required)
- **Type:** String
- **Description:** Primary email address of the user
- **Example:** `"john.doe@example.com"`
- **Notes:** Must be unique across the Okta organization

#### `first_name` (Required)
- **Type:** String
- **Description:** User's first/given name
- **Example:** `"John"`
- **Notes:** Displayed in Okta dashboard and user profile

#### `last_name` (Required)
- **Type:** String
- **Description:** User's last/family name
- **Example:** `"Doe"`
- **Notes:** Displayed in Okta dashboard and user profile

#### `login` (Required)
- **Type:** String
- **Description:** Unique identifier for the user to log in
- **Example:** `"john.doe@example.com"`
- **Notes:**
  - Must be unique across the organization
  - Often the same as email but can be different
  - Cannot be changed after creation

### Profile Attributes

#### `city` (Optional)
- **Type:** String
- **Description:** City where the user is located
- **Example:** `"San Francisco"`
- **Notes:** Part of the user's profile, used for reporting

#### `country_code` (Optional)
- **Type:** String
- **Description:** Two-letter country code (ISO 3166-1 alpha-2)
- **Example:** `"US"`
- **Valid Values:** Any valid ISO country code
- **Notes:** Used for localization and compliance

#### `department` (Optional)
- **Type:** String
- **Description:** Department or team the user belongs to
- **Example:** `"Engineering"`
- **Notes:** Useful for grouping and reporting

#### `state` (Optional)
- **Type:** String
- **Description:** State/province where the user is located
- **Example:** `"CA"` or `"California"`
- **Notes:** Can be abbreviation or full name

#### `title` (Optional)
- **Type:** String
- **Description:** User's job title
- **Example:** `"Senior Software Engineer"`
- **Notes:** Displayed in user profile

#### `mobile_phone` (Optional)
- **Type:** String
- **Description:** User's mobile phone number in E.164 format
- **Example:** `"+14155551234"`
- **Format:** Must start with `+` followed by country code
- **Notes:** Used for SMS-based MFA

#### `custom_profile_attributes` (Optional)
- **Type:** String (JSON)
- **Description:** Custom profile attributes as JSON string
- **Example:** `"{\"customField1\": \"value1\"}"`
- **Default:** `"{}"`
- **Notes:** For custom schema attributes defined in your Okta org

### Status and Behavior

#### `status` (Optional)
- **Type:** String
- **Description:** Lifecycle status of the user
- **Valid Values:**
  - `"ACTIVE"` - User is active and can log in
  - `"PROVISIONED"` - User created but not yet activated
  - `"STAGED"` - User account created but email not sent
  - `"DEPROVISIONED"` - User account deactivated
  - `"SUSPENDED"` - User account temporarily suspended
- **Default:** `"ACTIVE"`
- **Example:** `"ACTIVE"`
- **Notes:**
  - Setting to `"ACTIVE"` sends activation email
  - Changing between states follows Okta's lifecycle rules

#### `expire_password_on_create` (Optional)
- **Type:** Boolean
- **Description:** Force user to change password on first login
- **Default:** `false`
- **Example:** `false`
- **Notes:** Security best practice for new accounts

#### `skip_roles` (Optional)
- **Type:** Boolean
- **Description:** Skip processing of assigned roles during user creation
- **Default:** `false`
- **Notes:** Internal Terraform optimization flag

### Computed Attributes (Read-Only)

#### `id`
- **Type:** String
- **Description:** Unique identifier assigned by Okta
- **Example:** `"00u1234567890abcdef"`
- **Notes:** Generated automatically, used for imports and references

#### `raw_status`
- **Type:** String
- **Description:** The raw status value from Okta API
- **Notes:** May differ from `status` during transitions

### Example

```hcl
resource "okta_user" "john_doe" {
  # Required fields
  email      = "john.doe@example.com"
  first_name = "John"
  last_name  = "Doe"
  login      = "john.doe@example.com"

  # Profile fields
  city         = "San Francisco"
  country_code = "US"
  department   = "Engineering"
  mobile_phone = "+14155551234"
  state        = "CA"
  title        = "Senior Software Engineer"

  # Custom attributes
  custom_profile_attributes = jsonencode({
    employeeNumber = "EMP001"
    startDate      = "2024-01-15"
  })

  # Status
  status                    = "ACTIVE"
  expire_password_on_create = false
}
```

---

## okta_group

Manages Okta groups for organizing users.

### Attributes

#### `name` (Required)
- **Type:** String
- **Description:** Display name of the group
- **Example:** `"Engineering Team"`
- **Notes:** Must be unique within the organization

#### `description` (Optional)
- **Type:** String
- **Description:** Human-readable description of the group's purpose
- **Example:** `"Engineering team members with access to development resources"`
- **Notes:** Helps document the group's intended use

#### `custom_profile_attributes` (Optional)
- **Type:** String (JSON)
- **Description:** Custom attributes for the group as JSON string
- **Example:** `"{}"`
- **Default:** `"{}"`
- **Notes:** For custom schema attributes on group objects

### Computed Attributes

#### `id`
- **Type:** String
- **Description:** Unique identifier assigned by Okta
- **Example:** `"00g1234567890abcdef"`

### Example

```hcl
resource "okta_group" "engineering" {
  name                      = "Engineering Team"
  description               = "Engineering team members with access to development resources"
  custom_profile_attributes = "{}"
}
```

### Group Membership

Group membership is typically managed separately using `okta_group_memberships` or `okta_user_group_memberships` resources (not shown in this configuration).

---

## okta_app_oauth

Manages OAuth 2.0 / OIDC applications in Okta.

### Basic Configuration

#### `label` (Required)
- **Type:** String
- **Description:** Display name of the application
- **Example:** `"Internal CRM System"`
- **Notes:** Shown in Okta Admin Console and user dashboard

#### `type` (Required)
- **Type:** String
- **Description:** OAuth application type
- **Valid Values:**
  - `"web"` - Web application (server-side)
  - `"native"` - Native/mobile application
  - `"browser"` - Single-page application
  - `"service"` - Service/machine-to-machine app
- **Example:** `"web"`
- **Notes:** Determines available grant types and security settings

### OAuth 2.0 Configuration

#### `grant_types` (Required for most types)
- **Type:** List of strings
- **Description:** OAuth 2.0 grant types supported by the application
- **Valid Values:**
  - `"authorization_code"` - Authorization Code flow
  - `"implicit"` - Implicit flow (deprecated)
  - `"password"` - Resource Owner Password flow
  - `"client_credentials"` - Client Credentials flow
  - `"refresh_token"` - Refresh token support
  - `"urn:ietf:params:oauth:grant-type:saml2-bearer"` - SAML 2.0 bearer
  - `"urn:ietf:params:oauth:grant-type:jwt-bearer"` - JWT bearer
- **Example:** `["authorization_code", "refresh_token"]`
- **Notes:**
  - Choose based on your application architecture
  - `authorization_code` is most secure for web apps

#### `response_types` (Required for most types)
- **Type:** List of strings
- **Description:** OAuth response types the app expects
- **Valid Values:**
  - `"code"` - Authorization code
  - `"token"` - Access token (implicit flow)
  - `"id_token"` - ID token (OpenID Connect)
- **Example:** `["code"]`
- **Notes:** Should match your grant types

#### `redirect_uris` (Required for web/native/browser)
- **Type:** List of strings
- **Description:** Valid OAuth redirect/callback URIs
- **Example:** `["https://myapp.example.com/callback"]`
- **Notes:**
  - Must use HTTPS in production (except localhost)
  - Wildcards not allowed (use exact matches)
  - Must be whitelisted for security

#### `post_logout_redirect_uris` (Optional)
- **Type:** List of strings
- **Description:** Valid URIs to redirect to after logout
- **Example:** `["https://myapp.example.com/logout"]`
- **Notes:** OIDC logout endpoint redirect destinations

### Client Authentication

#### `token_endpoint_auth_method` (Required)
- **Type:** String
- **Description:** How the client authenticates with the token endpoint
- **Valid Values:**
  - `"client_secret_basic"` - HTTP Basic with client ID/secret
  - `"client_secret_post"` - Client secret in POST body
  - `"client_secret_jwt"` - Client secret as JWT
  - `"private_key_jwt"` - Private key JWT (most secure)
  - `"none"` - No authentication (public clients)
- **Example:** `"client_secret_post"`
- **Notes:**
  - `private_key_jwt` most secure, requires JWKS
  - `none` only for browser-based apps with PKCE

#### `pkce_required` (Optional)
- **Type:** Boolean or String
- **Description:** Whether PKCE (Proof Key for Code Exchange) is required
- **Valid Values:** `true`, `false`, or `"true"`, `"false"` (string)
- **Default:** `false`
- **Example:** `true`
- **Notes:**
  - **Highly recommended** for mobile and SPA apps
  - Security best practice even for confidential clients
  - Prevents authorization code interception

### Key Configuration (for private_key_jwt)

#### `jwks` (Optional, Required for private_key_jwt)
- **Type:** Block
- **Description:** JSON Web Key Set for client authentication
- **Example:**
  ```hcl
  jwks {
    kty = "RSA"
    e   = "AQAB"
    n   = "lKl3Wk7VzPgARVBQ..."
    kid = "my-key-id"
  }
  ```
- **Attributes:**
  - `kty` - Key type (usually "RSA")
  - `e` - RSA public exponent
  - `n` - RSA modulus
  - `kid` - Key ID for identification

### Application Settings

#### `client_uri` (Optional)
- **Type:** String
- **Description:** URL of the application's home page
- **Example:** `"https://myapp.example.com"`
- **Notes:** Shown in consent screens

#### `consent_method` (Optional)
- **Type:** String
- **Description:** How user consent is handled
- **Valid Values:**
  - `"REQUIRED"` - User must consent
  - `"TRUSTED"` - Auto-consent for trusted apps
- **Default:** `"TRUSTED"`
- **Example:** `"REQUIRED"`
- **Notes:** Third-party apps should use `"REQUIRED"`

#### `auto_key_rotation` (Optional)
- **Type:** Boolean or String
- **Description:** Whether Okta automatically rotates client secrets
- **Default:** `true`
- **Example:** `true`
- **Notes:** Security best practice to enable

#### `refresh_token_rotation` (Optional)
- **Type:** String
- **Description:** Refresh token rotation policy
- **Valid Values:**
  - `"STATIC"` - Refresh tokens don't rotate
  - `"ROTATE_ON_USE"` - New token issued on each use (requires additional config)
- **Default:** `"STATIC"`
- **Example:** `"STATIC"`
- **Notes:** Based on testing, `"STATIC"` has better compatibility

#### `refresh_token_leeway` (Optional)
- **Type:** Number
- **Description:** Grace period (in seconds) for refresh token rotation
- **Default:** `0`
- **Example:** `0`

### Visibility and Access

#### `hide_ios` (Optional)
- **Type:** Boolean or String
- **Description:** Hide app from Okta Mobile (iOS)
- **Default:** `false`
- **Example:** `true`
- **Notes:** Set to `true` for backend/API apps

#### `hide_web` (Optional)
- **Type:** Boolean or String
- **Description:** Hide app from Okta Web Dashboard
- **Default:** `false`
- **Example:** `true`
- **Notes:** Set to `true` for backend/API apps

#### `login_mode` (Optional)
- **Type:** String
- **Description:** Application login/initiation mode
- **Valid Values:**
  - `"DISABLED"` - No IdP-initiated login
  - `"SPEC"` - Application-specific login page
  - `"OKTA"` - Okta-hosted login
- **Default:** `"DISABLED"`
- **Example:** `"DISABLED"`
- **Important Constraint:**
  - Cannot be `"DISABLED"` if `hide_ios = false` OR `hide_web = false`
  - If using `"SPEC"`, must also provide `login_uri`

#### `login_uri` (Conditional)
- **Type:** String
- **Description:** Application-specific login initiation URL
- **Required:** When `login_mode = "SPEC"`
- **Example:** `"https://myapp.example.com/login"`

### User Management

#### `user_name_template` (Optional)
- **Type:** String
- **Description:** Template for username in the application
- **Example:** `"${source.login}"`
- **Default:** `"${source.login}"`
- **Important:** Must escape with `$$` in Terraform:
  ```hcl
  user_name_template = "$${source.login}"
  ```
- **Available Variables:**
  - `${source.login}` - User's Okta login
  - `${source.email}` - User's email
  - `${source.firstName}` - User's first name
  - `${source.lastName}` - User's last name

#### `user_name_template_type` (Optional)
- **Type:** String
- **Description:** Type of username template
- **Valid Values:**
  - `"BUILT_IN"` - Okta built-in template
  - `"CUSTOM"` - Custom template
- **Default:** `"BUILT_IN"`
- **Example:** `"BUILT_IN"`

#### `user_name_template_suffix` (Optional)
- **Type:** String
- **Description:** Suffix to append to usernames
- **Example:** `"@myapp.com"`

#### `user_name_template_push_status` (Optional)
- **Type:** String
- **Description:** Status of username template push to app
- **Notes:** Typically managed by Okta

### Advanced Settings

#### `implicit_assignment` (Optional)
- **Type:** Boolean or String
- **Description:** Automatically assign all users to the app
- **Default:** `false`
- **Example:** `false`
- **Notes:**
  - Security risk - explicitly assign users instead
  - Useful for internal apps everyone should access

#### `accessibility_self_service` (Optional)
- **Type:** Boolean or String
- **Description:** Allow users to request access via self-service
- **Default:** `false`
- **Example:** `false`

#### `auto_submit_toolbar` (Optional)
- **Type:** Boolean or String
- **Description:** Auto-submit credentials from Okta browser extension
- **Default:** `false`
- **Example:** `false`

#### `issuer_mode` (Optional)
- **Type:** String
- **Description:** How the issuer identifier is formatted
- **Valid Values:**
  - `"ORG_URL"` - Use organization URL as issuer
  - `"CUSTOM_URL"` - Use custom authorization server
  - `"DYNAMIC"` - Dynamic based on request
- **Default:** `"ORG_URL"`
- **Example:** `"ORG_URL"`

#### `wildcard_redirect` (Optional)
- **Type:** String
- **Description:** Allow wildcard in redirect URIs
- **Valid Values:**
  - `"DISABLED"` - No wildcards allowed (recommended)
  - `"SUBDOMAIN"` - Subdomain wildcards allowed
- **Default:** `"DISABLED"`
- **Example:** `"DISABLED"`
- **Notes:** **Security risk** - avoid in production

#### `status` (Optional)
- **Type:** String
- **Description:** Application status
- **Valid Values:**
  - `"ACTIVE"` - Application is active
  - `"INACTIVE"` - Application is deactivated
- **Default:** `"ACTIVE"`
- **Example:** `"ACTIVE"`

### JSON Settings

#### `app_links_json` (Optional)
- **Type:** String (JSON)
- **Description:** Application links configuration as JSON
- **Example:** `"{\"oidc_client_link\":true}"`
- **Notes:** Controls which links appear in user dashboard

#### `app_settings_json` (Optional)
- **Type:** String (JSON)
- **Description:** Application-specific settings as JSON
- **Example:** `"{}"`
- **Notes:** App-specific configuration

### Authentication Policy

#### `authentication_policy` (Optional)
- **Type:** String
- **Description:** ID of the authentication policy to use
- **Example:** `"rstrf0wlwjAEOO9IS1d7"`
- **Notes:** Controls sign-on requirements (MFA, etc.)

### Computed Attributes

#### `id`
- **Type:** String
- **Description:** Application ID
- **Example:** `"0oa1234567890abcdef"`

#### `client_id` (For OAuth apps)
- **Type:** String
- **Description:** OAuth client ID
- **Example:** `"0oarfddbqbmYn6AvT1d7"`
- **Notes:** Used in OAuth flows

#### `client_secret` (Sensitive)
- **Type:** String
- **Description:** OAuth client secret
- **Notes:**
  - **Sensitive** - not shown in logs
  - Store securely (vault, secrets manager)

#### `name`
- **Type:** String
- **Description:** Internal Okta name for the app
- **Example:** `"oidc_client"`

#### `sign_on_mode`
- **Type:** String
- **Description:** Sign-on mode (computed from type)
- **Example:** `"OPENID_CONNECT"`

#### `logo_url`
- **Type:** String
- **Description:** URL of the application logo
- **Example:** `"https://example.com/logo.png"`

### Example: Web Application

```hcl
resource "okta_app_oauth" "my_web_app" {
  # Basic config
  label = "My Web Application"
  type  = "web"

  # OAuth configuration
  grant_types    = ["authorization_code", "refresh_token"]
  response_types = ["code"]
  redirect_uris  = ["https://myapp.example.com/callback"]
  post_logout_redirect_uris = ["https://myapp.example.com/logout"]

  # Security
  pkce_required              = true
  token_endpoint_auth_method = "client_secret_post"
  consent_method             = "REQUIRED"

  # Application settings
  client_uri                 = "https://myapp.example.com"
  auto_key_rotation          = true
  refresh_token_rotation     = "STATIC"

  # Visibility
  hide_ios   = true
  hide_web   = true
  login_mode = "DISABLED"

  # User mapping
  user_name_template      = "$${source.login}"
  user_name_template_type = "BUILT_IN"

  # Advanced
  implicit_assignment = false
  wildcard_redirect   = "DISABLED"
  status              = "ACTIVE"

  # JSON settings
  app_links_json    = jsonencode({ oidc_client_link = true })
  app_settings_json = jsonencode({})
}
```

### Example: Service Application (M2M)

```hcl
resource "okta_app_oauth" "api_service" {
  label = "Backend API Service"
  type  = "service"

  grant_types    = ["client_credentials"]
  response_types = ["token"]

  token_endpoint_auth_method = "private_key_jwt"

  jwks {
    kty = "RSA"
    e   = "AQAB"
    n   = "your-rsa-modulus-here"
    kid = "service-key-1"
  }

  hide_ios   = true
  hide_web   = true
  login_mode = "DISABLED"

  user_name_template      = "$${source.login}"
  user_name_template_type = "BUILT_IN"
}
```

---

## okta_auth_server_default

Manages the default Okta authorization server.

### Attributes

#### `id` (Computed)
- **Type:** String
- **Description:** Authorization server ID
- **Value:** `"default"`
- **Notes:** The default auth server always has ID "default"

### Notes

The default authorization server is automatically created by Okta and has limited configuration options via Terraform. Most settings are managed through:
- Scopes (via `okta_auth_server_scope`)
- Claims (via `okta_auth_server_claim`)
- Policies (via `okta_auth_server_policy`)

### Example

```hcl
resource "okta_auth_server_default" "default" {
  # No configuration needed - just declares management
}
```

---

## okta_policy_mfa_default

Manages the default Multi-Factor Authentication (MFA) policy.

### Attributes

#### `id` (Computed)
- **Type:** String
- **Description:** Policy ID
- **Example:** `"00p1234567890abcdef"`
- **Notes:** Auto-assigned by Okta

### Notes

The default MFA policy is automatically created by Okta. Configuration typically includes:
- Which MFA factors are enabled
- Factor enrollment requirements
- Policy rules

These are typically managed via:
- `okta_policy_rule_mfa` for specific rules
- Okta Admin Console for factor settings

### Example

```hcl
resource "okta_policy_mfa_default" "default" {
  # No configuration needed - just declares management
}
```

---

## Common Patterns

### Template String Escaping

**Problem:** Okta uses `${variable}` for templates, Terraform uses `${}` for interpolation

**Solution:** Escape with double `$$`:

```hcl
# ❌ WRONG - Terraform tries to interpolate
user_name_template = "${source.login}"

# ✅ CORRECT - Literal string passed to Okta
user_name_template = "$${source.login}"
```

### Boolean vs String Booleans

Some attributes accept both `true` (boolean) and `"true"` (string):

```hcl
# Both valid
hide_ios = true
hide_ios = "true"

# Recommended: Use boolean for clarity
hide_ios = true
```

### JSON-Encoded Settings

Use `jsonencode()` for complex settings:

```hcl
app_settings_json = jsonencode({
  setting1 = "value1"
  setting2 = 123
  nested = {
    key = "value"
  }
})
```

### Secure Credential Management

**Never hardcode secrets:**

```hcl
# ❌ BAD
variable "api_token" {
  default = "00H_actual_token_here"
}

# ✅ GOOD - Use environment variables
variable "api_token" {
  type      = string
  sensitive = true
}

# ✅ GOOD - Use external secret managers
data "aws_secretsmanager_secret_version" "okta_token" {
  secret_id = "okta/api-token"
}
```

---

## Additional Resources

- [Okta Terraform Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)
- [Okta API Reference](https://developer.okta.com/docs/reference/)
- [OAuth 2.0 Specification](https://oauth.net/2/)
- [OpenID Connect Specification](https://openid.net/connect/)
- [PKCE Specification](https://oauth.net/2/pkce/)

---

## Version Information

This reference is based on:
- **Okta Terraform Provider:** v6.1.0
- **Terraform:** >= 1.9.0

Some attributes may differ in other versions. Always check the official provider documentation for your specific version.

---

## Contributing

Found an error or missing attribute? Please submit a pull request or open an issue!

Last updated: 2025-11-04
