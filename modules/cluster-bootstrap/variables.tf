variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "flux_version" {
  description = "Version of Flux to install"
  type        = string
  default     = "v2.4.0"
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

variable "kubeconfig" {
  description = "Credentials to access kubernetes cluster"
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
}

variable "aws" {
  description = "The AWS account to use."
  type = object({
    region = string
  })
}

variable "github" {
  description = "The GitHub repository to use."
  type = object({
    org             = string
    repository      = string
    repository_path = string
    token_store     = string
  })
}

variable "cloudflare" {
  description = "The Cloudflare account to use."
  type = object({
    account         = string
    email           = string
    api_token_store = string
    zone_id         = optional(string, "799905ff93d585a9a0633949275cbf98")
  })
}

variable "external_secrets" {
  description = "The external secret store."
  type = object({
    id_store     = string
    secret_store = string
  })
}

variable "healthchecksio" {
  description = "The healthchecks.io account to use."
  type = object({
    api_key_store = string
  })
}
