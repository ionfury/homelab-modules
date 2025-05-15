terraform {
  required_version = ">= 1.8.8"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
}
