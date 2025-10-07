# advanced-oig-examples.tf
# Advanced Okta Identity Governance configurations

# ============================================
# Multi-Stage Approval Workflows
# ============================================

# Complex approval sequence with conditional logic
resource "okta_request_sequences" "executive_approval" {
  name        = "Executive Access Approval"
  description = "Multi-stage approval for sensitive applications"

  step {
    order          = 1
    name           = "Direct Manager"
    approver_type  = "manager"
    required_count = 1
  }

  step {
    order          = 2
    name           = "Department Head"
    approver_type  = "manager"
    required_count = 1
    # Approves manager of manager
  }

  step {
    order          = 3
    name           = "Security Team"
    approver_type  = "group"
    required_count = 2
    approver_ids   = [okta_group.security_team.id]
  }

  step {
    order          = 4
    name           = "Executive Sponsor"
    approver_type  = "user"
    required_count = 1
    approver_ids   = [var.executive_sponsor_id]
  }
}

# ============================================
# Conditional Access Based on Risk
# ============================================

resource "okta_request_conditions" "high_risk_conditions" {
  name        = "High Risk Access Conditions"
  description = "Stricter conditions for high-risk applications"

  # Department restrictions
  condition {
    type  = "user_attribute"
    key   = "department"
    value = "Engineering,Security,IT"
  }

  # Employment status check
  condition {
    type  = "user_attribute"
    key   = "employeeType"
    value = "Full-time"
  }

  # Minimum tenure requirement
  condition {
    type  = "user_attribute"
    key   = "hireDate"
    value = "before:-90d"  # Employed for at least 90 days
  }

  # Background check required
  condition {
    type  = "user_attribute"
    key   = "backgroundCheckStatus"
    value = "Completed"
  }

  # Not in terminated state
  condition {
    type     = "user_status"
    value    = "ACTIVE"
    operator = "equals"
  }
}

resource "okta_request_conditions" "low_risk_conditions" {
  name        = "Standard Access Conditions"
  description = "Basic conditions for low-risk applications"

  condition {
    type  = "user_status"
    value = "ACTIVE"
  }

  condition {
    type  = "user_attribute"
    key   = "employeeType"
    value = "Full-time,Contractor"
  }
}

# ============================================
# Different Catalog Entries by App Sensitivity
# ============================================

# High-sensitivity app (production database)
resource "okta_catalog_entry_default" "production_db" {
  app_id      = okta_app_saml.production_database.id
  name        = "Production Database Access"
  description = "Request access to production database (requires extensive approval)"

  approval_workflow_id = okta_request_sequences.executive_approval.id
  request_condition_id = okta_request_conditions.high_risk_conditions.id

  auto_approve          = false
  allow_self_request    = true
  max_duration_days     = 30
  default_duration_days = 7
  require_mfa           = true

  notification_settings {
    notify_on_approval = true
    notify_on_denial   = true
    notify_on_expiry   = true
  }
}

# Low-sensitivity app (internal wiki)
resource "okta_catalog_entry_default" "wiki" {
  app_id      = okta_app_saml.internal_wiki.id
  name        = "Internal Wiki Access"
  description = "Request access to company wiki"

  approval_workflow_id = okta_request_sequences.standard_approval.id
  request_condition_id = okta_request_conditions.low_risk_conditions.id

  auto_approve          = true  # Auto-approve for low risk
  allow_self_request    = true
  max_duration_days     = 365
  default_duration_days = 365
}

# ============================================
# Custom Request Fields by App Type
# ============================================

