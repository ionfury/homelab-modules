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

variable "unifi_users" {
  description = "List of users to add to the Unifi controller."
  type = map(object({
    mac = string
    ip  = string

    allow_existing         = optional(bool, true)
    blocked                = optional(bool, null)
    local_dns_record       = optional(bool, null)
    network_id             = optional(string, null)
    skip_forget_on_destroy = optional(bool, false)
  }))
}
