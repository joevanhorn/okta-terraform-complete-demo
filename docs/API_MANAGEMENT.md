# Okta OIG API Management Guide

This guide explains how to manage **Resource Owners** and **Labels** using the Okta API, complementing the Terraform provider.

## 📋 Overview

While the Okta Terraform Provider v6.1.0 adds support for many OIG features, some capabilities are only available via REST API:

- **Resource Owners API** - Assign owners to apps, groups, and entitlements
- **Labels API** - Create and assign governance labels to resources

This implementation uses a Python script integrated with Terraform to manage these resources.

## 🏗️ Architecture

```
┌─────────────────┐
│   Terraform     │
│                 │
│  - Core OIG     │
│  - Resources    │
│  - Reviews      │
│  - Requests     │
└────────┬────────┘
         │
         │ generates
         ▼
┌─────────────────┐
│  api_config.json│
└────────┬────────┘
         │
         │ consumed by
         ▼
┌─────────────────┐
│  Python Script  │
│                 │
│  - Owners API   │
│  - Labels API   │
└────────┬────────┘
         │
         │ calls
         ▼
┌─────────────────┐
│   Okta OIG API  │
└─────────────────┘
```

## 📦 Components

### 1. Python API Manager (`okta_api_manager.py`)

A comprehensive Python script that:
- Creates and manages governance labels
- Assigns resource owners to apps, groups, and entitlements
- Queries existing configurations
- Handles rate limiting and retries
- Provides idempotent operations

### 2. Terraform Integration

Terraform resources that:
- Generate API configuration from Terraform state
- Execute Python script via `local-exec` provisioners
- Manage lifecycle (create/update/destroy)
- Pass credentials securely

### 3. Configuration File (`api_config.json`)

JSON configuration containing:
- Label definitions
- Resource owner assignments
- Label-to-resource mappings

## 🚀 Quick Start

### Prerequisites

```bash
# Install Python dependencies
pip install requests

# Ensure Python 3.8+ is available
python3 --version
```

### Basic Setup

1. **Add Python script to your repository:**

```bash
mkdir -p scripts
# Copy okta_api_manager.py to scripts/
chmod +x scripts/okta_api_manager.py
```

2. **Configure in Terraform:**

```hcl
# In your terraform/main.tf or separate file

variable "app_owner_configs" {
  type = list(object({
    app_name       = string
    app_id         = string
    app_type       = string
    owner_user_ids = list(string)
  }))
  default = [{
    app_name       = "My App"
    app_id         = "0oa1234567890abcdef"
    app_type       = "oauth2"
    owner_user_ids = ["00u10sfroCwbHQO4a0g4"]
  }]
}

module "api_management" {
  source = "./modules/api-management"
  
  okta_org_name       = var.okta_org_name
  okta_api_token      = var.okta_api_token
  app_owner_configs   = var.app_owner_configs
}
```

3. **Apply configuration:**

```bash
terraform init
terraform plan
terraform apply
```

## 🔧 Configuration Examples

### Resource Owners

#### Assign User Owners to an App

```json
{
  "resource_owners": [
    {
      "description": "App owners for production CRM",
      "principal_type": "user",
      "principal_ids": [
        "00u10sfroCwbHQO4a0g4",
        "00u6yl0Q065H4BCPR0g4"
      ],
      "resource_type": "app",
      "resource_ids": ["0oa1234567890abcdef"],
      "app_type": "saml2"
    }
  ]
}
```

#### Assign Group Owners

```json
{
  "resource_owners": [
    {
      "description": "Engineering team group owner",
      "principal_type": "user",
      "principal_ids": ["00u10sfroCwbHQO4a0g4"],
      "resource_type": "group",
      "resource_ids": ["00g1234567890abcdef"]
    }
  ]
}
```

#### Assign Group as Owner (Delegated Ownership)

```json
{
  "resource_owners": [
    {
      "description": "Admin group owns production apps",
      "principal_type": "group",
      "principal_ids": ["00g10ctakVI6XlTdk0g4"],
      "resource_type": "app",
      "resource_ids": [
        "0oa1111111111111111",
        "0oa2222222222222222"
      ],
      "app_type": "oauth2"
    }
  ]
}
```

### Labels

#### Create Governance Labels

```json
{
  "labels": [
    {
      "name": "high-risk",
      "description": "High-risk applications requiring strict governance"
    },
    {
      "name": "pci-compliant",
      "description": "Resources subject to PCI DSS compliance"
    },
    {
      "name": "production",
      "description": "Production environment resources"
    }
  ]
}
```

