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

run "apply" {
  variables {
    talos_version        = "v1.10.0"
    kubernetes_version   = "1.32.0"
    talos_cluster_config = <<EOT
clusterName: cluster-talos-apply
allowSchedulingOnControlPlanes: true
controlPlane:
  endpoint: https://${run.provision.lb.ip}:6443
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
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["node-1"].ip}/32
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
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["node-2"].ip}/32
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
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["node-3"].ip}/32
EOT        
      }
    ]

    on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
    }
  }
}
/*
run "test" {
  module {
    source = "../talos-info"
  }
  variables {
    talos_config_path = run.apply.talosconfig_filename
    node              = "cluster-talos-apply-1"
  }

  assert {
    condition     = output.talos_version == "v1.10.0"
    error_message = "output.talos_version is not as expected"
  }
}
*/
