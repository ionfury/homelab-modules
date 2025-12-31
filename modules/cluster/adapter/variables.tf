variable "name" {
  description = "Cluster name."
  type        = string
}

variable "features" {
  description = "Enabled cluster features."
  type        = set(string)
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

variable "machines" {
  description = "Intent-level machine inventory from the cluster module."
  type = map(object({
    type = string # controlplane | worker

    install = object({
      selector = string
      wipe     = optional(bool, true)

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

variable "env_vars" {
  description = "List of key value pairs to pass to cluster via the generated-cluster-vars.env."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "versions" {
  description = "Component versions for generating extraManifests."
  type = object({
    prometheus  = optional(string, "20.0.0")
    gateway_api = optional(string, "v1.4.1")
  })
  default = {}
}

variable "nameservers" {
  description = "The nameservers to use for the cluster nodes."
  type        = list(string)
}

variable "timeservers" {
  description = "The timeservers to use for the cluster nodes."
  type        = list(string)
}
