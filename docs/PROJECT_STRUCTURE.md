# GitHub Repository Structure

## 📁 Complete Directory Layout

```
okta-terraform-oig-demo/
├── .github/
│   ├── workflows/
│   │   ├── terraform.yml
│   │   └── terraformer.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   ├── feature_request.md
│   │   └── question.md
│   ├── pull_request_template.md
│   └── CODEOWNERS
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   ├── backend.tf
│   ├── terraform.tfvars.example
│   ├── api-managed-resources.tf
│   ├── integrated-api-management.tf
│   ├── advanced-oig-examples.tf
│   └── modules/
│       └── api-management/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│
├── scripts/
│   ├── okta_api_manager.py
│   ├── import_okta_resources.sh
│   ├── cleanup_terraform.py
│   ├── build_test_org.sh
│   ├── cleanup_test_org.sh
│   └── test_complete_workflow.sh
│
├── config/
│   ├── api_config.json.example
│   └── label_taxonomy.json
│
├── docs/
│   ├── README.md
│   ├── API_MANAGEMENT.md
│   ├── TERRAFORMER.md
│   ├── TERRAFORMER_OIG_FAQ.md
│   ├── OIG_MANUAL_IMPORT.md
│   ├── TESTING.md
│   ├── PROJECT_STRUCTURE.md
│   ├── COMPLETE_SOLUTION.md
│   ├── CONTRIBUTING.md
│   ├── TROUBLESHOOTING.md
│   └── images/
│       └── architecture-diagram.png
│
├── tests/
│   ├── test_okta_api_manager.py
│   ├── integration_test.sh
│   ├── e2e_test.sh
│   └── fixtures/
│       └── test_config.json
│
├── examples/
│   ├── basic/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── README.md
│   ├── advanced/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── README.md
│   └── state-files/
│       ├── example_users.tfstate
│       ├── example_groups.tfstate
│       └── example_apps.tfstate
│
├── .gitignore
├── .gitattributes
├── .editorconfig
├── .pre-commit-config.yaml
├── requirements.txt
├── setup.sh
├── Makefile
├── README.md
├── LICENSE
├── CHANGELOG.md
├── SECURITY.md
└── CODE_OF_CONDUCT.md
```

## 📝 File Descriptions

### Root Directory
- **README.md** - Main project documentation
- **LICENSE** - MIT license
- **CHANGELOG.md** - Version history
- **SECURITY.md** - Security policy
- **CODE_OF_CONDUCT.md** - Community guidelines
- **.gitignore** - Files to exclude from git
- **.gitattributes** - Git attributes for line endings
- **.editorconfig** - Editor configuration
- **requirements.txt** - Python dependencies
- **setup.sh** - Initial setup script
- **Makefile** - Common commands

### .github/
GitHub-specific files for automation and templates

### terraform/
All Terraform configurations and modules

### scripts/
Python and Bash scripts for automation

### config/
Configuration file examples

### docs/
All documentation and guides

### tests/
Test files and fixtures

### examples/
Example configurations and state files

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
