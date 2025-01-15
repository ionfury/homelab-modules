terraform {
  required_version = ">= 1.8.8"
  required_providers {
    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "0.41.2"
    }
  }
}
