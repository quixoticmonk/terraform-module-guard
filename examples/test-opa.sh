#!/bin/bash
set -e

echo "Testing OPA policy..."

# Test pass case
echo "Testing pass case..."
if opa exec --decision terraform/module_sources/deny --bundle ../opa/ --fail-non-empty pass/opa/input.json > /dev/null 2>&1; then
    echo "✅ Pass test: PASSED"
else
    echo "❌ Pass test: FAILED - Expected no violations"
    exit 1
fi

# Test fail case
echo "Testing fail case..."
if opa exec --decision terraform/module_sources/deny --bundle ../opa/ --fail-non-empty fail/opa/input.json > /dev/null 2>&1; then
    echo "❌ Fail test: FAILED - Expected violations but got none"
    exit 1
else
    echo "✅ Fail test: PASSED - Found violations as expected"
fi

echo "All OPA tests passed!"
