run "test" {
  variables {
    name                    = "homelab-modules-"
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