# Detailed fields for high-risk applications
resource "okta_catalog_entry_user_access_request_fields" "production_db_fields" {
  catalog_entry_id = okta_catalog_entry_default.production_db.id

  field {
    name        = "business_justification"
    label       = "Business Justification"
    type        = "textarea"
    required    = true
    description = "Provide detailed business justification"
    max_length  = 1000
  }

  field {
    name        = "ticket_number"
    label       = "JIRA Ticket Number"
    type        = "text"
    required    = true
    description = "Related JIRA ticket (e.g., PROD-1234)"
    pattern     = "^[A-Z]+-[0-9]+$"
  }

  field {
    name        = "access_type"
    label       = "Access Type"
    type        = "select"
    required    = true
    options     = ["read", "read-write", "admin"]
    description = "Level of access required"
  }

  field {
    name        = "data_classification"
    label       = "Data Classification Level"
    type        = "select"
    required    = true
    options     = ["public", "internal", "confidential", "restricted"]
  }

  field {
    name        = "emergency_access"
    label       = "Is this emergency access?"
    type        = "boolean"
    required    = true
    description = "Check if this is an emergency production issue"
  }

  field {
    name        = "manager_approval_email"
    label       = "Manager Pre-Approval Email"
    type        = "text"
    required    = false
    description = "Forward of manager's pre-approval (optional)"
  }
}

# Simple fields for low-risk applications
resource "okta_catalog_entry_user_access_request_fields" "wiki_fields" {
  catalog_entry_id = okta_catalog_entry_default.wiki.id

  field {
    name        = "reason"
    label       = "Reason for Access"
    type        = "text"
    required    = true
    description = "Brief reason for needing access"
  }
}

# ============================================
# Comprehensive Entitlement Mappings
# ============================================

# Engineering team entitlements
resource "okta_principal_entitlements" "engineering_entitlements" {
  principal_id   = okta_group.engineering_team.id
  principal_type = "GROUP"

  # Development tools
  entitlement {
    resource_id   = okta_app_oauth.github.id
    resource_type = "APP"
    permission    = "USER"
  }

  entitlement {
    resource_id   = okta_app_saml.jira.id
    resource_type = "APP"
    permission    = "USER"
  }

  entitlement {
    resource_id   = okta_app_saml.confluence.id
    resource_type = "APP"
    permission    = "USER"
  }

  # Group memberships
  entitlement {
    resource_id   = okta_group.dev_environment_access.id
    resource_type = "GROUP"
    permission    = "MEMBER"
  }
}

# Security team entitlements (broader access)
resource "okta_principal_entitlements" "security_entitlements" {
  principal_id   = okta_group.security_team.id
  principal_type = "GROUP"

  # Security tools
  entitlement {
    resource_id   = okta_app_saml.splunk.id
    resource_type = "APP"
    permission    = "ADMIN"
  }

  entitlement {
    resource_id   = okta_app_saml.security_scanner.id
    resource_type = "APP"
    permission    = "ADMIN"
  }

  # Production access
  entitlement {
    resource_id   = okta_app_saml.production_database.id
    resource_type = "APP"
    permission    = "USER"
  }

  entitlement {
    resource_id   = okta_group.production_access.id
    resource_type = "GROUP"
    permission    = "MEMBER"
  }
}

# ============================================
# Different Review Campaigns by Risk Level
# ============================================

# Monthly review for high-risk apps
resource "okta_reviews" "high_risk_monthly_review" {
  name        = "Monthly High-Risk Access Review"
  description = "Monthly certification of production and sensitive system access"

  schedule {
    frequency  = "MONTHLY"
    start_date = "2025-01-01"
    day_of_month = 1
    timezone   = "America/Los_Angeles"
  }

  # Scope to high-risk applications
  scope {
    resource_type = "APP"
    resource_ids = [
      okta_app_saml.production_database.id,
      okta_app_saml.payment_system.id,
      okta_app_saml.customer_pii_system.id,
    ]
  }

  # Multiple reviewer types
  reviewers {
    type = "MANAGER"
  }

  reviewers {
    type     = "USER"
    user_ids = [var.security_lead_id, var.compliance_lead_id]
  }

  reviewers {
    type     = "GROUP"
    group_ids = [okta_group.security_team.id]
  }

  settings {
    auto_close_after_days     = 7   # Shorter window for high risk
    reminder_after_days       = 3
    require_justification     = true
    allow_delegation          = false  # No delegation for high risk
    auto_revoke_noncompliant  = true
    escalation_user_id        = var.ciso_id
  }
}

