variable "talos_version" {
  description = "The version of Talos to use."
  type        = string
}

variable "kubernetes_version" {
  description = "The version of kubernetes to deploy."
  type        = string
}

variable "talos_cluster_config" {
  description = "The config for the talos cluster.  This will be applied to each controlplane node. See: https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.cluster"
  type        = string
}

variable "machines" {
  description = "A list of machines to create the talos cluster from."
  type = list(object({
    talos_config      = string # https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.machine
    extensions        = optional(list(string), [])
    extra_kernel_args = optional(list(string), [])
    secureboot        = optional(bool, false)
    architecture      = optional(string, "amd64")
    platform          = optional(string, "metal")
    sbc               = optional(string, "")
  }))

  validation {
    condition     = length(var.machines) > 0
    error_message = "At least one machine must be provided."
  }
}

variable "bootstrap_charts" {
  description = "A list of helm charts to bootstrap into talos via inline_manifests."
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

variable "on_destroy" {
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

variable "talos_config_path" {
  description = "The path to output the Talos configuration file."
  type        = string
  default     = "~/.talos"
}

variable "kubernetes_config_path" {
  description = "The path to output the Kubernetes configuration file."
  type        = string
  default     = "~/.kube"
}

variable "timeout" {
  description = "The timeout to use for the Talos cluster."
  type        = string
  default     = "10m"
}
