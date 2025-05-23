variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "flux_version" {
  description = "Version of Flux to install"
  type        = string
  default     = "v2.4.0"
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

variable "external_secrets_access_key_id" {
  description = "AWS access key ID for external-secrets."
  type        = string
}

variable "external_secrets_access_key_secret" {
  description = "AWS secret access key for external-secrets."
  type        = string
}

variable "cloudflare_account_name" {
  description = "The name of the Cloudflare account"
  type        = string
}

variable "tld" {
  description = "The top-level domain to use for the Cloudflare Tunnel"
  type        = string
}

variable "healthchecksio_replication_allowed_namespaces" {
  description = "Namespaces to allow replication for healthchecks.io.  See: https://github.com/mittwald/kubernetes-replicator?tab=readme-ov-file#pull-based-replication"
  type        = string
  default     = "monitoring"
}

variable "cloudflare_tunnel_secret_annotations" {
  description = "Annotations to add to the secret for the Cloudflare Tunnel. For https://github.com/mittwald/kubernetes-replicator?tab=readme-ov-file#pull-based-replication"
  type        = map(string)
  default = {
    "replicator.v1.mittwald.de/replication-allowed"            = "true"
    "replicator.v1.mittwald.de/replication-allowed-namespaces" = "network"
  }
}

variable "cluster_env_vars" {
  description = "Environment variables to add to the cluster git repository root directory, to be consumed by flux. See: https://fluxcd.io/flux/components/kustomize/kustomizations/#post-build-variable-substitution"
  type        = map(string)
  default     = {}
}
