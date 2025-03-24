variable "unifi_api_key" {
  description = "The API key to use for the Unifi controller."
  type        = string
}

variable "unifi_address" {
  description = "The address of the Unifi controller."
  type        = string
}

variable "unifi_site" {
  description = "The site to use for the Unifi controller."
  type        = string
  default     = "default"
}

variable "unifi_dns_records" {
  description = "List of DNS records to add to the Unifi controller."
  type = map(object({
    name     = optional(string, null)
    record   = string
    enabled  = optional(bool, true)
    port     = optional(number, null)
    priority = optional(number, null)
    type     = optional(string, "A")
    ttl      = optional(number, 0)
    weight   = optional(number, null)
  }))
}
