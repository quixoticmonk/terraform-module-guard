# Module Origin Validator

Policies to validate Terraform module sources across multiple policy engines.

## Configuration

Edit `allowed-sources.yaml` to customize allowed module sources:

```yaml
allowed_sources:
  registry:
    - "quixoticmonk/*"
    - "terraform-aws-modules/*" 
    - "aws-ia/*"
  git:
    - "github.com/quixoticmonk/*"
    - "github.com/terraform-aws-modules/*"
    - "github.com/aws-ia/*"
```

## Usage

### Checkov
```bash
checkov -f main.tf --external-checks-dir checkov/
```

### OPA
```bash
opa eval -d allowed-sources.yaml -d opa/module_source.rego "data.terraform.module_source.deny" --input terraform.json
```

### Sentinel
```bash
sentinel apply sentinel/module-source-policy.sentinel
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

- `examples/pass.tf` - Module sources that should pass validation
- `examples/fail.tf` - Module sources that should fail validation
