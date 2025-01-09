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

variable "unifi_users" {
  description = "List of users to add to the Unifi controller."
  type = map(object({
    ip  = string
    mac = string
  }))
}
