terraform {
  required_version = ">= 1.6.6"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
  }
}
