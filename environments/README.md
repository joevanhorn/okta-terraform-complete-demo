# Environment Isolation Guide

## Overview

Each directory under `environments/` represents a **separate Okta organization** with its own complete set of terraform-managed resources. This ensures complete isolation between different Okta tenants.

## Environment Structure

```
environments/
├── lowerdecklabs/          # LowerDeckLabs.oktapreview.com
│   ├── terraform/
│   │   ├── oig_entitlements.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   └── oig-config/
│       └── resource-owners.yml
│
├── production/             # Production Okta org (future)
│   └── terraform/
│       └── ...
│
└── testorg/                # Test/development org (future)
    └── terraform/
        └── ...
```

## Critical Rules for Environment Isolation

### 1. One Directory = One Okta Org

Each environment directory manages resources for **exactly one** Okta organization:
- `lowerdecklabs/` → lowerdecklabs.oktapreview.com
- `production/` → production org
- `testorg/` → test/dev org (using repository secrets)

**❌ NEVER** mix resources from different Okta orgs in the same directory.

### 2. Environment-Specific Secrets

Each environment MUST use GitHub Environment secrets, NOT repository secrets.

#### Configuring GitHub Environments

Go to: **Settings > Environments**

**LowerDeckLabs Environment:**
- Name: `lowerdecklabs`
- Secrets:
  - `OKTA_API_TOKEN` = lowerdecklabs API token
  - `OKTA_BASE_URL` = `oktapreview.com`
  - `OKTA_ORG_NAME` = `lowerdecklabs`

**Repository-level secrets (for test org):**
- `OKTA_API_TOKEN` = test org token
- `OKTA_BASE_URL` = `okta.com`
- `OKTA_ORG_NAME` = `dev-xxxxx`

### 3. Workflow Environment Specification

All terraform workflows MUST specify the environment to ensure correct secrets:

```yaml
jobs:
  terraform-plan:
    environment:
      name: ${{ inputs.environment }}
```

This guarantees:
- ✅ Correct Okta API credentials
- ✅ Resources created in correct org
- ✅ No cross-environment pollution

## Related Documentation

- [GitOps Workflow Guide](../docs/GITOPS_WORKFLOW.md)
