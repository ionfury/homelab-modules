run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name     = run.random.resource_name
  cluster_endpoint = "https://192.168.10.246:6443"
  hosts = {
    node44 = {
      role = "controlplane"
      install = {
        diskSelectors = ["type: 'ssd'"]
      }
      interfaces = [
        {
          hardwareAddr = "ac:1f:6b:2d:c0:22"
          addresses    = ["192.168.10.246"]
          vlans        = []
        }
      ]
    }
  }
}

run "setup" {
  variables {
    talos_version     = "v1.8.3"
    run_talos_upgrade = false
  }
}

run "upgrade" {
  variables {
    talos_version     = "v1.8.4"
    run_talos_upgrade = true
  }
}

run "wait" {
  module {
    source = "./tests/harness/wait"
  }

  variables {
    duration = "120s"
  }
}

run "kubernetes" {
  module {
    source = "./tests/harness/kubernetes"
  }

  variables {
    kubeconfig_host                   = run.upgrade.kubeconfig_host
    kubeconfig_client_certificate     = run.upgrade.kubeconfig_client_certificate
    kubeconfig_client_key             = run.upgrade.kubeconfig_client_key
    kubeconfig_cluster_ca_certificate = run.upgrade.kubeconfig_cluster_ca_certificate
  }

  assert {
    condition     = data.kubernetes_server_version.this.version == "1.30.1"
    error_message = "Incorrect kubernetes server version: ${data.kubernetes_server_version.this.version}"
  }
}
