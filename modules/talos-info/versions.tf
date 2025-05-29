terraform {
  required_version = ">= 1.8.8"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}