#### Apply Labels to Applications

```json
{
  "label_assignments": [
    {
      "label_name": "high-risk",
      "resource_type": "app",
      "resource_ids": [
        "0oa1234567890abcdef",
        "0oa9876543210fedcba"
      ],
      "app_type": "saml2"
    }
  ]
}
```

#### Apply Labels to Groups

```json
{
  "label_assignments": [
    {
      "label_name": "production",
      "resource_type": "group",
      "resource_ids": [
        "00g1234567890abcdef",
        "00g9876543210fedcba"
      ]
    }
  ]
}
```

#### Apply Multiple Labels

```json
{
  "label_assignments": [
    {
      "label_name": "production",
      "resource_type": "app",
      "resource_ids": ["0oa1234567890abcdef"],
      "app_type": "oauth2"
    },
    {
      "label_name": "pci-compliant",
      "resource_type": "app",
      "resource_ids": ["0oa1234567890abcdef"],
      "app_type": "oauth2"
    },
    {
      "label_name": "customer-data",
      "resource_type": "app",
      "resource_ids": ["0oa1234567890abcdef"],
      "app_type": "oauth2"
    }
  ]
}
```

## 🎯 Use Cases

### Use Case 1: Automated Owner Assignment for New Apps

When creating apps via Terraform, automatically assign owners:

```hcl
resource "okta_app_oauth" "new_app" {
  label = "New Application"
  type  = "web"
  # ... other config
}

locals {
  new_app_owners = [{
    app_name       = okta_app_oauth.new_app.label
    app_id         = okta_app_oauth.new_app.id
    app_type       = "oauth2"
    owner_user_ids = [
      var.app_owner_id,
      var.backup_owner_id
    ]
  }]
}
```

**Benefits:**
- Ensures all apps have designated owners
- Automatic reviewer assignment for access certifications
- Clear accountability for app management

### Use Case 2: Compliance Labeling

Automatically label apps based on compliance requirements:

```hcl
locals {
  pci_apps = [
    okta_app_oauth.payment_system.id,
    okta_app_saml.billing_system.id
  ]
  
  sox_apps = [
    okta_app_saml.financial_reporting.id,
    okta_app_oauth.accounting_system.id
  ]
  
  compliance_labels = [
    {
      label_name = "pci-compliant"
      app_ids    = local.pci_apps
      app_type   = "oauth2"
    },
    {
      label_name = "sox-compliant"
      app_ids    = local.sox_apps
      app_type   = "saml2"
    }
  ]
}
```

**Benefits:**
- Consistent compliance tracking
- Easy filtering in access reviews
- Audit trail for compliance resources

### Use Case 3: Environment-Based Labeling

Label resources by environment:

```hcl
locals {
  production_resources = {
    apps = [
      okta_app_oauth.prod_api.id,
      okta_app_saml.prod_portal.id
    ]
    groups = [
      okta_group.prod_users.id,
      okta_group.prod_admins.id
    ]
  }
  
  environment_labels = [
    {
      label_name = "production"
      app_ids    = local.production_resources.apps
      app_type   = "oauth2"
    },
    {
      label_name = "production"
      group_ids  = local.production_resources.groups
    }
  ]
}
```

### Use Case 4: Delegated Group Ownership

Assign group ownership to team leads:

```hcl
locals {
  team_group_owners = [
    {
      group_name     = "Engineering Team"
      group_id       = okta_group.engineering.id
      owner_user_ids = [var.engineering_lead_id]
    },
    {
      group_name     = "Sales Team"
      group_id       = okta_group.sales.id
      owner_user_ids = [var.sales_lead_id]
    },
    {
      group_name     = "HR Team"
      group_id       = okta_group.hr.id
      owner_user_ids = [var.hr_director_id]
    }
  ]
}
```

**Benefits:**
- Decentralized group management
- Owners automatically review group memberships
- Clear escalation path for access requests

## 🔍 Querying Resource Owners and Labels

### Query via Python Script

```bash
# Query all resource owners and labels
python3 scripts/okta_api_manager.py \
  --action query \
  --config api_config.json
```

### Query via API (curl examples)

