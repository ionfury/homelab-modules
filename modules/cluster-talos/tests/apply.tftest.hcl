run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "node"
    vm_count                = 3
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }
}

variables {
  talos_version        = "v1.10.0"
  kubernetes_version   = "1.32.0"
  talos_cluster_config = <<EOT
clusterName: cluster-talos-apply
allowSchedulingOnControlPlanes: true
controlPlane:
  endpoint: https://${run.provision.vmi["node-1"].ip}:6443
EOT

  machines = [
    {
      talos_config = <<EOT
type: controlplane
network:
  hostname: node-1
  nameservers:
    - 1.1.1.1
  interfaces:
    - deviceSelector:
        hardwareAddr: ${run.provision.vmi["node-1"].mac}
      dhcp: true
      addresses:
        - ${run.provision.vmi["node-1"].ip}/32
EOT
    },
    {
      talos_config = <<EOT
type: controlplane
network:
  hostname: node-2
  nameservers:
    - 1.1.1.1
  interfaces:
    - deviceSelector:
        hardwareAddr: ${run.provision.vmi["node-2"].mac}
      dhcp: true
      addresses:
        - ${run.provision.vmi["node-2"].ip}/32
EOT
    },
    {
      talos_config = <<EOT
type: controlplane
network:
  hostname: node-3
  nameservers:
    - 1.1.1.1
  interfaces:
    - deviceSelector:
        hardwareAddr: ${run.provision.vmi["node-3"].mac}
      dhcp: true
      addresses:
        - ${run.provision.vmi["node-3"].ip}/32
EOT
    }
  ]

  on_destroy = {
    graceful = false
    reboot   = false
    reset    = false
  }
}

run "apply" {
  variables {
    talos_version = "v1.10.0"
  }
}

run "upgrade" {
  variables {
    talos_version = "v1.10.1"
  }
}
