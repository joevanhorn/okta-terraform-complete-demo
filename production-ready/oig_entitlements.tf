# =============================================================================
# OKTA IDENTITY GOVERNANCE - ENTITLEMENTS
# =============================================================================
# Principal entitlements represent access bundles that can be assigned to users
# Only MANUAL entitlements can be managed in Terraform
# App-managed entitlements (e.g., from Salesforce, Workday) are READ-ONLY
# =============================================================================

# -----------------------------------------------------------------------------
# Admin Entitlements (Privileged Access)
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "salesforce_admin" {
  # Salesforce Administrator Access - Full system administration
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Privileged

  # principal {
  #   id   = "00u1234567890abcdef"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_salesforce_admin_001"
  #   name = "Salesforce System Administrator"
  # }
}

resource "okta_principal_entitlements" "workday_admin" {
  # Workday Administrator Access - HR system administration
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Privileged

  # principal {
  #   id   = "00u9876543210fedcba"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_workday_admin_002"
  #   name = "Workday Admin Console Access"
  # }
}

resource "okta_principal_entitlements" "aws_admin" {
  # AWS Administrator Access - Cloud infrastructure administration
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Privileged

  # principal {
  #   id   = "00u5678901234abcdef"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_aws_admin_003"
  #   name = "AWS Administrator Access"
  # }
}

resource "okta_principal_entitlements" "okta_super_admin" {
  # Okta Super Administrator - Full Okta administration
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Privileged

  # principal {
  #   id   = "00u2345678901bcdefg"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_okta_superadmin_004"
  #   name = "Okta Super Administrator"
  # }
}

# -----------------------------------------------------------------------------
# Standard Entitlements (Non-Privileged)
# -----------------------------------------------------------------------------

resource "okta_principal_entitlements" "salesforce_user" {
  # Salesforce Standard User Access - Basic CRM functionality
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Standard

  # principal {
  #   id   = "00u3456789012cdefgh"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_salesforce_user_005"
  #   name = "Salesforce Standard User"
  # }
}

resource "okta_principal_entitlements" "jira_user" {
  # JIRA Standard User Access - Ticket creation and viewing
  # TODO: Configure with actual principal and entitlement IDs after import
  # Label: Standard

  # principal {
  #   id   = "00u4567890123defghi"
  #   type = "USER"
  # }

  # entitlement {
  #   id   = "ent_jira_user_006"
  #   name = "JIRA Standard User"
  # }
}

# =============================================================================
# NOTES
# =============================================================================
#
# Entitlements with "admin" in the resource name are flagged for:
# - Privileged label assignment
# - Enhanced access review frequency
# - Additional approval requirements
# - Security monitoring
#
# To import existing entitlements, use:
#   python3 scripts/import_oig_resources.py --output-dir imported_oig
#
# To apply labels to these entitlements, use:
#   python3 scripts/okta_api_manager.py --action apply --config config/api_config.json
#
# =============================================================================
