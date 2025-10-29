# These module sources should FAIL validation - using real modules not in allowed list

module "hashicorp_vault" {
  source  = "hashicorp/vault/aws"
  version = "~> 1.0"
}

module "quixoticmonk_module" {
  source  = "quixoticmonk/glue/aws"
  version = "~> 2.0"
}

module "unauthorized_git" {
  source = "git::github.com/quixoticmonk/terraform-aws-glue.git?ref=main"
}

# This should PASS - allowed source
module "allowed_module" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
