run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "cluster-talos-apply"
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
  endpoint: https://${run.provision.lb.dns}:6443
EOT

    machines = [
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-1
  interfaces:
    - addresses:
      - ${run.provision.vms["cluster-talos-apply-talos-vm-1"].ip}
EOT
      },
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-2
  interfaces:
    - addresses:
      - ${run.provision.vms["cluster-talos-apply-talos-vm-2"].ip}
EOT
      },
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-3
  interfaces:
    - addresses:
      - ${run.provision.vms["cluster-talos-apply-talos-vm-3"].ip}
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
