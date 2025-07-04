run "apply" {
  variables {
    name                    = "node"
    vm_count                = 3
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }

  assert {
    condition     = length(kubernetes_manifest.talos_vm) == 3
    error_message = "Expected 3 talos_vms!"
  }

  assert {
    condition     = length(kubernetes_service.this) == 3
    error_message = "Expected 3 LBs!"
  }

  assert {
    condition     = kubernetes_service.this["node-1"].metadata[0].name == "node-1"
    error_message = "Incorrect name"
  }
}
