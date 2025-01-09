variable "localfiles" {
  description = "Local files to create."
  type = map(object({
    filename         = string
    content          = string
    file_permissions = optional(string, "0644")
  }))
}
