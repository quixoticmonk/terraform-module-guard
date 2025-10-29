# These module sources should FAIL validation

module "unauthorized_registry" {
  source = "hashicorp/vault/aws"
  version = "~> 1.0"
}

module "random_user" {
  source = "someuser/module/aws"
  version = "~> 1.0"
}

module "unauthorized_git" {
  source = "git::github.com/hashicorp/terraform-aws-vault.git?ref=v1.0.0"
}

module "gitlab_source" {
  source = "git::gitlab.com/company/terraform-modules.git//vpc"
}

module "local_path" {
  source = "./modules/vpc"
}
