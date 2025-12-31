terraform {
  required_version = ">= 1.8.8"
  required_providers {
    # Core providers
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "1.0.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.6.0"
    }
    healthchecksio = {
      source  = "kristofferahl/healthchecksio"
      version = "2.0.0"
    }
  }
}
