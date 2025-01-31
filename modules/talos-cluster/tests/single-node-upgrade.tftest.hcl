run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name                           = run.random.resource_name
  cluster_endpoint                       = "192.168.10.218"
  cluster_allowSchedulingOnControlPlanes = true

  kubernetes_version          = "1.30.2"
  talos_version               = "v1.9.0"
  talos_config_path           = "~/.talos/testing"
  kube_config_path            = "~/.kube/testing"
  machine_network_nameservers = ["1.1.1.1", "1.0.0.1"]
  machine_time_servers        = ["0.pool.ntp.org", "1.pool.ntp.org"]
  machine_extra_kernel_args   = ["apparmor=0"]
  machine_extensions          = ["iscsi-tools"]

  machines = {
    node44 = {
      type = "controlplane"
      install = {
        diskSelectors   = ["type: 'ssd'"]
        extraKernelArgs = ["init_on_alloc=0"]
        extensions      = ["util-linux-tools"]
      }
      interfaces = [
        {
          hardwareAddr = "ac:1f:6b:2d:ba:1e"
          addresses    = ["192.168.10.218"]
        }
      ]
    }
  }
}

run "setup" {
  variables {
    talos_version = "v1.9.0"
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
    condition     = length(data.kubernetes_nodes.this.nodes) == 1
    error_message = "Incorrect number of nodes: ${length(data.kubernetes_nodes.this.nodes)}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].metadata[0].name == "node44"
    error_message = "Incorrect node name: ${data.kubernetes_nodes.this.nodes[0].metadata[0].name}"
  }

  assert {
    condition     = data.kubernetes_nodes.this.nodes[0].status[0].addresses[0].address == "192.168.10.218"
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

run "wait" {
  module {
    source = "./tests/harness/wait"
  }

  variables {
    duration = "30s"
  }
}

run "setup_talos_test" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node44"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.0"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["schematic_version"] == "2b4700528da81c8b8c68e9909ac73269b5a00b1554d9bbe032becdf6675129c7"
    error_message = "Incorrect schematic version: ${data.external.talos_info.result["schematic_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["interfaces"] == "{\"hardwareAddr\":\"ac:1f:6b:2d:ba:1e\",\"addresses\":[\"192.168.10.218/24\"]}"
    error_message = "Incorrect interfaces: ${data.external.talos_info.result["interfaces"]}"
  }

  assert {
    condition     = data.external.talos_info.result["nameservers"] == "[\"1.1.1.1:53\",\"1.0.0.1:53\"]"
    error_message = "Incorrect nameservers: ${data.external.talos_info.result["nameservers"]}"
  }

  assert {
    condition     = data.external.talos_info.result["timeservers"] == "[\"0.pool.ntp.org\",\"1.pool.ntp.org\"]"
    error_message = "Incorrect timeservers: ${data.external.talos_info.result["timeservers"]}"
  }

  assert {
    condition     = data.external.talos_info.result["controlplane_schedulable"] == "true"
    error_message = "Controlplane is not schedulable: ${data.external.talos_info.result["controlplane_schedulable"]}"
  }

  assert {
    condition     = data.external.talos_info.result["machine_type"] == "controlplane"
    error_message = "Incorrect machine type: ${data.external.talos_info.result["machine_type"]}"
  }
}

run "upgrade" {
  variables {
    talos_version = "v1.9.1"
  }
}

run "wait" {
  module {
    source = "./tests/harness/wait"
  }

  variables {
    duration = "30s"
  }
}


run "upgrade_talos_test" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node44"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}
