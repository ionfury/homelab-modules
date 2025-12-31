variable "name" {
  description = "A name to provide for the cluster."
  type        = string
}

variable "env_vars" {
  description = "List of key value pairs to pass to cluster via the generated-cluster-vars.env."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "etcd_extraArgs" {
  description = "List of key value pairs to pass to the etcd service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "controllerManager_extraArgs" {
  description = "List of key value pairs to pass to the controller manager service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "scheduler_extraArgs" {
  description = "List of key value pairs to pass to the scheduler service."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "on_destroy" {
  description = "How to preform node destruction"
  type = object({
    graceful = bool
    reboot   = bool
    reset    = bool
  })
  default = {
    graceful = false
    reboot   = true
    reset    = true
  }
}

variable "features" {
  description = "Feature flags that enable optional cluster behavior."
  type        = set(string)
  default     = []

  validation {
    condition = alltrue([
      for f in var.features :
      contains([
        "longhorn",
        "cilium",
        "kernel-fast",
        "spegel",
        "gateway-api",
        "prometheus",
      ], f)
    ])
    error_message = "Unsupported feature specified."
  }
}

variable "networking" {
  description = "Cluster networking configuration."
  type = object({
    tld            = string
    vip            = string
    node_subnet    = string
    pod_subnet     = string
    service_subnet = string
  })
}

variable "versions" {
  description = "Component versions for the cluster."
  type = object({
    kubernetes  = string
    talos       = string
    cilium      = string
    flux        = string
    prometheus  = string
    gateway_api = string
  })

  default = {
    kubernetes  = "1.34.2"
    talos       = "v1.10.8"
    cilium      = "1.18.4"
    flux        = "v2.4.0"
    prometheus  = "20.0.0"
    gateway_api = "v1.4.1"
  }
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
  description = "Cluster machine inventory."
  type = map(object({
    type = string # controlplane | worker

    install = object({
      selector = string
      wipe     = optional(bool, true)

      # semantic data intent (used by features like longhorn)
      data = optional(object({
        enabled = bool
        tags    = optional(list(string), [])
      }))
    })

    disks = optional(list(object({
      device     = optional(string)
      mountpoint = string
      tags       = optional(list(string), [])
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

  validation {
    condition = alltrue([
      for _, m in var.machines :
      contains(["controlplane", "worker"], m.type)
    ])
    error_message = "Machine type must be 'controlplane' or 'worker'."
  }
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
