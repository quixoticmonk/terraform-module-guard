import yaml
import os
from typing import Any
from checkov.common.models.enums import CheckResult, CheckCategories
from checkov.terraform.checks.module.base_module_check import BaseModuleCheck

class ModuleSourceAllowlist(BaseModuleCheck):
    def __init__(self) -> None:
        name = "Ensure module source is from allowed list"
        id = "CKV_TF_MODULE_SOURCE"
        categories = [CheckCategories.SUPPLY_CHAIN]
        super().__init__(name=name, id=id, categories=categories)

    def _load_allowed_sources(self):
        config_path = os.path.join(os.path.dirname(__file__), '..', 'allowed-sources.yaml')
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)['allowed_sources']

    def scan_module_conf(self, conf: dict[str, list[Any]]) -> CheckResult:
        allowed_sources = self._load_allowed_sources()
        source = conf.get('source')
        if not source or not isinstance(source, list):
            return CheckResult.FAILED
        
        source_url = source[0]
        
        # Check git sources
        if source_url.startswith('git::'):
            git_url = source_url.replace('git::', '').split('?')[0]
            for allowed in allowed_sources['git']:
                if git_url.startswith(allowed.replace('*', '')):
                    return CheckResult.PASSED
        
        # Check registry sources
        else:
            for allowed in allowed_sources['registry']:
                if source_url.startswith(allowed.replace('*', '')):
                    return CheckResult.PASSED
        
        return CheckResult.FAILED

check = ModuleSourceAllowlist()
