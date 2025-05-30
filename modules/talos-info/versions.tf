terraform {
  required_version = ">= 1.8.8"
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}
