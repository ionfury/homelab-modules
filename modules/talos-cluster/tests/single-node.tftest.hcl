run "random" {
  module {
    source = "./tests/harness/random"
  }
}

run "setup" {
  variables {
    cluster_name       = run.random.resource_name
    cluster_endpoint   = "https://192.168.10.246:6443"
    kubernetes_version = "1.30.2"
    hosts = {
      node46 = {
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

  // Assert setup completes successfully
}

run "kubernetes" {
  module {
    source = "./tests/harness/kubernetes"
  }

  variables {
    kubeconfig_host                   = run.setup.kubeconfig_host
    kubeconfig_client_certificate     = run.setup.kubeconfig_client_certificate
    kubeconfig_client_key             = run.setup.kubeconfig_client_key
    kubeconfig_cluster_ca_certificate = run.setup.kubeconfig_cluster_ca_certificate
  }

  assert {
    condition     = length(data.kubernetes_nodes.this.nodes) == 1
    error_message = "Incorrect number of nodes: ${length(data.kubernetes_nodes.this.nodes)}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].metadata[0].name == "node46"
    error_message = "Incorrect node name: ${data.kubernetes_nodes.this.nodes[0].metadata[0].name}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].status[0].addresses[0].address == "192.168.10.246"
    error_message = "Incorrect node address: ${data.kubernetes_nodes.this.nodes[0].status[0].addresses[0].address}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].spec[0].unschedulable == false
    error_message = "Node is unschedulable."
  }

  assert {
    condition     = data.kubernetes_server_version.this.version == "1.30.2"
    error_message = "Incorrect kubernetes server version: ${data.kubernetes_server_version.this.version}"
  }
}
