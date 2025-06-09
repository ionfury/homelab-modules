mock_provider "kubernetes" {
  alias = "mock"
}

run "plan" {
  command = plan
  providers = {
    kubernetes = kubernetes.mock
  }
  variables {
    name                    = "node"
    namespace               = run.create_namespace.name
    vm_count                = 3
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }

  assert {
    condition     = length(kubernetes_manifest.talos_vm) == 3
    error_message = "Expected 3 talos_vms!"
  }
}
