# These module sources should FAIL validation

# Registry modules (NOT in allowed sources)
module "quixoticmonk_glue_1" {
  source = "quixoticmonk/glue/aws"
  version = "~> 0.0.3"
}

module "quixoticmonk_glue_2" {
  source = "quixoticmonk/glue/aws"
  version = "~> 0.0.3"
}

module "docker_secret" {
  source  = "bendrucker/docker-secret/kubernetes"
  version = "1.0.0"
  
  name      = "my-docker-secret"
  namespace = "default"
  registries = {
    "docker.io" = {
      username = "user"
      password = "pass"
      email    = "user@example.com"
    }
  }
}

# Git sources (NOT in allowed sources)
module "git_quixoticmonk_s3" {
  source = "git::ssh://git@github.com/quixoticmonk/terraform-aws-s3.git?ref=main"
}

# This should PASS - allowed source
module "allowed_module" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"
}
