# Archived Workflows

This directory contains workflows that are no longer actively used but are preserved for historical reference.

## Testing and Investigation Workflows

These workflows were created during development and testing phases:

- **lowerdecklabs-investigate-labels-api.yml** - Investigation of Labels API 405 errors
- **lowerdecklabs-test-label-endpoints.yml** - Testing of label application endpoints
- **lowerdecklabs-validate-labels.yml** - Old label validation (superseded by validate-label-mappings.yml)
- **test-export-oig.yml** - Export functionality testing
- **validate-pr.yml** - Old PR validation workflow

## Legacy Import Workflows

These workflows have been superseded by **import-all-resources.yml** which provides more comprehensive functionality:

- **lowerdecklabs-import.yml** - Basic read-only import with scheduled drift detection
- **lowerdecklabs-import-oig.yml** - OIG-specific resource import
- **lowerdecklabs-import-complete.yml** - Complete environment import with commit option

**Why superseded?** The newer `import-all-resources.yml` workflow:
- Supports all environments (not just lowerdecklabs)
- Includes comprehensive resource coverage
- Has better error handling and reporting
- Provides tenant environment detection

## Why Archived?

These workflows served their purpose during initial development but are no longer needed:
- Investigation complete (labels API issues resolved)
- Features validated and working
- Replaced by newer, more robust workflows
- Superseded by environment-agnostic versions

## If You Need Them

These workflows are preserved in case:
- You need to reference the investigation approach
- Similar issues arise and you want to see the debugging steps
- You're curious about the development history
- You want to restore specific functionality

Feel free to restore any workflow if needed by moving it back to the parent directory.
