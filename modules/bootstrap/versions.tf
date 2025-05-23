terraform {
  required_version = ">= 1.8.8"
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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.35.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "2.3.0"
    }
  }
}
