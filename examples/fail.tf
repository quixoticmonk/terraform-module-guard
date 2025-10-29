# These module sources should FAIL validation - using real modules not in allowed list

module "hashicorp_vault" {
  source = "hashicorp/vault/aws"
  version = "~> 1.0"
}

module "quixoticmonk_module" {
  source = "quixoticmonk/vpc/aws"
  version = "~> 2.0"
}

module "unauthorized_git" {
  source = "git::github.com/quixoticmonk/terraform-aws-vpc.git?ref=main"
}

module "gitlab_source" {
  source = "git::gitlab.com/gitlab-org/terraform-aws-gitlab-runner.git?ref=main"
}

module "local_path" {
  source = "./modules/vpc"
}
