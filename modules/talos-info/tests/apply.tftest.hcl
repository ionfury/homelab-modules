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
  endpoint: https://${run.provision.lb.ip}:6443
EOT

    machines = [
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: talos-info-talos-vm-1
  interfaces:
    - deviceSelector:
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["talos-info-talos-vm-1"].ip}
  nameservers:
    - 1.1.1.1
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
    talos_config_path = run.init.talosconfig_filename
    node              = "talos-info-talos-vm-1"
  }

  assert {
    condition     = output.talos_version == "v1.10.0"
    error_message = "output.talos_version is not as expected"
  }

  assert {
    condition     = output.schematic_version == "376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"
    error_message = "output.schematic_version is not as expected"
  }

  assert {
    condition     = output.interfaces == "[\"${run.provision.vms["talos-info-talos-vm-1"].ip}\"]"
    error_message = "output.interfaces is not as expected"
  }
  /*
  assert {
    condition     = output.nameservers == "[\"1.1.1.1\"]"
    error_message = "output.nameservers is not as expected"
  }

  assert {
    condition     = output.controlplane_schedulable == "true"
    error_message = "output.controlplane_schedulable is not as expected"
  }
*/
  assert {
    condition     = output.machine_type == "controlplane"
    error_message = "output.machine_type is not as expected"
  }
}
