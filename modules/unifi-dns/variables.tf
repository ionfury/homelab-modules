variable "unifi_address" {
  description = "The address of the Unifi controller."
  type        = string
}

variable "unifi_site" {
  description = "The site to use for the Unifi controller."
  type        = string
  default     = "default"
}

variable "unifi_username" {
  description = "The username to use for the Unifi controller."
  type        = string
  default     = null
}

variable "unifi_password" {
  description = "The password to use for the Unifi controller."
  type        = string
  default     = null
}

variable "unifi_dns_records" {
  description = "List of DNS records to add to the Unifi controller."
  type = map(object({
    name        = optional(string, null)
    value       = string
    enabled     = optional(bool, true)
    port        = optional(number, 0)
    priority    = optional(number, 0)
    record_type = optional(string, "A")
    ttl         = optional(number, 0)
  }))
  validation {
    condition     = alltrue([for record in var.unifi_dns_records : can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", record.value))])
    error_message = "Each DNS record value must be a valid IP address."
  }
}
