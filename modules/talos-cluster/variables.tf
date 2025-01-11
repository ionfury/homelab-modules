variable "cluster_name" {
  description = "A name to provide for the Talos cluster."
  type        = string
  default     = "cluster"

  validation {
    condition     = length(var.cluster_name) <= 32 && can(regex("^([a-z0-9]+-)*[a-z0-9]+$", var.cluster_name))
    error_message = "The name must contain at most 32 characters, begin and end with a lower case alphanumeric character, and may contain lower case alphanumeric characters and dashes between."
  }
}

variable "cluster_id" {
  description = "An ID to provide for the Talos cluster."
  type        = number
  default     = 1
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster."
  type        = string
  default     = "https://10.10.10.10:6443"
}

variable "cluster_vip" {
  description = "The VIP to use for the Talos cluster. Applied to the first interface of control plane hosts."
  type        = string
  default     = ""
}

variable "cluster_node_subnet" {
  description = "The subnet to use for the Talos cluster nodes."
  type        = string
  default     = "192.168.10.0/24"
}

variable "cluster_pod_subnet" {
  description = "The pod subnet to use for pods on the Talos cluster."
  type        = string
  default     = "172.16.0.0/16"
}

variable "cluster_service_subnet" {
  description = "The pod subnet to use for services on the Talos cluster."
  type        = string
  default     = "172.17.0.0/16"
}

variable "talos_config_path" {
  description = "The path to output the Talos configuration file."
  type        = string
  default     = "~/.talos"
}

variable "kube_config_path" {
  description = "The path to output the Kubernetes configuration file."
  type        = string
  default     = "~/.kube"
}

variable "kubernetes_version" {
  description = "The version of kubernetes to deploy."
  type        = string
  default     = "1.30.1"
}

variable "talos_version" {
  description = "The version of Talos to use."
  type        = string
  default     = "v1.8.3"
}

variable "cilium_version" {
  description = "The version of Cilium to use."
  type        = string
  default     = "1.16.5"
}

variable "prometheus_crd_version" {
  description = "The version of the Prometheus CRD to use."
  type        = string
  default     = "17.0.2"
}

variable "spegal_version" {
  description = "The version of Spegal to use."
  type        = string
  default     = "v0.0.28"
}

variable "gateway_api_version" {
  description = "The version of the Gateway API to use."
  type        = string
  default     = "v1.2.1"
}

variable "nameservers" {
  description = "A list of nameservers to use for the Talos cluster."
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "ntp_servers" {
  description = "A list of NTP servers to use for the Talos cluster."
  type        = list(string)
  default     = ["0.pool.ntp.org", "1.pool.ntp.org"]
}

variable "gracefully_destroy_nodes" {
  description = "Whether to gracefully destroy nodes."
  type        = bool
  default     = false
}

variable "timeout" {
  description = "The timeout to use for the Talos cluster."
  type        = string
  default     = "10m"
}

variable "hosts" {
  description = "A map of current hosts from which to build the Talos cluster."
  type = map(object({
    role = string
    install = object({
      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector
      extraKernelArgs = optional(list(string), [])
      extensions      = optional(list(string), [])
      secureboot      = optional(bool, false)
      wipe            = optional(bool, false)
      architecture    = optional(string, "amd64")
      platform        = optional(string, "metal")
    })
    interfaces = list(object({
      hardwareAddr     = string
      addresses        = list(string)
      dhcp_routeMetric = optional(number, 100)
      vlans = list(object({
        vlanId           = number
        addresses        = list(string)
        dhcp_routeMetric = optional(number, 100)
      }))
    }))
  }))

  validation {
    condition     = length(var.hosts) > 0
    error_message = "At least one host must be provided."
  }

  validation {
    condition     = alltrue([for host in var.hosts : length(host.interfaces) > 0])
    error_message = "At least one interface must be provided for each host."
  }

  validation {
    condition     = alltrue([for host in var.hosts : host.role == "worker" || host.role == "controlplane"])
    error_message = "The host role must be either 'worker', 'controlplane'."
  }
}

variable "run_talos_upgrade" {
  description = "Weather or not to run `talosctl upgrade`.  This should be set to true only after the cluster has been created."
  type        = bool
  default     = false
}
