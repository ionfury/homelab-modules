terraform {
  required_version = ">= 1.8.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "1.0.0"
    }
  }
}
