run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name     = run.random.resource_name
  cluster_endpoint = "192.168.10.218"

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
  }
}

run "setup" {
  variables {
    talos_version = "v1.9.0"
  }
}

run "talos_version_check" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/${run.random.resource_name}.yaml"
    node              = "node44"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.0"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}

run "upgrade" {
  variables {
    talos_version = "v1.9.1"
  }
}

run "talos_upgrade_check" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/${run.random.resource_name}.yaml"
    node              = "node44"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}
