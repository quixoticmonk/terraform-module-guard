package terraform.module_source

import rego.v1
import data.allowed_sources

deny contains msg if {
    some module_name, module_config in input.module
    source := module_config.source
    not is_allowed_source(source)
    msg := sprintf("Module '%s' uses disallowed source: %s", [module_name, source])
}

is_allowed_source(source) if {
    startswith(source, "git::")
    git_url := trim_prefix(source, "git::")
    clean_url := split(git_url, "?")[0]
    some allowed in allowed_sources.git
    prefix := trim_suffix(allowed, "*")
    startswith(clean_url, prefix)
}

is_allowed_source(source) if {
    not startswith(source, "git::")
    some allowed in allowed_sources.registry
    prefix := trim_suffix(allowed, "*")
    startswith(source, prefix)
}
