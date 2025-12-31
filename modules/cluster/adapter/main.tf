locals {
  feature_longhorn    = contains(var.features, "longhorn")
  feature_kernelfast  = contains(var.features, "kernel-fast")
  feature_spegel      = contains(var.features, "spegel")
  feature_prometheus  = contains(var.features, "prometheus")
  feature_gateway_api = contains(var.features, "gateway-api")

  dns_name         = "k8s.${var.networking.tld}"
  cluster_endpoint = "https://${local.dns_name}:6443"

  extra_manifests = concat(
    local.feature_prometheus ? [
      "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.versions.prometheus}/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml",
      "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.versions.prometheus}/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml",
      "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.versions.prometheus}/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml",
      "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.versions.prometheus}/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml",
    ] : [],
    local.feature_gateway_api ? [
      "https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.versions.gateway_api}/experimental-install.yaml",
    ] : []
  )

  primary_interface = {
    for name, m in var.machines :
    name => m.interfaces[0]
  }

  primary_ip = {
    for name, iface in local.primary_interface :
    name => iface.addresses[0].ip
  }

  primary_mac = {
    for name, iface in local.primary_interface :
    name => iface.hardwareAddr
  }

  kernel_args = {
    fast = [
      "apparmor=0",
      "init_on_alloc=0",
      "init_on_free=0",
      "mitigations=off",
      "security=none",
    ]
  }

  longhorn = {
    extensions = [
      "iscsi-tools",
      "util-linux-tools",
    ]

    labels = [
      {
        key   = "node.longhorn.io/create-default-disk"
        value = "config"
      }
    ]

    kubelet_root_mount = {
      destination = "/var/lib/longhorn"
      type        = "bind"
      source      = "/var/lib/longhorn"
      options     = ["bind", "rshared", "rw"]
    }
  }

  machines = {
    for name, m in var.machines :
    name => {
      type       = m.type
      interfaces = m.interfaces

      primary_ip  = local.primary_ip[name]
      primary_mac = local.primary_mac[name]

      install = {
        selector          = m.install.selector
        wipe              = m.install.wipe
        extensions        = local.feature_longhorn ? local.longhorn.extensions : []
        extra_kernel_args = local.feature_kernelfast ? local.kernel_args.fast : []
      }

      labels = concat(
        m.labels,
        local.feature_longhorn ? local.longhorn.labels : []
      )

      kubelet_extraMounts = concat(
        local.feature_longhorn ? [local.longhorn.kubelet_root_mount] : [],
        [
          for d in m.disks : {
            destination = d.mountpoint
            type        = "bind"
            source      = d.mountpoint
            options     = ["bind", "rshared", "rw"]
          }
        ]
      )

      files = concat(
        m.files,
        local.feature_spegel ? [
          {
            path        = "/etc/cri/conf.d/20-customization.part"
            op          = "create"
            permissions = "0o666"
            content     = <<-EOT
              [plugins."io.containerd.cri.v1.images"]
                discard_unpacked_layers = false
            EOT
          }
        ] : []
      )

      annotations = concat(
        m.annotations,
        local.feature_longhorn && (
          try(m.install.data.enabled, false) || length(m.disks) > 0
          ) ? [
          {
            key = "node.longhorn.io/default-disks-config"
            value = "'${jsonencode([
              for d in concat(
                try(m.install.data.enabled, false) ? [
                  {
                    mountpoint = "/var/lib/longhorn"
                    tags       = try(m.install.data.tags, [])
                  }
                ] : [],
                m.disks
                ) : {
                name            = basename(d.mountpoint)
                path            = d.mountpoint
                storageReserved = 0
                allowScheduling = true
                tags            = try(d.tags, [])
              }
            ])}'"
          }
        ] : []
      )

      disks = m.disks
    }
  }

  runtime_machines = {
    for name, m in local.machines :
    name => {
      talos_config = templatefile("${path.module}/../resources/templates/talos_machine.yaml.tftpl", {
        machine_type                = m.type
        cluster_node_subnet         = var.networking.node_subnet
        machine_kubelet_extraMounts = m.kubelet_extraMounts
        machine_hostname            = name
        machine_interfaces          = m.interfaces
        cluster_vip                 = var.networking.vip
        machine_nameservers         = [] # Runtime will provide these
        machine_timeservers         = [] # Runtime will provide these
        machine_disks = [
          for d in m.disks : {
            device     = try(d.device, null)
            mountpoint = d.mountpoint
          }
        ]
        machine_install = {
          extra_kernel_args = m.install.extra_kernel_args
          wipe              = m.install.wipe
        }
        machine_labels      = m.labels
        machine_annotations = m.annotations
        machine_files       = m.files
      })
      selector          = m.install.selector
      extensions        = m.install.extensions
      extra_kernel_args = m.install.extra_kernel_args
      secureboot        = false
      architecture      = "amd64"
      platform          = "metal"
      sbc               = ""
    }
  }
}
