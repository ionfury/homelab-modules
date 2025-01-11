run "random" {
  module {
    source = "./tests/harness/random"
  }
}

run "setup" {
  variables {
    cluster_name       = run.random.resource_name
    cluster_endpoint   = "https://dev.k8s.tomnowak.work:6443"
    kubernetes_version = "1.30.2"
    nameservers        = ["192.168.10.1"]
    hosts = {
      node44 = {
        role = "controlplane"
        install = {
          diskSelectors = ["type: 'ssd'"]
        }
        interfaces = [
          {
            hardwareAddr = "ac:1f:6b:2d:ba:1e"
            addresses    = ["192.168.10.218"]
            vlans        = []
          }
        ]
      }
      node45 = {
        role = "controlplane"
        install = {
          diskSelectors = ["type: 'ssd'"]
        }
        interfaces = [
          {
            hardwareAddr = "ac:1f:6b:2d:bf:ce"
            addresses    = ["192.168.10.222"]
            vlans        = []
          }
        ]
      }
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
    condition     = length(data.kubernetes_nodes.this.nodes) == 3
    error_message = "Incorrect number of nodes: ${length(data.kubernetes_nodes.this.nodes)}"
  }

  assert {
    condition     = alltrue([for node in data.kubernetes_nodes.this.nodes : contains(["node44", "node45", "node46"], node.metadata[0].name)])
    error_message = "A kubernetes node has an incorrect name."
  }

  assert {
    condition     = alltrue([for node in data.kubernetes_nodes.this.nodes : contains(["192.168.10.218", "192.168.10.222", "192.168.10.246"], node.status[0].addresses[0].address)])
    error_message = "A kubernetes node has an incorrect address."
  }

  assert {
    condition     = alltrue([for node in data.kubernetes_nodes.this.nodes : node.spec[0].unschedulable == false])
    error_message = "A kubernetes node is unschedulable."
  }

  assert {
    condition     = data.kubernetes_server_version.this.version == "1.30.2"
    error_message = "Incorrect kubernetes server version: ${data.kubernetes_server_version.this.version}"
  }
}
