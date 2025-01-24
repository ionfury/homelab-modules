variable "cluster_name" {
  description = "A name to provide for the Talos cluster."
  type        = string
  default     = "cluster"

  validation {
    condition     = length(var.cluster_name) <= 32 && can(regex("^([a-z0-9]+-)*[a-z0-9]+$", var.cluster_name))
    error_message = "The name must contain at most 32 characters, begin and end with a lower case alphanumeric character, and may contain lower case alphanumeric characters and dashes between."
  }
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster."
  type        = string
  default     = "10.10.10.10"
}

variable "cluster_vip" {
  description = "The VIP to use for the Talos cluster. Applied to the first interface of control plane machines."
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

variable "cluster_allowSchedulingOnControlPlanes" {
  description = "Whether to allow scheduling on control plane nodes."
  type        = bool
  default     = true
}

variable "cluster_coreDNS_disabled" {
  description = "Whether to disable CoreDNS."
  type        = bool
  default     = false
}

variable "cluster_proxy_disabled" {
  description = "Whether to disable the kube-proxy."
  type        = bool
  default     = true
}

variable "cluster_extraManifests" {
  description = "A list of extra manifests to apply to the Talos cluster."
  type        = list(string)
  default     = []
}

variable "cluster_inlineManifests" {
  description = "A list of inline manifests to apply to the Talos cluster."
  type = list(object({
    name     = string
    contents = string
  }))
  default = []
}

variable "machine_files" {
  description = "A list of files to add to all machines in the cluster. See: https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.files."
  type = list(object({
    content     = string
    permissions = string
    path        = string
    op          = string
  }))
  default = []

  validation {
    condition     = alltrue([for file in var.machine_files : file.op == "create" || file.op == "append" || file.op == "overwrite"])
    error_message = "The 'op' field in machine_files must be one of 'create', 'append', or 'overwrite'."
  }
}

variable "machine_extensions" {
  description = "A list of extensions to add to all machines in the cluster."
  type        = list(string)
  default     = []
}

variable "machine_extra_kernel_args" {
  description = "A list of extra kernel arguments to add to the machines."
  type        = list(string)
  default     = []
}

variable "machine_kubelet_extraMounts" {
  description = "A list of extra mounts to add to the kubelet."
  type = list(object({
    destination = string
    type        = string
    source      = string
    options     = list(string)
  }))
  default = []
}

variable "machine_network_nameservers" {
  description = "A list of nameservers to use for the Talos cluster."
  type        = list(string)
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "machine_time_servers" {
  description = "A list of NTP servers to use for the Talos cluster."
  type        = list(string)
  default     = ["0.pool.ntp.org", "1.pool.ntp.org"]
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
  default     = "v1.9.0"
}

variable "cilium_version" {
  description = "The version of Cilium to use."
  type        = string
  default     = "1.16.5"
}

variable "cilium_helm_values" {
  description = <<EOT
The values to use for the Cilium Helm chart.
  See: https://github.com/cilium/cilium/blob/main/install/kubernetes/cilium/values.yaml\n
  And: https://www.talos.dev/v1.9/kubernetes-guides/network/deploying-cilium/#without-kube-proxy
EOT
  type        = string
  default     = <<EOT
ipam:
  mode: kubernetes
kubeProxyReplacement: true
cgroup:
  autoMount:
    enabled: false
  hostRoot: /sys/fs/cgroup
k8sServiceHost: 127.0.0.1
k8sServicePort: 7445
securityContext:
  capabilities:
    ciliumAgent:
      - CHOWN
      - KILL
      - NET_ADMIN
      - NET_RAW
      - IPC_LOCK
      - SYS_ADMIN
      - SYS_RESOURCE
      - PERFMON
      - BPF
      - DAC_OVERRIDE
      - FOWNER
      - SETGID
      - SETUID
    cleanCiliumState:
      - NET_ADMIN
      - SYS_ADMIN
      - SYS_RESOURCE
EOT
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

variable "machines" {
  description = "A list of machines to create the talos cluster from."
  type = map(object({
    type           = string
    first_scale_in = optional(bool, false) # Must be set to 'true' when adding a new node to an existing cluster.  Set to 'false' once the node is in the cluster. https://github.com/siderolabs/terraform-provider-talos/issues/221
    install = object({
      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector
      extraKernelArgs = optional(list(string), [])
      extensions      = optional(list(string), [])
      secureboot      = optional(bool, false)
      wipe            = optional(bool, false)
      architecture    = optional(string, "amd64")
      platform        = optional(string, "metal")
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

  validation {
    condition     = length(var.machines) > 0
    error_message = "At least one machine must be provided."
  }

  validation {
    condition     = alltrue([for machine in var.machines : length(machine.interfaces) > 0])
    error_message = "At least one interface must be provided for each machine."
  }

  validation {
    condition     = alltrue([for machine in var.machines : machine.type == "worker" || machine.type == "controlplane"])
    error_message = "The machine type must be either 'worker', 'controlplane'."
  }
}

variable "stage_talos_upgrade" {
  description = "Weather or not to stage talos upgrades.  If this is set to false, the upgrade will be applied immediately and node will reboot."
  type        = bool
  default     = false
}

