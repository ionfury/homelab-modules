provider "aws" {}

data "aws_ssm_parameter" "this" {
  for_each = toset(var.parameters)
  name     = each.value
}

output "values" {
  sensitive = true
  value = {
    for param_key, param in data.aws_ssm_parameter.this :
    param_key => param.value
  }
}

variable "parameters" {
  description = "A list of parameters to get from AWS SSM."
  type        = list(string)
}

terraform {
  required_version = ">= 1.8.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}
