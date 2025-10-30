package terraform.module_sources

import rego.v1

# Allowed module sources from registry
allowed_registry_sources := [
    "cloudposse/",
    "terraform-aws-modules/",
    "aws-ia/",
]

# Allowed git sources
allowed_git_sources := [
    "github.com/cloudposse/",
    "github.com/terraform-aws-modules/",
    "github.com/aws-ia/",
]

# Check if a source is allowed
is_allowed_source(source) if {
    startswith(source, "git::")
    git_url := trim_prefix(source, "git::")
    clean_url := split(git_url, "?")[0]
    some allowed in allowed_git_sources
    startswith(clean_url, allowed)
}

is_allowed_source(source) if {
    not startswith(source, "git::")
    some allowed in allowed_registry_sources
    startswith(source, allowed)
}

# Deny rule - fails if any module source is not allowed
deny contains msg if {
    some module_name, module_config in input.planned_values.root_module.module_calls
    source := module_config.source
    not is_allowed_source(source)
    msg := sprintf("Module '%s' uses disallowed source: %s", [module_name, source])
}
