run "create_namespace" {
  module {
    source = "../kubernetes-namespace"
  }

  variables {
    name = "homelab-modules"
  }

}

run "test" {
  variables {
    name                    = "homelab-modules"
    namespace               = run.create_namespace.outputs.name
    vm_count                = 2
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }

  assert {
    condition     = length(kubernetes_manifest.talos_vm) == 2
    error_message = "Expected 2 talos_vms!"
  }
}