```bash
# List all labels
curl -X GET "https://your-org.okta.com/governance/api/v1/labels?limit=200" \
  -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
  -H "Accept: application/json"

# List resource owners for an app
APP_ORN="orn:okta:idp:your-org:apps:oauth2:0oa1234567890abcdef"
FILTER="parentResourceOrn%20eq%20%22${APP_ORN}%22"

curl -X GET "https://your-org.okta.com/governance/api/v1/resource-owners?filter=${FILTER}" \
  -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
  -H "Accept: application/json"

# List resources with a specific label
curl -X GET "https://your-org.okta.com/governance/api/v1/labels/high-risk/resources?limit=200" \
  -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
  -H "Accept: application/json"

# List resources without owners
curl -X GET "https://your-org.okta.com/governance/api/v1/resource-owners/catalog/resources?filter=${FILTER}" \
  -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
  -H "Accept: application/json"
```

### Query via Terraform Data Source

```hcl
data "external" "app_owners" {
  program = [
    "python3",
    "${path.module}/scripts/okta_api_manager.py",
    "--action", "query",
    "--config", local_file.api_config.filename
  ]
}

output "current_owners" {
  value = data.external.app_owners.result
}
```

## 🔐 Security Best Practices

### 1. Credential Management

```hcl
# ✅ GOOD: Use variables and environment variables
variable "okta_api_token" {
  type      = string
  sensitive = true
}

# ❌ BAD: Never hardcode tokens
# okta_api_token = "00abcd1234..."
```

### 2. File Permissions

```bash
# Set restrictive permissions on config files
chmod 600 api_config.json
chmod 600 terraform.tfvars

# Add to .gitignore
echo "api_config.json" >> .gitignore
echo "*.tfvars" >> .gitignore
```

### 3. Least Privilege

Ensure API token has only required scopes:
- `okta.governance.accessRequests.manage`
- `okta.governance.accessReviews.manage`
- `okta.governance.catalogs.manage`
- `okta.governance.resources.manage`
- `okta.apps.read` (if querying apps)
- `okta.groups.read` (if querying groups)

### 4. Audit Logging

Monitor API calls in Okta System Log:
```
Target: governance/api/v1/resource-owners
Target: governance/api/v1/labels
```

## 🐛 Troubleshooting

### Issue: Rate Limiting

**Error:** `429 Too Many Requests`

**Solution:**
The Python script includes automatic retry with exponential backoff. For large deployments:

```python
# Adjust in okta_api_manager.py
max_retries = 5  # Increase retries
retry_delay = 5  # Increase base delay
```

### Issue: Invalid ORN Format

**Error:** `Invalid resource ORN`

**Solution:**
Verify ORN format matches Okta's specification:
- Apps: `orn:okta:idp:${org}:apps:${type}:${id}`
- Groups: `orn:okta:directory:${org}:groups:${id}`
- Users: `orn:okta:directory:${org}:users:${id}`

```bash
# Debug ORN generation
terraform console
> local.demo_app_owners[0].app_id
> "orn:okta:idp:${var.okta_org_name}:apps:oauth2:${okta_app_oauth.demo_app.id}"
```

### Issue: Owners Not Appearing in UI

**Symptom:** API calls succeed but owners don't show in Okta Admin Console

**Solution:**
- Clear browser cache
- Wait 1-2 minutes for UI sync
- Verify via API query
- Check that OIG is fully enabled in your org

### Issue: Label Already Exists

**Error:** `409 Conflict - Label already exists`

**Solution:**
Script handles this gracefully. To delete and recreate:

```bash
# Labels don't have a DELETE endpoint yet
# Must remove via Okta Admin Console
```

### Issue: Python Script Not Found

**Error:** `No such file or directory: scripts/okta_api_manager.py`

**Solution:**
```bash
# Verify file location
ls -la scripts/okta_api_manager.py

# Ensure execute permissions
chmod +x scripts/okta_api_manager.py

# Check path in Terraform
cat integrated-api-management.tf | grep okta_api_manager.py
```

## 📊 Monitoring and Reporting

### Create Compliance Report

```python
# compliance_report.py
import json
from okta_api_manager import OktaAPIManager

manager = OktaAPIManager(org_name, base_url, api_token)

# Get all labels
labels = manager.list_labels()

# For each compliance label, list resources
for label in labels['data']:
    if 'compliant' in label['name']:
        resources = manager.list_resources_by_label(label['name'])
        print(f"\n{label['name']}: {len(resources['data'])} resources")
        
# Find resources without owners
unassigned = manager.list_unassigned_resources(parent_orn)
print(f"\nResources without owners: {len(unassigned['data'])}")
```

