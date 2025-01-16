variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "flux_version" {
  description = "Version of Flux to install"
  type        = string
  default     = "v2.4.0"
}

variable "kubernetes_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "github_org" {
  description = "Github organization"
  type        = string
}

variable "github_repository" {
  description = "Github repository"
  type        = string
}

variable "github_repository_path" {
  description = "Path in the Github repository to the cluster configuration"
  type        = string
  default     = "clusters"
}

variable "github_token" {
  description = "Github token"
  type        = string
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
