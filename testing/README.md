# Testing Documentation

This directory contains testing and validation documentation for the Okta Terraform Complete Demo project.

---

## 📋 Available Test Plans

### [MANUAL_VALIDATION_PLAN.md](./MANUAL_VALIDATION_PLAN.md)
Comprehensive manual validation plan covering all aspects of the Okta Terraform setup.

**Includes:**
- Pre-validation checklist (tools, access, secrets)
- Environment validation
- Import workflow testing
- Resource management (CRUD operations)
- OIG governance validation
- State management verification
- Documentation accuracy checks
- Security validation
- Cleanup procedures
- Sign-off template

**Estimated Time:** 2-3 hours for complete validation
**Required Access:** Okta Admin Console, GitHub Actions, Local Terminal

---

## 🎯 When to Use

### Manual Validation Plan

Use the manual validation plan when:
- Setting up the repository for the first time
- After major changes to workflows or scripts
- Before deploying to production
- Troubleshooting issues
- Training new team members
- Periodic quality assurance (quarterly/biannually)

---

## 🔄 Test Execution Tracking

Create a copy of the validation plan for each test run:

```bash
# Create dated copy for test run
cp MANUAL_VALIDATION_PLAN.md validation_run_$(date +%Y%m%d).md

# Fill out checklist items as you test
# Keep completed validation runs for audit trail
```

---

## 📊 Test Results Archive

Store completed validation runs in a subdirectory:

```
testing/
├── README.md
├── MANUAL_VALIDATION_PLAN.md (template)
└── results/
    ├── validation_run_20251107.md
    ├── validation_run_20251201.md
    └── ...
```

---

## 🤝 Contributing Test Plans

To add new test plans:

1. Create a new markdown file in this directory
2. Follow the format of existing plans
3. Include clear objectives and pass/fail criteria
4. Add to this README
5. Submit PR for review

---

## 📚 Related Documentation

- [Main README](../README.md) - Project overview
- [Environment README](../environments/README.md) - Environment structure
- [Resource Documentation](../docs/TERRAFORM_RESOURCES.md) - Complete resource guide
- [Workflow Documentation](../docs/PROJECT_STRUCTURE.md) - Repository structure

---

## ⚠️ Important Notes

- **Never commit sensitive data** to validation run files
- Redact API tokens, passwords, and user IDs from test results
- Use placeholders for sensitive information
- Store completed validation runs securely (not in public repo if contains sensitive data)

---

Last updated: 2025-11-07