### Automated Ownership Audit

```bash
#!/bin/bash
# audit_owners.sh

echo "=== Resource Owner Audit ==="
python3 scripts/okta_api_manager.py --action query --config api_config.json | \
  jq '.resource_owners[] | {resource: .resource.id, owners: [.principals[].email]}'
```

## 🚀 CI/CD Integration

The Python script integrates seamlessly with GitHub Actions (already included in the main workflow).

### Additional CI/CD Examples

#### GitLab CI

```yaml
apply_api_config:
  stage: apply
  script:
    - pip install requests
    - python3 scripts/okta_api_manager.py --action apply --config api_config.json
  only:
    - main
```

#### Jenkins

```groovy
stage('Apply OIG API Config') {
    steps {
        sh '''
            pip3 install requests
            python3 scripts/okta_api_manager.py \
              --action apply \
              --config api_config.json \
              --org-name ${OKTA_ORG_NAME} \
              --api-token ${OKTA_API_TOKEN}
        '''
    }
}
```

## 📚 API Reference

### Resource Owners API

- **Endpoint:** `/governance/api/v1/resource-owners`
- **Documentation:** [Okta Resource Owners API](https://developer.okta.com/docs/api/iga/openapi/governance.api/tag/Resource-Owners/)

### Labels API

- **Endpoint:** `/governance/api/v1/labels`
- **Documentation:** [Okta Labels API](https://developer.okta.com/docs/api/iga/openapi/governance.api/tag/Labels/)

## 🎓 Best Practices Summary

1. **Always assign owners** to resources for clear accountability
2. **Use labels consistently** across environments
3. **Automate ownership assignment** during resource creation
4. **Regular audits** of unassigned resources
5. **Leverage labels in reviews** for scoped certifications
6. **Document label taxonomy** for organization-wide consistency
7. **Version control** API configurations alongside Terraform
8. **Test in non-production** before applying to production
9. **Monitor API rate limits** in high-volume environments
10. **Keep Python script updated** with latest API changes

## 🔄 Migration Guide

### Migrating Existing Manual Configurations

If you have existing resource owners or labels configured manually:

#### Step 1: Audit Current State

```bash
# Export current labels
curl -X GET "https://your-org.okta.com/governance/api/v1/labels?limit=200" \
  -H "Authorization: SSWS ${OKTA_API_TOKEN}" \
  -H "Accept: application/json" > current_labels.json

# Export current resource owners for your apps
for app_id in $(terraform state list | grep okta_app); do
  app_id_value=$(terraform state show $app_id | grep "id " | head -1 | awk '{print $3}' | tr -d '"')
  curl -X GET "https://your-org.okta.com/governance/api/v1/resource-owners?filter=parentResourceOrn%20eq%20%22orn:okta:idp:your-org:apps:oauth2:${app_id_value}%22" \
    -H "Authorization: SSWS ${OKTA_API_TOKEN}" >> current_owners.json
done
```

#### Step 2: Create Configuration

```bash
# Convert exported data to config format
python3 scripts/convert_to_config.py \
  --labels current_labels.json \
  --owners current_owners.json \
  --output migration_config.json
```

#### Step 3: Import to Terraform

```hcl
# Reference existing configurations
locals {
  migrated_owners = jsondecode(file("${path.module}/migration_config.json")).resource_owners
  migrated_labels = jsondecode(file("${path.module}/migration_config.json")).labels
}

module "api_management" {
  source = "./modules/api-management"
  
  # Merge migrated with new configs
  app_owner_configs = concat(
    local.migrated_owners,
    local.new_owners
  )
}
```

#### Step 4: Validate No Changes

```bash
# Should show no changes if migration successful
terraform plan

# Verify via Python script
python3 scripts/okta_api_manager.py --action query --config api_config.json
```

## 📖 Advanced Examples

### Example 1: Dynamic Owner Assignment Based on App Name

```hcl
locals {
  # Parse app names to determine owners
  app_owner_mapping = {
    "prod-"  = var.production_team_leads
    "dev-"   = var.development_team_leads
    "test-"  = var.qa_team_leads
  }
  
  # Dynamically assign owners based on app naming convention
  dynamic_app_owners = [
    for app in [okta_app_oauth.apps] : {
      app_name       = app.label
      app_id         = app.id
      app_type       = "oauth2"
      owner_user_ids = lookup(
        local.app_owner_mapping,
        [for prefix, owners in local.app_owner_mapping : 
          prefix if startswith(lower(app.label), prefix)
        ][0],
        var.default_owners
      )
    }
  ]
}
```

### Example 2: Conditional Labeling with Terraform Conditionals

```hcl
locals {
  # Conditionally apply labels based on app properties
  compliance_labels = flatten([
    for app_id, app_config in var.apps : [
      # Always production if in prod environment
      var.environment == "production" ? {
        label_name = "production"
        app_ids    = [app_id]
        app_type   = app_config.type
      } : null,
      
      # PCI if handles payments
      app_config.handles_payments ? {
        label_name = "pci-compliant"
        app_ids    = [app_id]
        app_type   = app_config.type
      } : null,
      
      # High-risk if has admin privileges
      app_config.admin_access ? {
        label_name = "high-risk"
        app_ids    = [app_id]
        app_type   = app_config.type
      } : null,
    ] if app_config != null
  ])
  
  # Filter out null values
  filtered_labels = [for label in local.compliance_labels : label if label != null]
}
```

### Example 3: Multi-Owner Governance Structure

```hcl
locals {
  # Primary and backup owners for business continuity
  critical_app_owners = [
    {
      app_name       = "Production Database"
      app_id         = okta_app_saml.prod_db.id
      app_type       = "saml2"
      owner_user_ids = [
        var.primary_dba_id,
        var.backup_dba_id,
        var.security_lead_id,      # Security oversight
        var.compliance_officer_id  # Compliance oversight
      ]
    }
  ]
  
  # Group-based ownership with delegation
  delegated_ownership = [
    {
      app_name       = "Employee Portal"
      app_id         = okta_app_oauth.employee_portal.id
      app_type       = "oauth2"
      owner_user_ids = []  # Use group instead
    }
  ]
  
  # Actually use group ownership
  group_based_ownership = {
    principal_type = "group"
    principal_ids  = [okta_group.app_owners.id]
    resource_type  = "app"
    resource_ids   = [okta_app_oauth.employee_portal.id]
    app_type       = "oauth2"
  }
}
```

### Example 4: Label Hierarchy and Taxonomy

```hcl
locals {
  # Structured label taxonomy
  label_taxonomy = {
    # Environment labels
    environment = ["production", "staging", "development", "sandbox"]
    
    # Compliance labels
    compliance = ["pci-compliant", "sox-compliant", "hipaa-compliant", "gdpr-compliant"]
    
    # Risk classification
    risk = ["high-risk", "medium-risk", "low-risk"]
    
    # Data classification
    data = ["customer-data", "financial-data", "hr-data", "public-data"]
    
    # Department ownership
    department = ["engineering", "sales", "finance", "hr", "marketing"]
  }
  
  # Flatten for creation
  all_labels = flatten([
    for category, labels in local.label_taxonomy : [
      for label in labels : {
        name        = label
        description = "${title(category)} label: ${label}"
      }
    ]
  ])
  
  # Create smart label assignments
  production_financial_apps = {
    label_names = ["production", "financial-data", "sox-compliant", "high-risk"]
    app_ids     = [okta_app_saml.accounting.id, okta_app_oauth.billing.id]
    app_type    = "oauth2"
  }
}
```

### Example 5: Automated Cleanup of Unassigned Resources

```hcl
# Data source to find resources without owners
data "external" "unassigned_resources" {
  program = ["bash", "-c", <<-EOT
    python3 scripts/find_unassigned.py \
      --org-name ${var.okta_org_name} \
      --api-token ${var.okta_api_token}
  EOT
  ]
}

# Automatically assign default owner to unassigned resources
resource "null_resource" "auto_assign_owners" {
  count = length(jsondecode(data.external.unassigned_resources.result.resource_ids))
  
  provisioner "local-exec" {
    command = <<-EOT
      curl -X PUT "https://${var.okta_org_name}.okta.com/governance/api/v1/resource-owners" \
        -H "Authorization: SSWS ${var.okta_api_token}" \
        -H "Content-Type: application/json" \
        -d '{
          "principalOrns": ["orn:okta:directory:${var.okta_org_name}:users:${var.default_owner_id}"],
          "resourceOrns": ["${jsondecode(data.external.unassigned_resources.result.resource_ids)[count.index]}"]
        }'
    EOT
  }
}
```

## 🧪 Testing Guide

### Unit Testing the Python Script

```python
# test_okta_api_manager.py
import unittest
from unittest.mock import Mock, patch
from okta_api_manager import OktaAPIManager

class TestOktaAPIManager(unittest.TestCase):
    def setUp(self):
        self.manager = OktaAPIManager("test-org", "okta.com", "test-token")
    
    @patch('requests.Session.request')
    def test_assign_resource_owners(self, mock_request):
        mock_response = Mock()
        mock_response.status_code = 200
        mock_response.json.return_value = {"success": True}
        mock_request.return_value = mock_response
        
        result = self.manager.assign_resource_owners(
            ["orn:okta:directory:test-org:users:00u123"],
            ["orn:okta:idp:test-org:apps:oauth2:0oa456"]
        )
        
        self.assertEqual(result["success"], True)
    
    def test_build_user_orn(self):
        orn = self.manager.build_user_orn("00u123")
        self.assertEqual(orn, "orn:okta:directory:test-org:users:00u123")

if __name__ == '__main__':
    unittest.main()
```

### Integration Testing

```bash
#!/bin/bash
# integration_test.sh

set -e

echo "=== Integration Test: API Management ==="

# 1. Create test configuration
cat > test_config.json <<EOF
{
  "okta_org_name": "${OKTA_ORG_NAME}",
  "okta_api_token": "${OKTA_API_TOKEN}",
  "labels": [
    {"name": "test-label", "description": "Test label for integration testing"}
  ],
  "resource_owners": [
    {
      "principal_type": "user",
      "principal_ids": ["${TEST_USER_ID}"],
      "resource_type": "app",
      "resource_ids": ["${TEST_APP_ID}"],
      "app_type": "oauth2"
    }
  ],
  "label_assignments": [
    {
      "label_name": "test-label",
      "resource_type": "app",
      "resource_ids": ["${TEST_APP_ID}"],
      "app_type": "oauth2"
    }
  ]
}
EOF

# 2. Apply configuration
echo "Applying configuration..."
python3 scripts/okta_api_manager.py --action apply --config test_config.json

# 3. Query and verify
echo "Verifying configuration..."
python3 scripts/okta_api_manager.py --action query --config test_config.json

# 4. Cleanup
echo "Cleaning up..."
python3 scripts/okta_api_manager.py --action destroy --config test_config.json

# 5. Verify cleanup
echo "Verifying cleanup..."
python3 scripts/okta_api_manager.py --action query --config test_config.json

echo "✅ Integration test passed!"
```

## 📈 Performance Optimization

### Batch Operations

```python
# Optimize for bulk operations
def batch_assign_owners(manager, assignments, batch_size=10):
    """Assign owners in batches to respect rate limits"""
    for i in range(0, len(assignments), batch_size):
        batch = assignments[i:i + batch_size]
        
        for assignment in batch:
            manager.assign_resource_owners(
                assignment['principal_orns'],
                assignment['resource_orns']
            )
        
        # Small delay between batches
        time.sleep(1)
```

### Parallel Processing

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def parallel_label_assignment(manager, assignments, max_workers=5):
    """Apply labels in parallel (with caution for rate limits)"""
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = []
        
        for assignment in assignments:
            future = executor.submit(
                manager.apply_labels_to_resources,
                assignment['label_name'],
                assignment['resource_orns']
            )
            futures.append(future)
        
        for future in as_completed(futures):
            try:
                result = future.result()
                print(f"✓ Label applied: {result}")
            except Exception as e:
                print(f"✗ Error: {e}")
```

## 🎉 Summary

This API management solution provides:

✅ **Complete OIG Coverage** - Manage all aspects of Okta Identity Governance
✅ **Terraform Integration** - Native workflow with infrastructure as code
✅ **Automation Ready** - CI/CD compatible with error handling
✅ **Idempotent Operations** - Safe to re-run without side effects
✅ **Comprehensive Querying** - Audit and report on current state
✅ **Production Ready** - Rate limiting, retries, and error handling

## 🔗 Additional Resources

- [Okta Governance API Documentation](https://developer.okta.com/docs/api/iga/)
- [Terraform Okta Provider](https://registry.terraform.io/providers/okta/okta/latest/docs)
- [Python Requests Documentation](https://requests.readthedocs.io/)
- [Okta Identity Governance Guide](https://help.okta.com/oie/en-us/content/topics/identity-governance/governance-main.htm)

---

**Need Help?** Open an issue in the repository or consult the Okta Developer Forums.
