variable "cluster_name" {
  description = "Logical name of the cluster."
  type        = string
}

variable "cluster_tld" {
  description = "Cluster DNS suffix (e.g. internal.dev.example.com)."
  type        = string
}

variable "cluster_endpoint" {
  description = "DNS endpoint for the Kubernetes control plane."
  type        = string
}

variable "dns_records" {
  type = map(object({
    name   = string
    record = string
  }))
}

variable "dhcp_reservations" {
  type = map(object({
    mac = string
    ip  = string
  }))
}

variable "machines" {
  description = "Fully-adapted machine definitions ready for execution."
  type = map(object({
    talos_config      = string
    selector          = string
    extensions        = list(string)
    extra_kernel_args = list(string)
    secureboot        = bool
    architecture      = string
    platform          = string
    sbc               = string
  }))
}

variable "talos_cluster_config" {
  description = "Rendered Talos cluster configuration YAML."
  type        = string
}

variable "bootstrap_charts" {
  description = "Helm charts to bootstrap during Talos cluster creation."
  type = list(object({
    repository = string
    chart      = string
    name       = string
    version    = string
    namespace  = string
    values     = string
  }))
  default = []
}

variable "cluster_env_vars" {
  description = "Environment variables passed into cluster bootstrap."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "versions" {
  description = "Component versions used by the runtime."
  type = object({
    kubernetes = string
    talos      = string
    flux       = string
  })
}

variable "nameservers" {
  description = "Nameservers configured on cluster nodes."
  type        = list(string)
}

variable "timeservers" {
  description = "Timeservers configured on cluster nodes."
  type        = list(string)
}

variable "talos_config_path" {
  description = "Filesystem path where Talos config is written."
  type        = string
}

variable "kubernetes_config_path" {
  description = "Filesystem path where kubeconfig is written."
  type        = string
}

variable "on_destroy" {
  description = "Cluster teardown behavior."
  type = object({
    graceful = bool
    reboot   = bool
    reset    = bool
  })
}

variable "ssm_output_path" {
  description = "AWS SSM path used to persist cluster artifacts."
  type        = string
}

variable "unifi" {
  description = "Unifi controller configuration."
  type = object({
    address       = string
    site          = string
    api_key_store = string
  })
}

variable "github" {
  description = "GitHub repository configuration."
  type = object({
    org             = string
    repository      = string
    repository_path = string
    token_store     = string
  })
}

variable "cloudflare" {
  description = "Cloudflare account configuration."
  type = object({
    account         = string
    email           = string
    api_token_store = string
    zone_id         = string
  })
}

variable "external_secrets" {
  description = "External Secrets credentials."
  type = object({
    id_store     = string
    secret_store = string
  })
}

variable "healthchecksio" {
  description = "Healthchecks.io API credentials."
  type = object({
    api_key_store = string
  })
}
