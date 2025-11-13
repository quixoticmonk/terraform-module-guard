# Module Origin Validator [work in progress]

Policies to validate Terraform module sources across multiple policy engines.

## Configuration

Edit `allowed-sources.yaml` to customize allowed module sources. Sentinel policy has the source list inline.

```yaml
allowed_sources:
  registry:
    - "cloudposse/*"
    - "terraform-aws-modules/*" 
    - "aws-ia/*"
  git:
    - "github.com/cloudposse/*"
    - "github.com/terraform-aws-modules/*"
    - "github.com/aws-ia/*"
```

## Usage

### Sentinel (HCP Terraform)
The Sentinel policy validates module sources in HCP Terraform runs:

![Sentinel Policy Run](static/images/sentinel_run.png)

```hcl
# sentinel.hcl
policy "module-source-policy" {
    source = "./module-source-policy.sentinel"
    enforcement_level = "hard-mandatory"
}
```

### Checkov
```bash
# Run specific check
checkov -f main.tf --external-checks-dir checkov/ --check CKV_TF_MODULE_SOURCE

# Run all checks (includes custom check)
checkov -f main.tf --external-checks-dir checkov/
```

### OPA (Open Policy Agent)
```bash
# Test policy with example inputs
cd examples && ./test-opa.sh

# Run policy against Terraform plan JSON
opa exec --decision terraform/module_sources/deny --bundle opa/ --fail-non-empty plan.json
```

### Pre-commit
Add to `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: validate-module-sources
        name: Validate module sources
        entry: ./pre-commit/validate-module-sources.sh
        language: script
        files: \.tf$
```

## Examples

- `examples/pass/pass.tf` - Module sources that should pass validation (5 modules)
- `examples/fail/fail.tf` - Module sources that should fail validation (4 unauthorized + 1 allowed)
- `examples/pass/opa/input.json` - Complete Terraform plan JSON for passing cases
- `examples/fail/opa/input.json` - Complete Terraform plan JSON for failing cases
- `examples/pass/plan.json` - Source Terraform plan file
- `examples/fail/plan.json` - Source Terraform plan file
