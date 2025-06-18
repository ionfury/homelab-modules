variable "cluster_name" {
  description = "A name to provide for the cluster."
  type        = string
}

variable "cluster_tld" {
  description = "A tld for the cluster. Format: asdf.com"
  type        = string
}

variable "cluster_vip" {
  description = "The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. Format: 10.10.10.10"
  type        = string
}

variable "cluster_node_subnet" {
  description = "The subnet to use for the Talos cluster nodes. Format: 10.10.10.10/16"
  type        = string
}

variable "cluster_pod_subnet" {
  description = "The pod subnet to use for pods on the Talos cluster. Format: 10.10.10.10/16"
  type        = string
}

variable "cluster_service_subnet" {
  description = "The pod subnet to use for services on the Talos cluster. Format: 10.10.10.10/16"
  type        = string
}
variable "cluster_env_vars" {
  description = "List of key value pairs to pass to cluster via the generated-cluster-vars.env."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_etcd_extraArgs" {
  description = "List of key value pairs to pass to the etcd service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_controllerManager_extraArgs" {
  description = "List of key value pairs to pass to the controller manager service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_scheduler_extraArgs" {
  description = "List of key value pairs to pass to the scheduler service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_on_destroy" {
  description = "How to preform node destruction"
  type = object({
    graceful = string
    reboot   = string
    reset    = string
  })
  default = {
    graceful = false
    reboot   = true
    reset    = true
  }
}

variable "cilium_helm_values" {
  description = "The Helm values to use for Cilium."
  type        = string
}

variable "cilium_version" {
  description = "The version of Cilium to use."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use."
  type        = string
}

variable "talos_version" {
  description = "The version of Talos to use."
  type        = string
}

variable "prometheus_version" {
  description = "The version of Prometheus to use."
  type        = string
}

variable "flux_version" {
  description = "The version of Flux to use."
  type        = string
}

variable "nameservers" {
  description = "The nameservers to use for the cluster."
  type        = list(string)
}

variable "timeservers" {
  description = "The timeservers to use for the cluster."
  type        = list(string)
}

variable "talos_config_path" {
  description = "The path to output the Talos configuration file."
  type        = string
}

variable "kubernetes_config_path" {
  description = "The path to output the Kubernetes configuration file."
  type        = string
}

variable "ssm_output_path" {
  description = "The aws ssm parameter path to store config in."
  type        = string
  default     = "/homelab/infrastructure/clusters"
}

variable "machines" {
  description = "A list of machines to create the talos cluster from."
  type = map(object({
    type = string
    install = object({
      disk              = string
      extensions        = optional(list(string), [])
      extra_kernel_args = optional(list(string), [])
      secureboot        = optional(bool, false)
      architecture      = optional(string, "amd64")
      platform          = optional(string, "metal")
      sbc               = optional(string, "")
      wipe              = optional(bool, true)
    })
    labels = optional(list(object({
      key   = string
      value = string
    })), [])
    annotations = optional(list(object({
      key   = string
      value = string
    })), [])
    files = optional(list(object({
      path        = string
      op          = string
      permissions = string
      content     = string
    })), [])
    interfaces = list(object({
      addresses = list(object({
        ip   = string
        cidr = optional(string, "24")
      }))
      hardwareAddr     = string
      dhcp_routeMetric = optional(number, 100)
      vlans = optional(list(object({
        vlanId = number
        addresses = list(object({
          ip   = string
          cidr = optional(string, "24")
        }))
        dhcp_routeMetric = optional(number, 100)
      })), [])
    }))
  }))
}

variable "unifi" {
  description = "The Unifi controller to use."
  type = object({
    address       = string
    site          = string
    api_key_store = string
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
