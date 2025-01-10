terraform {
  required_version = ">= 1.6.6"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

variable "length" {
  type    = number
  default = 2
}

resource "random_pet" "this" {
  length = var.length
}

output "resource_name" {
  value = random_pet.this.id
}
