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

variable "prometheus_version" {
  description = "The version of Prometheus to use."
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
      #     hardwareAddr     = string
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
    region = string
  })
}

variable "unifi" {
  description = "The Unifi controller to use."
  type = object({
    address       = string
    site          = string
    api_key_store = string
  })
}

variable "ssm_output_path" {
  description = "The aws ssm parameter path to store config in."
  type        = string
  default     = "/homelab/infrastructure/clusters"
}