# Quarterly review for standard apps
resource "okta_reviews" "standard_quarterly_review" {
  name        = "Quarterly Standard Access Review"
  description = "Quarterly certification of standard application access"

  schedule {
    frequency  = "QUARTERLY"
    start_date = "2025-01-15"
    timezone   = "America/Los_Angeles"
  }

  scope {
    resource_type = "APP"
    resource_ids = [
      okta_app_saml.internal_wiki.id,
      okta_app_saml.jira.id,
      okta_app_saml.confluence.id,
    ]
  }

  reviewers {
    type = "MANAGER"
  }

  settings {
    auto_close_after_days    = 14
    reminder_after_days      = 7
    require_justification    = false
    allow_delegation         = true
    auto_revoke_noncompliant = false
  }
}

# Annual review for all group memberships
resource "okta_reviews" "annual_group_review" {
  name        = "Annual Group Membership Review"
  description = "Annual certification of all group memberships"

  schedule {
    frequency  = "ANNUALLY"
    start_date = "2025-12-01"
    timezone   = "America/Los_Angeles"
  }

  scope {
    resource_type = "GROUP"
    resource_ids = [
      okta_group.engineering_team.id,
      okta_group.security_team.id,
      okta_group.finance_team.id,
      okta_group.hr_team.id,
    ]
  }

  reviewers {
    type = "MANAGER"
  }

  reviewers {
    type     = "USER"
    user_ids = [var.hr_director_id]
  }

  settings {
    auto_close_after_days    = 30
    reminder_after_days      = 14
    require_justification    = true
    allow_delegation         = true
  }
}

# ============================================
# Programmatic Access Requests
# ============================================

# Bulk access requests for new hires
resource "okta_request_v2" "new_hire_requests" {
  for_each = toset(var.new_hire_user_ids)

  catalog_entry_id = okta_catalog_entry_default.standard_app_bundle.id
  requestor_id     = each.value

  justification = "New hire onboarding - standard application access"
  duration_days = 365

  custom_fields = {
    reason        = "New employee onboarding"
    start_date    = formatdate("YYYY-MM-DD", timestamp())
    department    = "Engineering"
  }
}

# Emergency access request with short duration
resource "okta_request_v2" "emergency_db_access" {
  catalog_entry_id = okta_catalog_entry_default.production_db.id
  requestor_id     = var.oncall_engineer_id

  justification = "P1 incident response - database investigation required"
  duration_days = 1  # Emergency access for 24 hours only

  custom_fields = {
    business_justification = "P1 production incident #INC-2025-001"
    ticket_number         = "INC-2025-001"
    access_type           = "read"
    data_classification   = "restricted"
    emergency_access      = "true"
  }

  # Auto-revoke after incident resolution
  lifecycle {
    create_before_destroy = false
  }
}

# ============================================
# Query User Requests for Reporting
# ============================================

# Get all pending requests for dashboard
data "okta_end_user_my_requests" "all_pending" {
  user_id = var.current_user_id
  status  = ["PENDING"]
}

# Get approved requests for audit
data "okta_end_user_my_requests" "approved_last_90_days" {
  user_id    = var.current_user_id
  status     = ["APPROVED"]
  created_after = timeadd(timestamp(), "-2160h")  # 90 days
}

# ============================================
# Outputs for Monitoring
# ============================================

output "high_risk_review_id" {
  description = "ID of high-risk monthly review campaign"
  value       = okta_reviews.high_risk_monthly_review.id
}

output "pending_requests_count" {
  description = "Number of pending access requests"
  value       = length(data.okta_end_user_my_requests.all_pending.requests)
}

output "production_catalog_entry" {
  description = "Production database catalog entry details"
  value = {
    id                    = okta_catalog_entry_default.production_db.id
    approval_workflow_id  = okta_catalog_entry_default.production_db.approval_workflow_id
    max_duration_days     = okta_catalog_entry_default.production_db.max_duration_days
  }
}
