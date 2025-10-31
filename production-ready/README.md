# Production-Ready Okta Terraform Configuration

This directory contains cleaned, production-ready Terraform configurations imported from an existing Okta tenant using Terraformer.

## 📁 Directory Structure

```
production-ready/
├── provider.tf              # Terraform and provider configuration
├── variables.tf             # Input variables
├── terraform.tfvars.example # Example variable values
├── README.md               # This file
├── users/                  # User resources (admin-safe)
│   ├── user.tf
│   ├── provider.tf
│   ├── outputs.tf
│   └── terraform.tfstate
├── groups/                 # Group resources
│   ├── group.tf
│   ├── provider.tf
│   ├── outputs.tf
│   └── terraform.tfstate
├── apps/                   # OAuth/OIDC applications
│   ├── app_oauth.tf
│   ├── provider.tf
│   ├── outputs.tf
│   └── terraform.tfstate
├── auth_servers/           # Authorization servers
│   ├── auth_server_default.tf
│   ├── provider.tf
│   ├── outputs.tf
│   └── terraform.tfstate
└── policies/               # MFA and other policies
    ├── policy_mfa_default.tf
    ├── provider.tf
    ├── outputs.tf
    └── terraform.tfstate
```

## 🔒 Safety Features

### Admin User Protection
**IMPORTANT:** Super admin users have been filtered out of the user.tf file to prevent accidental deletion.

- ✅ **Filtered Users:**
  - joe.vanhorn@okta.com (super admin)
  - demo.platform@okta.com (super admin)

- ✅ **Managed Users:**
  - john.doe@example.com (test user)
  - jane.smith@example.com (test user)
  - bob.johnson@example.com (test user)

**Why:** Managing admin users in Terraform could lead to account lockout if `terraform destroy` is run. Admin users should be managed directly in the Okta console.

## 🚀 Quick Start

### 1. Configure Variables

```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
nano terraform.tfvars
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review Plan

```bash
terraform plan
```

**Expected output:** Should show "No changes" since resources were imported from existing state.

### 4. Apply (if needed)

```bash
terraform apply
```

## 📊 Resources Included

| Resource Type | Count | Description |
|--------------|-------|-------------|
| Users | 3 | Test users (admin users excluded) |
| Groups | 4 | Engineering, Sales, Security, All Employees |
| OAuth Apps | 2 | Internal CRM, Project Management |
| Auth Servers | 1 | Default authorization server |
| Policies | 1 | MFA policy |

## ⚠️ Important Notes

### State Files
Each resource type directory contains its own `terraform.tfstate` file. These were generated during the Terraformer import process.

**Options:**
1. **Keep Separate States:** Manage each resource type independently
2. **Merge States:** Combine into single state file (recommended for production)

To merge states:
```bash
# Example: Import users into main state
terraform import okta_user.tfer--user_00urfd91ncmFPEKoH1d7 00urfd91ncmFPEKoH1d7
```

### Resource Names
Resource names use Terraformer's `tfer--` prefix convention. Consider refactoring to meaningful names:

```hcl
# Before
resource "okta_user" "tfer--user_00urfd91ncmFPEKoH1d7" {

# After (refactored)
resource "okta_user" "john_doe" {
```

### Backend Configuration
The `provider.tf` includes commented backend configuration. Uncomment and configure for your state storage:

- S3 (AWS)
- Azure Blob Storage
- Google Cloud Storage
- Terraform Cloud

## 🔄 Workflow Integration

This configuration integrates with the following workflows:

1. **Terraformer Import** - Imports resources from Okta
2. **Admin Protection** - Filters super admin users
3. **Cleanup** - Removes tfer-- prefixes, null values, etc.

## 🛠️ Development

### Adding New Resources

When adding new resources:
1. Follow existing directory structure
2. Run admin protection check for user resources
3. Test with `terraform plan` before applying
4. Update this README with new resources

### Testing Changes

```bash
# Validate syntax
terraform validate

# Check formatting
terraform fmt -check

# Review changes
terraform plan

# Apply changes
terraform apply
```

### Best Practices

1. ✅ **Always run `terraform plan`** before `apply`
2. ✅ **Use version control** for all changes
3. ✅ **Test in non-production** first
4. ✅ **Review state changes** carefully
5. ✅ **Never manage admin users** in Terraform
6. ✅ **Use remote state** for team collaboration
7. ✅ **Enable state locking** to prevent conflicts

## 🔐 Security Considerations

### Secrets Management
Never commit `terraform.tfvars` with real credentials:

```bash
# Add to .gitignore
echo "terraform.tfvars" >> .gitignore
echo "*.tfstate" >> .gitignore
echo "*.tfstate.backup" >> .gitignore
```

### API Token Permissions
Required Okta API scopes:
- `okta.users.manage`
- `okta.groups.manage`
- `okta.apps.manage`
- `okta.governance.accessRequests.manage`
- `okta.governance.accessReviews.manage`
- `okta.governance.catalogs.manage`

### State File Security
State files contain sensitive data. Ensure:
- ✅ State is stored in encrypted backend
- ✅ Access is restricted to authorized users
- ✅ State locking is enabled
- ✅ Backups are encrypted

## 📚 Additional Resources

- [Okta Terraform Provider Docs](https://registry.terraform.io/providers/okta/okta/latest/docs)
- [Terraformer Documentation](https://github.com/GoogleCloudPlatform/terraformer)
- [Project Documentation](../docs/)
- [Admin Protection Workflow](../.github/workflows/admin-protection.yml)

## 🆘 Troubleshooting

### "No changes" on first plan
This is expected! Resources were imported with state, so Terraform sees them as already managed.

### State conflicts
If multiple people are working:
1. Enable state locking (S3 + DynamoDB, etc.)
2. Use `terraform refresh` to sync state
3. Coordinate with team before applying changes

### Admin user errors
If you see admin users in the config:
1. Run admin protection check workflow
2. Use filtered output
3. Never run `terraform destroy` with admin users present

## 📝 Changelog

- **2025-10-31**: Initial production-ready configuration
  - Imported from Terraformer run 18959461202
  - Filtered super admin users
  - Organized by resource type
  - Added provider and variable configs

## 👥 Support

For issues or questions:
- Check project documentation in `docs/`
- Review GitHub Actions workflows
- Consult CLAUDE.md for development guidelines
