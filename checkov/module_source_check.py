import yaml
import os
from checkov.common.models.enums import CheckResult
from checkov.terraform.checks.module.base_module_check import BaseModuleCheck

class ModuleSourceCheck(BaseModuleCheck):
    def __init__(self):
        name = "Ensure module source is from allowed list"
        id = "CKV_TF_MODULE_SOURCE"
        super().__init__(name=name, id=id)
        self.allowed_sources = self._load_allowed_sources()

    def _load_allowed_sources(self):
        config_path = os.path.join(os.path.dirname(__file__), '..', 'allowed-sources.yaml')
        with open(config_path, 'r') as f:
            return yaml.safe_load(f)['allowed_sources']

    def scan_module_conf(self, conf, module_name):
        source = conf.get('source', [None])[0]
        if not source:
            return CheckResult.FAILED
        
        # Check git sources
        if source.startswith('git::'):
            git_url = source.replace('git::', '').split('?')[0]
            for allowed in self.allowed_sources['git']:
                if git_url.startswith(allowed.replace('*', '')):
                    return CheckResult.PASSED
        
        # Check registry sources
        else:
            for allowed in self.allowed_sources['registry']:
                if source.startswith(allowed.replace('*', '')):
                    return CheckResult.PASSED
        
        return CheckResult.FAILED

check = ModuleSourceCheck()
