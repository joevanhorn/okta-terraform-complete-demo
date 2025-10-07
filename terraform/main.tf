terraform {
  required_version = ">= 1.9.0"
  
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.1.0"
    }
  }

  # Configure backend for state management
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "okta/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

# ============================================
# Core Okta Resources
# ============================================

# Create a sample group
resource "okta_group" "demo_group" {
  name        = "OIG Demo Group"
  description = "Group for Okta Identity Governance demonstration"
}

# Create sample users
resource "okta_user" "demo_users" {
  count = 3

  first_name = "Demo"
  last_name  = "User${count.index + 1}"
  login      = "demo.user${count.index + 1}@example.com"
  email      = "demo.user${count.index + 1}@example.com"
  status     = "ACTIVE"
}

# Add users to group
resource "okta_group_memberships" "demo_membership" {
  group_id = okta_group.demo_group.id
  users    = [for user in okta_user.demo_users : user.id]
}

# Create an app for access requests
resource "okta_app_oauth" "demo_app" {
  label                      = "OIG Demo Application"
  type                       = "web"
  grant_types                = ["authorization_code"]
  redirect_uris              = ["https://example.com/callback"]
  response_types             = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  
  lifecycle {
    ignore_changes = [groups]
  }
}

# ============================================
# NEW OIG Resources (v6.1.0)
# ============================================

# Configure request settings for access requests
resource "okta_request_settings" "demo_settings" {
  require_approval              = true
  require_manager_approval      = true
  allow_self_approval           = false
  require_justification         = true
  max_duration_days             = 30
  default_duration_days         = 7
  allow_extend_requests         = true
  expiration_notification_days  = 3
}

# Define request conditions
resource "okta_request_conditions" "demo_conditions" {
  name        = "Standard Access Conditions"
  description = "Conditions for standard access requests"
  
  condition {
    type  = "user_attribute"
    key   = "department"
    value = "Engineering,Sales"
  }

  condition {
    type  = "group_membership"
    value = okta_group.demo_group.id
  }
}

# Create a request sequence (approval workflow)
resource "okta_request_sequences" "demo_sequence" {
  name        = "Standard Approval Workflow"
  description = "Two-stage approval workflow"

  step {
    order          = 1
    name           = "Manager Approval"
    approver_type  = "manager"
    required_count = 1
  }

  step {
    order          = 2
    name           = "Admin Approval"
    approver_type  = "admin"
    required_count = 1
    approver_ids   = [var.admin_user_id]
  }
}

# Configure catalog entry for the demo app
resource "okta_catalog_entry_default" "demo_app_catalog" {
  app_id      = okta_app_oauth.demo_app.id
  name        = "Demo Application Access"
  description = "Request access to the demo application"
  
  approval_workflow_id = okta_request_sequences.demo_sequence.id
  request_condition_id = okta_request_conditions.demo_conditions.id
  
  auto_approve          = false
  allow_self_request    = true
  max_duration_days     = 90
  default_duration_days = 30
}

# Define custom fields for access requests
resource "okta_catalog_entry_user_access_request_fields" "demo_fields" {
  catalog_entry_id = okta_catalog_entry_default.demo_app_catalog.id

  field {
    name        = "business_justification"
    label       = "Business Justification"
    type        = "text"
    required    = true
    description = "Please provide business justification for access"
  }

  field {
    name        = "project_code"
    label       = "Project Code"
    type        = "text"
    required    = false
    description = "Project code if applicable"
  }

  field {
    name        = "access_level"
    label       = "Access Level"
    type        = "select"
    required    = true
    options     = ["read", "write", "admin"]
  }
}

# Define principal entitlements (what users get access to)
resource "okta_principal_entitlements" "demo_entitlements" {
  principal_id   = okta_group.demo_group.id
  principal_type = "GROUP"

  entitlement {
    resource_id   = okta_app_oauth.demo_app.id
    resource_type = "APP"
    permission    = "USER"
  }

  entitlement {
    resource_id   = okta_group.demo_group.id
    resource_type = "GROUP"
    permission    = "MEMBER"
  }
}

# Create an access review campaign
resource "okta_reviews" "quarterly_review" {
  name        = "Quarterly Access Review"
  description = "Quarterly review of application and group access"
  
  schedule {
    frequency = "QUARTERLY"
    start_date = "2025-01-01"
    timezone   = "America/Los_Angeles"
  }

  scope {
    resource_type = "APP"
    resource_ids  = [okta_app_oauth.demo_app.id]
  }

  scope {
    resource_type = "GROUP"
    resource_ids  = [okta_group.demo_group.id]
  }

  reviewers {
    type = "MANAGER"
  }

  reviewers {
    type       = "USER"
    user_ids   = [var.admin_user_id]
  }

  settings {
    auto_close_after_days   = 14
    reminder_after_days     = 7
    require_justification   = true
    allow_delegation        = true
  }
}

# Data source to query end user's access requests
data "okta_end_user_my_requests" "user_requests" {
  user_id = okta_user.demo_users[0].id
  status  = ["PENDING", "APPROVED"]
}

# Create an access request (v2 API)
resource "okta_request_v2" "demo_request" {
  catalog_entry_id = okta_catalog_entry_default.demo_app_catalog.id
  requestor_id     = okta_user.demo_users[0].id
  
  justification = "Need access for Q1 project work"
  duration_days = 30

  custom_fields = {
    business_justification = "Working on customer portal project"
    project_code          = "PROJ-2025-001"
    access_level          = "write"
  }
}

# ============================================
# Outputs
# ============================================

output "demo_group_id" {
  description = "ID of the demo group"
  value       = okta_group.demo_group.id
}

output "demo_app_id" {
  description = "ID of the demo application"
  value       = okta_app_oauth.demo_app.id
}

output "demo_app_client_id" {
  description = "Client ID of the demo application"
  value       = okta_app_oauth.demo_app.client_id
  sensitive   = true
}

output "catalog_entry_id" {
  description = "ID of the catalog entry"
  value       = okta_catalog_entry_default.demo_app_catalog.id
}

output "review_campaign_id" {
  description = "ID of the access review campaign"
  value       = okta_reviews.quarterly_review.id
}

output "access_request_id" {
  description = "ID of the demo access request"
  value       = okta_request_v2.demo_request.id
}

output "user_requests" {
  description = "End user's access requests"
  value       = data.okta_end_user_my_requests.user_requests
}
