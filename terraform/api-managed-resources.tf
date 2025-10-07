# api-managed-resources.tf
# Manages Okta OIG resources not yet in Terraform provider via API calls

# ============================================
# Resource Owners Management
# ============================================

# Assign resource owners to the demo application
resource "null_resource" "app_resource_owners" {
  # Trigger re-creation when app or owners change
  triggers = {
    app_id    = okta_app_oauth.demo_app.id
    owners    = join(",", var.app_owner_user_ids)
    timestamp = timestamp()
  }

  # Create resource owners on creation
  provisioner "local-exec" {
    command = <<-EOT
      curl -X PUT "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/resource-owners" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d '{
          "principalOrns": ${jsonencode([for id in var.app_owner_user_ids : "orn:okta:directory:${var.okta_org_name}:users:${id}"])},
          "resourceOrns": ["orn:okta:idp:${var.okta_org_name}:apps:oauth2:${okta_app_oauth.demo_app.id}"]
        }'
    EOT
  }

  # Remove resource owners on deletion
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      curl -X PATCH "https://${self.triggers.app_id}.${var.okta_base_url}/governance/api/v1/resource-owners" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "resourceOrn": "orn:okta:idp:${var.okta_org_name}:apps:oauth2:${self.triggers.app_id}",
          "data": [
            {
              "op": "REMOVE",
              "path": "/principalOrn",
              "value": "orn:okta:directory:${var.okta_org_name}:users:*"
            }
          ]
        }'
    EOT
  }

  depends_on = [okta_app_oauth.demo_app]
}

# Assign resource owners to the demo group
resource "null_resource" "group_resource_owners" {
  triggers = {
    group_id  = okta_group.demo_group.id
    owners    = join(",", var.group_owner_user_ids)
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -X PUT "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/resource-owners" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "principalOrns": ${jsonencode([for id in var.group_owner_user_ids : "orn:okta:directory:${var.okta_org_name}:users:${id}"])},
          "resourceOrns": ["orn:okta:directory:${var.okta_org_name}:groups:${okta_group.demo_group.id}"]
        }'
    EOT
  }

  depends_on = [okta_group.demo_group]
}

# ============================================
# Labels Management
# ============================================

# Create governance labels for resource classification
resource "null_resource" "create_labels" {
  for_each = toset(var.governance_labels)

  triggers = {
    label_name = each.value
    timestamp  = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      curl -X POST "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/labels" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "name": "${each.value}",
          "description": "Governance label: ${each.value}"
        }'
    EOT
  }

  # Note: Labels don't have a DELETE endpoint in the API currently
  # They need to be managed manually if you need to remove them
}

# Apply labels to resources
resource "null_resource" "apply_app_labels" {
  triggers = {
    app_id    = okta_app_oauth.demo_app.id
    labels    = join(",", var.app_labels)
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Apply each label to the app
      ${join("\n", [for label in var.app_labels : <<-LABEL
      curl -X PUT "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/labels/${label}/resources" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "resourceOrns": ["orn:okta:idp:${var.okta_org_name}:apps:oauth2:${okta_app_oauth.demo_app.id}"]
        }'
      LABEL
      ])}
    EOT
  }

  depends_on = [
    okta_app_oauth.demo_app,
    null_resource.create_labels
  ]
}

resource "null_resource" "apply_group_labels" {
  triggers = {
    group_id  = okta_group.demo_group.id
    labels    = join(",", var.group_labels)
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      ${join("\n", [for label in var.group_labels : <<-LABEL
      curl -X PUT "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/labels/${label}/resources" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "resourceOrns": ["orn:okta:directory:${var.okta_org_name}:groups:${okta_group.demo_group.id}"]
        }'
      LABEL
      ])}
    EOT
  }

  depends_on = [
    okta_group.demo_group,
    null_resource.create_labels
  ]
}

# ============================================
# Query Resource Owners (Data Source)
# ============================================

# Query existing resource owners for an app
data "external" "app_resource_owners" {
  program = ["bash", "-c", <<-EOT
    curl -s "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/resource-owners?filter=parentResourceOrn%20eq%20%22orn:okta:idp:${var.okta_org_name}:apps:oauth2:${okta_app_oauth.demo_app.id}%22" \
      -H "Authorization: SSWS ${var.okta_api_token}" \
      -H "Accept: application/json" | jq '{owners: [.data[].principals[].id] | join(",")}'
  EOT
  ]

  depends_on = [
    okta_app_oauth.demo_app,
    null_resource.app_resource_owners
  ]
}

# Query resources without owners
data "external" "unassigned_resources" {
  program = ["bash", "-c", <<-EOT
    curl -s "https://${var.okta_org_name}.${var.okta_base_url}/governance/api/v1/resource-owners/catalog/resources?filter=parentResourceOrn%20eq%20%22orn:okta:idp:${var.okta_org_name}:apps:oauth2:${okta_app_oauth.demo_app.id}%22" \
      -H "Authorization: SSWS ${var.okta_api_token}" \
      -H "Accept: application/json" | jq '{count: (.data | length | tostring)}'
  EOT
  ]

  depends_on = [okta_app_oauth.demo_app]
}

# ============================================
# Variables for API Resources
# ============================================

variable "app_owner_user_ids" {
  description = "List of user IDs to assign as resource owners for the demo app"
  type        = list(string)
  default     = []
}

variable "group_owner_user_ids" {
  description = "List of user IDs to assign as resource owners for the demo group"
  type        = list(string)
  default     = []
}

variable "governance_labels" {
  description = "List of governance labels to create"
  type        = list(string)
  default = [
    "high-risk",
    "production",
    "pci-compliant",
    "sox-compliant",
    "customer-data",
    "financial-data",
    "hr-data"
  ]
}

variable "app_labels" {
  description = "Labels to apply to the demo app"
  type        = list(string)
  default     = ["production", "customer-data"]
}

variable "group_labels" {
  description = "Labels to apply to the demo group"
  type        = list(string)
  default     = ["production"]
}

# ============================================
# Outputs
# ============================================

output "app_resource_owners" {
  description = "Resource owners assigned to the demo app"
  value       = try(data.external.app_resource_owners.result.owners, "none")
}

output "unassigned_resources_count" {
  description = "Count of resources without assigned owners"
  value       = try(data.external.unassigned_resources.result.count, "0")
}

output "applied_labels" {
  description = "Labels applied to resources"
  value = {
    app_labels   = var.app_labels
    group_labels = var.group_labels
  }
}
