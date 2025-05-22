terraform {
  required_version = ">= 1.8.8"
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.8.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
}
