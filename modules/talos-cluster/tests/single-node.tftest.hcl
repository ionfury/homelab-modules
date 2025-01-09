run "setup" {
  variables {
    cluster_name                     = "test-single-node"
    cluster_endpoint                 = "https://192.168.10.246:6443"
    kubernetes_version               = "1.30.2"
    allow_scheduling_on_controlplane = true
    hosts = {
      node46 = {
        role = "controlplane"
        install = {
          diskSelector = ["type: 'ssd'"]
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
  /*
  assert {
    condition     = length(data.kubernetes_nodes.this.nodes) == 1
    error_message = "Incorrect number of nodes: ${length(data.kubernetes_nodes.this.nodes)}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].metadata.name == "node46"
    error_message = "Incorrect node name: ${data.kubernetes_nodes.this.nodes[0].metadata.name}"
  }

  assert {
    condition = alltrue([
      for node in data.kubernetes_nodes.this.nodes :
      contains(keys(node.metadata[0].labels), "node-role.kubernetes.io/control-plane") ?
      node.spec[0].unschedulable == false : true
    ])
    error_message = "One or more control plane nodes are unschedulable."
  }
*/
  assert {
    condition     = data.kubernetes_server_version.this.version == "1.30.2"
    error_message = "Incorrect kubernetes server version: ${data.kubernetes_server_version.this.version}"
  }

}
