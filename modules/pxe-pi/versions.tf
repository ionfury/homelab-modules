terraform {
  required_version = ">= 1.8.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
    ansible = {
      version = "1.3.0"
      source  = "ansible/ansible"
    }
  }
}
