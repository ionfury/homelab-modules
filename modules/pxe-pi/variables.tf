variable "aws" {
  description = "AWS account information"
  type = object({
    region  = string
    profile = string
  })
}

variable "raspberry_pi" {
  description = "Name of the raspberry pi to use as the host for pxebootings."
  type        = string
}

variable "raspberry_pis" {
  description = "Map of Raspberry Pis with their service, LAN, and SSH details."
  type = map(object({
    lan = object({
      ip  = string
      mac = string
    })
    ssh = object({
      user_store = string
      pass_store = string
    })
  }))
}
