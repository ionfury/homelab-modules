variable "aws" {
  description = "AWS account information."
  type = object({
    region  = string
    profile = string
  })
}

variable "parameters" {
  description = "A list of parameters to get from AWS SSM."
  type        = list(string)
}
