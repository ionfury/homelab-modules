run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name     = run.random.resource_name
  cluster_endpoint = "dev.k8s.tomnowak.work"

  talos_config_path           = "~/.talos/testing"
  kube_config_path            = "~/.kube/testing"
  machine_network_nameservers = ["192.168.10.1"]

  machines = {
    node44 = {
      type    = "controlplane"
      install = { diskSelectors = ["type: 'ssd'"] }
      interfaces = [{
        hardwareAddr = "ac:1f:6b:2d:ba:1e"
        addresses    = ["192.168.10.218"]
      }]
    }
    node45 = {
      type    = "controlplane"
      install = { diskSelectors = ["type: 'ssd'"] }
      interfaces = [{
        hardwareAddr = "ac:1f:6b:2d:bf:ce"
        addresses    = ["192.168.10.222"]
      }]
    }
    node46 = {
      type    = "controlplane"
      install = { diskSelectors = ["type: 'ssd'"] }
      interfaces = [{
        hardwareAddr = "ac:1f:6b:2d:c0:22"
        addresses    = ["192.168.10.246"]
      }]
    }
  }
}

run "setup" {
  variables {
    talos_version = "v1.9.0"
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
