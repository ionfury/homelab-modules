resource "random_pet" "this" {
  length = var.length
}

output "resource_name" {
  value = random_pet.this.id
}

variable "length" {
  type    = number
  default = 2
}

terraform {
  required_version = ">= 1.8.8"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "1.0.0"
    }
  }
}
