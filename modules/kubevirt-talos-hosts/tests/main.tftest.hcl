run "random" {
  module {
    source = "./tests/harness/random"
  }
}

run "get_secret" {
  module {
    source = "../params-get"
  }

  variables {
    aws = {
      region  = "us-east-2"
      profile = "terragrunt"
    }
    parameters = ["/homelab/infrastructure/clusters/live/kubeconfig"]
  }
}

run "test" {
  variables {
    name                    = run.random.resource_name
    vm_count                = 2
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"

    kubernetes_config = run.get_secret.values["/homelab/infrastructure/clusters/live/kubeconfig"]
  }

  assert {
    condition     = length(kubernetes_manifest.talos_vm) == 2
    error_message = "Expected 2 talos_vms!"
  }
}
