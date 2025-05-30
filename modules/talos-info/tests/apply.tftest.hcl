run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "talos-info"
    vm_count                = 1
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }
}

run "init" {
  module {
    source = "../cluster-talos"
  }

  variables {
    talos_version      = "v1.10.0"
    kubernetes_version = "1.32.0"
    talos_config_path  = "~/.talos/testing"

    talos_cluster_config = <<EOT
clusterName: talos-info
allowSchedulingOnControlPlanes: true
controlPlane:
  endpoint: https://${run.provision.lb.dns}:6443
EOT

    machines = [
      {
        talos_config = <<EOT
type: controlplane
time:
  servers:
    - 0.pool.ntp.org
network:
  hostname: talos-info-talos-vm-1
  nameservers:
    - kube-dns.kube-system.svc.cluster.local
  interfaces:
    - deviceSelector:
        physical: true
      addresses:
        - ${run.provision.vms["talos-info-talos-vm-1"].ip}
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

run "test" {
  variables {
    talos_config_path = "~/.talos/testing/talos-info"
    node              = "talos-info-talos-vm-1"
  }

  assert {
    condition     = output.talos_version == "v1.10.1"
    error_message = "output.talos_version is not as expected: v1.10.1"
  }

  assert {
    condition     = output.schematic_version == "613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245"
    error_message = "output.schematic_version is not as expected: 613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245"
  }

  assert {
    condition     = output.interfaces == "[\"${run.provision.vms["talos-info-talos-vm-1"].ip}\"]"
    error_message = "output.interfaces is not as expected"
  }

  assert {
    condition     = output.nameservers == "asdf"
    error_message = "output.nameservers is not as expected"
  }

  assert {
    condition     = output.timeservers == "[\"0.pool.ntp.org\"]"
    error_message = "output.timeservers is not as expected"
  }

  assert {
    condition     = output.controlplane_schedulable == "true"
    error_message = "output.controlplane_schedulable is not as expected: true"
  }

  assert {
    condition     = output.machine_type == "controlplane"
    error_message = "output.machine_type is not as expected: controlplane"
  }
}
