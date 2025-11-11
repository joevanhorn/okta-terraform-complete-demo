#!/bin/bash
export TF_VAR_okta_org_name="${OKTA_ORG_NAME:-demo-lowerdecklabs}"
export TF_VAR_okta_base_url="${OKTA_BASE_URL:-oktapreview.com}"
export TF_VAR_okta_api_token="${OKTA_API_TOKEN}"

echo "=== Testing terraform plan with -refresh=false ==="
terraform plan -refresh=false -detailed-exitcode 2>&1 | tee plan_no_refresh.log

exitcode=${PIPESTATUS[0]}
echo ""
echo "Exit code: $exitcode"
echo "0 = no changes, 1 = error, 2 = changes present"

# Check for campaign errors
if grep -q "Error reading campaign" plan_no_refresh.log; then
    echo "❌ FAILED: Still getting campaign errors even with -refresh=false"
    exit 1
else
    echo "✅ SUCCESS: No campaign errors with -refresh=false"
fi

exit $exitcode
