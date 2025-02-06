variable "cluster_name" {
  description = "A name to provide for the cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the cluster."
  type        = string
}

variable "cluster_vip" {
  description = "The VIP to use for the Talos cluster. Applied to the first interface of control plane machines."
  type        = string
}

variable "cluster_node_subnet" {
  description = "The subnet to use for the Talos cluster nodes."
  type        = string
}

variable "cluster_pod_subnet" {
  description = "The pod subnet to use for pods on the Talos cluster."
  type        = string
}

variable "cluster_service_subnet" {
  description = "The pod subnet to use for services on the Talos cluster."
  type        = string
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

variable "flux_version" {
  description = "The version of Flux to use."
  type        = string
}

variable "prometheus_version" {
  description = "The version of Prometheus to use."
  type        = string
}

variable "prepare_longhorn" {
  description = "Prepare the cluster for Longhorn."
  type        = bool
  default     = false
}

variable "longhorn_mount_disk2" {
  description = "Mount disk2 for Longhorn."
  type        = bool
  default     = false
}

variable "prepare_spegel" {
  description = "Prepare the cluster for Spegel."
  type        = bool
  default     = false
}

variable "speedy_kernel_args" {
  description = "Use speedy kernel args."
  type        = bool
  default     = false
}

variable "prepare_kube_prometheus_metrics" {
  description = "Prepare the cluster for kube-prometheus-metrics."
  type        = bool
  default     = false
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

variable "kube_config_path" {
  description = "The path to output the Kubernetes configuration file."
  type        = string
}

variable "tld" {
  description = "The top-level domain to use."
  type        = string
}

variable "timeout" {
  description = "The timeout to use for the cluster."
  type        = string
}

variable "machines" {
  description = "A list of machines to create the talos cluster from."
  type = map(object({
    type = string
    install = object({
      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector
      extraKernelArgs = optional(list(string), [])
      extensions      = optional(list(string), [])
      secureboot      = optional(bool, false)
      wipe            = optional(bool, false)
      architecture    = optional(string, "amd64")
      platform        = optional(string, "metal")
      sbc             = optional(string, "")
    })
    disks = optional(list(object({
      device = string
      partitions = list(object({
        mountpoint = string
        size       = optional(string, "")
      }))
    })), [])
    labels = optional(list(object({
      key   = string
      value = string
    })), [])
    annotations = optional(list(object({
      key   = string
      value = string
    })), [])
    files = optional(list(object({
      content     = string
      permissions = string
      path        = string
      op          = string
    })), [])
    interfaces = list(object({
      hardwareAddr     = string
      addresses        = list(string)
      dhcp_routeMetric = optional(number, 100)
      vlans = optional(list(object({
        vlanId           = number
        addresses        = list(string)
        dhcp_routeMetric = optional(number, 100)
      })), [])
    }))
  }))
}

variable "aws" {
  description = "The AWS account to use."
  type = object({
    region  = string
    profile = string
  })
}

variable "unifi" {
  description = "The Unifi controller to use."
  type = object({
    address        = string
    site           = string
    username_store = string
    password_store = string
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
    account       = string
    email         = string
    api_key_store = string
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
