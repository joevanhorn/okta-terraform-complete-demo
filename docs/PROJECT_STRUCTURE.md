# GitHub Repository Structure

## 📁 Complete Directory Layout

```
okta-terraform-complete-demo/
├── .github/
│   ├── workflows/
│   │   ├── admin-protection.yml
│   │   ├── cleanup-imports.yml
│   │   ├── lowerdecklabs-import.yml
│   │   ├── lowerdecklabs-export-oig.yml
│   │   ├── terraformer.yml
│   │   ├── terraform.yml
│   │   ├── claude.yml
│   │   └── claude-code-review.yml
│   └── ISSUE_TEMPLATE/
│       ├── bug_report.md
│       ├── feature_request.md
│       └── question.md
│
├── production-ready/
│   ├── apps/                     # Imported OAuth/SAML apps
│   ├── auth_servers/             # Imported authorization servers
│   ├── groups/                   # Imported groups
│   ├── policies/                 # Imported policies
│   ├── users/                    # Imported users
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── README.md
│   ├── FORKING_GUIDE.md
│   ├── LESSONS_LEARNED.md
│   └── RESOURCE_REFERENCE.md
│
├── oig-exports/
│   ├── lowerdecklabs/           # LowerDeckLabs OIG exports
│   │   ├── latest.json          # Most recent export
│   │   └── YYYY-MM-DD.json      # Historical exports
│   └── README.md                # OIG exports documentation
│
├── scripts/
│   ├── okta_api_manager.py        # Modular OIG export with graceful error handling
│   └── protect_admin_users.py     # Filter admin users from imports
│
├── docs/
│   ├── API_MANAGEMENT.md
│   ├── COMPLETE_SOLUTION.md
│   ├── CONTRIBUTING.md
│   ├── LOWERDECKLABS_SETUP.md    # LowerDeckLabs environment setup guide
│   ├── OIG_MANUAL_IMPORT.md
│   ├── PROJECT_STRUCTURE.md
│   ├── TERRAFORMER.md
│   ├── TERRAFORMER_OIG_FAQ.md
│   └── TESTING.md
│
├── .gitignore
├── .gitattributes
├── CHANGELOG.md
├── CLAUDE.md                     # Claude Code integration guide
├── CODE_OF_CONDUCT.md
├── DIRECTORY_GUIDE.md            # Guide to choosing production-ready/ vs terraform/
├── LICENSE
├── OIG_PREREQUISITES.md          # Prerequisites for OIG features
├── README.md
└── SECURITY.md
```

## 📝 File Descriptions

### Root Directory
- **README.md** - Main project documentation
- **DIRECTORY_GUIDE.md** - Guide to choosing between production-ready/ and terraform/ directories
- **OIG_PREREQUISITES.md** - Prerequisites for using OIG features
- **LICENSE** - MIT license
- **CHANGELOG.md** - Version history
- **SECURITY.md** - Security policy
- **CODE_OF_CONDUCT.md** - Community guidelines
- **CLAUDE.md** - Claude Code integration guide
- **.gitignore** - Files to exclude from git
- **.gitattributes** - Git attributes for line endings

### .github/workflows/
GitHub Actions workflows for automation:
- **lowerdecklabs-import.yml** - Import standard Okta resources for LowerDeckLabs environment
- **lowerdecklabs-export-oig.yml** - Export OIG resources with modular approach
- **admin-protection.yml** - Protect admin users from modifications
- **cleanup-imports.yml** - Clean up and organize imported resources
- **terraformer.yml** - Terraformer import workflow
- **claude.yml** - Claude Code integration
- **claude-code-review.yml** - Automated code reviews

### production-ready/
Production-validated Terraform configurations for basic Okta resources (importable via Terraformer):
- Organized by resource type (apps/, groups/, users/, etc.)
- Includes comprehensive documentation
- Validated workflow for importing existing infrastructure

### oig-exports/
OIG resource exports committed to the repository:
- **lowerdecklabs/** - Exports from LowerDeckLabs tenant
  - `latest.json` - Most recent export
  - `YYYY-MM-DD.json` - Historical exports by date
- Version controlled for drift detection
- Automatically updated by GitHub Actions workflow

### scripts/
Automation scripts:
- **okta_api_manager.py** - Modular OIG export/import with graceful error handling
- **protect_admin_users.py** - Filter admin users from imports

### docs/
Comprehensive documentation:
- **LOWERDECKLABS_SETUP.md** - Setup guide for LowerDeckLabs environment
- **API_MANAGEMENT.md** - API-based resource management guide
- **TERRAFORMER.md** - Terraformer usage guide
- **TERRAFORMER_OIG_FAQ.md** - FAQ for OIG resources and Terraformer
- **COMPLETE_SOLUTION.md** - Complete solution overview
- **TESTING.md** - Testing guide

## 🔑 Key Files for GitHub

### Branch Protection
- `main` - Protected, requires PR approval
- `develop` - Integration branch
- `feature/*` - Feature branches

### Required Files
- ✅ README.md with badges
- ✅ LICENSE file
- ✅ Contributing guidelines
- ✅ Security policy
- ✅ Issue templates
- ✅ PR template
- ✅ GitHub Actions workflows

### Recommended Files
- ✅ CHANGELOG.md
- ✅ CODE_OF_CONDUCT.md
- ✅ CODEOWNERS
- ✅ SECURITY.md
