variable "aws" {
  description = "AWS account information."
  type = object({
    region  = string
    profile = string
  })
}

variable "parameters" {
  description = "Parameters to store in AWS SSM."
  type = map(object({
    name        = string
    description = string
    type        = optional(string, "SecureString")
    value       = string
  }))
}
