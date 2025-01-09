variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "flux_version" {
  description = "Version of Flux to install"
  type        = string
  default     = "v2.4.0"
}

variable "kubernetes_config_file_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "github" {
  description = "Github account information."
  type = object({
    org         = string
    repository  = string
    token_store = string
  })
}

variable "aws" {
  description = "AWS account information."
  type = object({
    region  = string
    profile = string
  })
}
/*
variable "external_secrets_access_key_id" {
  description = "AWS access key ID for external-secrets."
  type        = string
}

variable "external_secrets_access_key_secret" {
  description = "AWS secret access key for external-secrets."
  type        = string
}
*/
