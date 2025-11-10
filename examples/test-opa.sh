#!/bin/bash
set -e

echo "Testing OPA policy..."

# Test pass case
echo "Testing pass case..."
PASS_RESULT=$(opa eval -d ../opa/module_source_policy.rego -i pass/opa/input.json "data.terraform.module_sources.deny" --format raw)
if [ "$PASS_RESULT" = "[]" ]; then
    echo "✅ Pass test: PASSED"
else
    echo "❌ Pass test: FAILED - Expected empty array, got: $PASS_RESULT"
    exit 1
fi

# Test fail case
echo "Testing fail case..."
FAIL_RESULT=$(opa eval -d ../opa/module_source_policy.rego -i fail/opa/input.json "data.terraform.module_sources.deny" --format raw)
if [ "$FAIL_RESULT" != "[]" ]; then
    echo "✅ Fail test: PASSED - Found violations as expected"
    echo "   Violations: $FAIL_RESULT"
else
    echo "❌ Fail test: FAILED - Expected violations, got empty array"
    exit 1
fi

echo "All OPA tests passed!"
