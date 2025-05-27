terraform {
  required_version = ">= 1.8.8"
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
}
