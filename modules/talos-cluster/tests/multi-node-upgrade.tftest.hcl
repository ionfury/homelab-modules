run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  stage_talos_upgrade = true

  cluster_name                           = run.random.resource_name
  cluster_endpoint                       = "dev.k8s.tomnowak.work"
  cluster_allowSchedulingOnControlPlanes = true

  kubernetes_version          = "1.30.2"
  talos_config_path           = "~/.talos/testing"
  kube_config_path            = "~/.kube/testing"
  machine_network_nameservers = ["192.168.10.1"]
  machine_time_servers        = ["0.pool.ntp.org", "1.pool.ntp.org"]

  machines = {
    node44 = {
      type = "controlplane"
      install = {
        diskSelectors = ["type: 'ssd'"]
      }
      interfaces = [
        {
          hardwareAddr = "ac:1f:6b:2d:ba:1e"
          addresses    = ["192.168.10.218"]
        }
      ]
    }
    node45 = {
      type = "controlplane"
      install = {
        diskSelectors = ["type: 'ssd'"]
      }
      interfaces = [
        {
          hardwareAddr = "ac:1f:6b:2d:bf:ce"
          addresses    = ["192.168.10.222"]
        }
      ]
    }
    node46 = {
      type = "controlplane"
      install = {
        diskSelectors = ["type: 'ssd'"]
      }
      interfaces = [
        {
          hardwareAddr = "ac:1f:6b:2d:c0:22"
          addresses    = ["192.168.10.246"]
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

run "setup_talos_test_node44" {
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
    condition     = data.external.talos_info.result["schematic_version"] == "376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"
    error_message = "Incorrect schematic version: ${data.external.talos_info.result["schematic_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["interfaces"] == "{\"hardwareAddr\":\"ac:1f:6b:2d:ba:1e\",\"addresses\":[\"192.168.10.218/24\"]}"
    error_message = "Incorrect interfaces: ${data.external.talos_info.result["interfaces"]}"
  }

  assert {
    condition     = data.external.talos_info.result["nameservers"] == "[\"192.168.10.1:53\"]"
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

run "setup_talos_test_node45" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node45"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.0"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["schematic_version"] == "376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"
    error_message = "Incorrect schematic version: ${data.external.talos_info.result["schematic_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["interfaces"] == "{\"hardwareAddr\":\"aac:1f:6b:2d:bf:ce\",\"addresses\":[\"192.168.10.222/24\"]}"
    error_message = "Incorrect interfaces: ${data.external.talos_info.result["interfaces"]}"
  }

  assert {
    condition     = data.external.talos_info.result["nameservers"] == "[\"192.168.10.1:53\"]"
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

run "setup_talos_testnode46" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node46"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.0"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["schematic_version"] == "376567988ad370138ad8b2698212367b8edcb69b5fd68c80be1f2ec7d603b4ba"
    error_message = "Incorrect schematic version: ${data.external.talos_info.result["schematic_version"]}"
  }

  assert {
    condition     = data.external.talos_info.result["interfaces"] == "{\"hardwareAddr\":\"ac:1f:6b:2d:c0:22\",\"addresses\":[\"192.168.10.246/24\"]}"
    error_message = "Incorrect interfaces: ${data.external.talos_info.result["interfaces"]}"
  }

  assert {
    condition     = data.external.talos_info.result["nameservers"] == "[\"192.168.10.1:53\"]"
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

run "upgrade_talos_test_node44" {
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

run "upgrade_talos_test_node45" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node45"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}

run "upgrade_talos_test_node46" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node46"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}
