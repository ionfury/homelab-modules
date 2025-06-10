variable "cluster_endpoint" {
  description = "DNS name to create for the cluster control plane endpoints."
  type        = string
}

variable "machines" {
  description = "A list of machines to create Unifi records for."
  type = map(object({
    type = string
    interfaces = list(object({
      hardwareAddr = string
      addresses = list(object({
        ip   = string
        cidr = optional(string, "24")
      }))
    }))
  }))
}

variable "unifi" {
  description = "The Unifi controller to use."
  type = object({
    address = string
    site    = string
    api_key = string
  })
}
