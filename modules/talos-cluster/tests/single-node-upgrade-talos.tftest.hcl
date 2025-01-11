run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name      = run.random.resource_name
  cluster_endpoint  = "https://192.168.10.246:6443"
  talos_config_path = "~/.talos"
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

run "setup" {
  variables {
    talos_version     = "v1.8.3"
    run_talos_upgrade = true
  }
}


run "talos_check" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/${run.random.resource_name}.yaml"
    node              = "node46"
  }

  assert {
    condition     = data.external.talos_version.result.talos_version == "v1.8.3"
    error_message = "Incorrect talos version: ${data.external.talos_version.result.talos_version}"
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
    duration = "120s" // No idea how long this should be, does it even need to wait?
  }
}

run "talos_upgrade_check" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/${run.random.resource_name}.yaml"
    node              = "node46"
  }

  assert {
    condition     = data.external.talos_version.result.talos_version == "v1.8.4"
    error_message = "Incorrect talos version: ${data.external.talos_version.result.talos_version}"
  }
}
