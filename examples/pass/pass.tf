# These module sources should PASS validation

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}

module "security_group" {
  source = "aws-ia/security-group/aws"
  version = "~> 1.0"
}

module "custom_module" {
  source = "cloudposse/vpc/aws"
  version = "~> 1.0"
}

module "git_module" {
  source = "git::github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.0.0"
}

module "git_custom" {
  source = "git::github.com/cloudposse/terraform-aws-vpc.git//vpc?ref=main"
}
