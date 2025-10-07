# integrated-api-management.tf
# Integrates Python API manager with Terraform

# ============================================
# Generate API Configuration from Terraform
# ============================================

# Generate configuration file with Terraform outputs
resource "local_file" "api_config" {
  filename = "${path.module}/api_config.json"
  
  content = jsonencode({
    okta_org_name  = var.okta_org_name
    okta_api_token = var.okta_api_token
    
    labels = [
      { name = "high-risk", description = "High-risk applications requiring strict governance" },
      { name = "production", description = "Production environment resources" },
      { name = "pci-compliant", description = "Resources subject to PCI compliance" },
      { name = "sox-compliant", description = "Resources subject to SOX compliance" },
      { name = "customer-data", description = "Resources containing customer data" },
      { name = "financial-data", description = "Resources containing financial information" },
      { name = "hr-data", description = "Resources containing HR and employee data" },
      { name = "development", description = "Development environment resources" },
      { name = "staging", description = "Staging environment resources" }
    ]
    
    resource_owners = concat(
      # App owners
      [
        for app_config in var.app_owner_configs : {
          description     = "Assign owners for ${app_config.app_name}"
          principal_type  = "user"
          principal_ids   = app_config.owner_user_ids
          resource_type   = "app"
          resource_ids    = [app_config.app_id]
          app_type        = app_config.app_type
        }
      ],
      # Group owners
      [
        for group_config in var.group_owner_configs : {
          description    = "Assign owners for ${group_config.group_name}"
          principal_type = "user"
          principal_ids  = group_config.owner_user_ids
          resource_type  = "group"
          resource_ids   = [group_config.group_id]
        }
      ]
    )
    
    label_assignments = concat(
      # App label assignments
      [
        for assignment in var.app_label_assignments : {
          label_name    = assignment.label_name
          resource_type = "app"
          resource_ids  = assignment.app_ids
          app_type      = assignment.app_type
        }
      ],
      # Group label assignments
      [
        for assignment in var.group_label_assignments : {
          label_name    = assignment.label_name
          resource_type = "group"
          resource_ids  = assignment.group_ids
        }
      ]
    )
    
    query_resources = concat(
      [for app in var.app_owner_configs : 
        "orn:okta:idp:${var.okta_org_name}:apps:${app.app_type}:${app.app_id}"
      ],
      [for group in var.group_owner_configs : 
        "orn:okta:directory:${var.okta_org_name}:groups:${group.group_id}"
      ]
    )
  })
  
  file_permission = "0600"
}

# ============================================
# Apply API Configuration
# ============================================

resource "null_resource" "apply_api_config" {
  # Trigger when config changes
  triggers = {
    config_hash = local_file.api_config.content
    timestamp   = timestamp()
  }
  
  # Apply configuration using Python script
  provisioner "local-exec" {
    command = <<-EOT
      python3 ${path.module}/scripts/okta_api_manager.py \
        --action apply \
        --config ${local_file.api_config.filename}
    EOT
    
    environment = {
      PYTHONPATH = "${path.module}/scripts"
    }
  }
  
  # Destroy configuration when removed
  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
      python3 ${path.module}/scripts/okta_api_manager.py \
        --action destroy \
        --config ${self.triggers.config_hash}
    EOT
    
    on_failure = continue
  }
  
  depends_on = [
    local_file.api_config,
    okta_app_oauth.demo_app,
    okta_group.demo_group
  ]
}

# ============================================
# Variables for API Management
# ============================================

variable "app_owner_configs" {
  description = "Configuration for app resource owners"
  type = list(object({
    app_name       = string
    app_id         = string
    app_type       = string
    owner_user_ids = list(string)
  }))
  default = []
}

variable "group_owner_configs" {
  description = "Configuration for group resource owners"
  type = list(object({
    group_name     = string
    group_id       = string
    owner_user_ids = list(string)
  }))
  default = []
}

variable "app_label_assignments" {
  description = "Label assignments for applications"
  type = list(object({
    label_name = string
    app_ids    = list(string)
    app_type   = string
  }))
  default = []
}

variable "group_label_assignments" {
  description = "Label assignments for groups"
  type = list(object({
    label_name = string
    group_ids  = list(string)
  }))
  default = []
}

# ============================================
# Example Usage
# ============================================

# Configure owners and labels for demo app
locals {
  demo_app_owners = [
    {
      app_name       = "Demo OAuth App"
      app_id         = okta_app_oauth.demo_app.id
      app_type       = "oauth2"
      owner_user_ids = [var.admin_user_id]
    }
  ]
  
  demo_group_owners = [
    {
      group_name     = "Demo Group"
      group_id       = okta_group.demo_group.id
      owner_user_ids = [var.admin_user_id]
    }
  ]
  
  demo_app_labels = [
    {
      label_name = "production"
      app_ids    = [okta_app_oauth.demo_app.id]
      app_type   = "oauth2"
    },
    {
      label_name = "customer-data"
      app_ids    = [okta_app_oauth.demo_app.id]
      app_type   = "oauth2"
    }
  ]
  
  demo_group_labels = [
    {
      label_name = "production"
      group_ids  = [okta_group.demo_group.id]
    }
  ]
}

# Pass to API management
module "api_management" {
  source = "./modules/api-management"
  
  okta_org_name  = var.okta_org_name
  okta_api_token = var.okta_api_token
  
  app_owner_configs       = local.demo_app_owners
  group_owner_configs     = local.demo_group_owners
  app_label_assignments   = local.demo_app_labels
  group_label_assignments = local.demo_group_labels
  
  depends_on = [
    okta_app_oauth.demo_app,
    okta_group.demo_group
  ]
}

# ============================================
# Query API-Managed Resources
# ============================================

# Query resource owners after applying
data "external" "resource_owners_state" {
  program = ["python3", "${path.module}/scripts/okta_api_manager.py", 
             "--action", "query", 
             "--config", local_file.api_config.filename]
  
  depends_on = [null_resource.apply_api_config]
}

# ============================================
# Outputs
# ============================================

output "api_config_file" {
  description = "Path to generated API configuration file"
  value       = local_file.api_config.filename
}

output "api_managed_resources" {
  description = "Summary of API-managed resources"
  value = {
    app_owners_configured   = length(var.app_owner_configs)
    group_owners_configured = length(var.group_owner_configs)
    app_labels_assigned     = length(var.app_label_assignments)
    group_labels_assigned   = length(var.group_label_assignments)
  }
}
