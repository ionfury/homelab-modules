terraform {
  required_version = ">= 1.6.6"
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}
