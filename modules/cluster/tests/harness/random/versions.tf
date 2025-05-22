terraform {
  required_version = ">= 1.8.8"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}
