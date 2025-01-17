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
  talos_config_path           = "~/.talos"
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

run "wait_setup" {
  module {
    source = "./tests/harness/wait"
  }
}

run "setup_talos_version_check" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/${run.random.resource_name}.yaml"
    node              = "node46"
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
run "wait_upgrade" {
  module {
    source = "./tests/harness/wait"
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
    condition     = data.external.talos_info.result["talos_version"] == "v1.9.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}
