# Module Source Policy

## Description

This policy validates that Terraform modules are sourced from approved registries and Git repositories to ensure security and compliance.

## Policy Details

| Policy Name | Enforcement Level | Description |
|-------------|-------------------|-------------|
| module-source-policy | hard-mandatory | Validates module sources against allowed registry and Git patterns |

## Configuration

The policy validates module sources against patterns defined in `allowed-sources.yaml`:

- **Registry sources**: Terraform Registry modules (e.g., `cloudposse/*`, `terraform-aws-modules/*`)
- **Git sources**: Git repository modules (e.g., `github.com/cloudposse/*`)

## Allowed Sources

### Registry
- `cloudposse/*`
- `terraform-aws-modules/*`
- `aws-ia/*`

### Git
- `github.com/cloudposse/*`
- `github.com/terraform-aws-modules/*`
- `github.com/aws-ia/*`

## Examples

### Passing Examples
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
}

module "security_group" {
  source = "git::https://github.com/cloudposse/terraform-aws-security-group.git?ref=0.4.3"
}
```

### Failing Examples
```hcl
module "untrusted" {
  source = "untrusted-publisher/module/aws"
}

module "random_git" {
  source = "git::https://github.com/random-user/terraform-module.git"
}
```
