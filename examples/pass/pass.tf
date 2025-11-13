# These module sources should PASS validation

# Registry modules (allowed sources)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}

module "label" {
  source  = "aws-ia/label/aws" 
  version = "~> 0.0.5"
}

module "cloudposse_module" {
  source  = "cloudposse/label/null"
  version = "~> 0.25.0"
}

# Git sources (allowed) - using SSH
module "git_terraform_aws" {
  source = "git::ssh://git@github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v4.0.0"
}

module "git_cloudposse" {
  source = "git::ssh://git@github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
}
