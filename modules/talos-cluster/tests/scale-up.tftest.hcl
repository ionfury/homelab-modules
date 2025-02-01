run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name     = run.random.resource_name
  cluster_endpoint = "192.168.10.218"

  talos_config_path = "~/.talos/testing"
  kube_config_path  = "~/.kube/testing"

  machines = {
    node44 = {
      type    = "controlplane"
      install = { diskSelectors = ["type: 'ssd'"] }
      interfaces = [{
        hardwareAddr = "ac:1f:6b:2d:ba:1e"
        addresses    = ["192.168.10.218"]
      }]
    }
  }
}

run "setup" {}

run "scale_up" {
  variables {
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
        type = "worker"

        install = { diskSelectors = ["type: 'ssd'"] }
        interfaces = [{
          hardwareAddr = "ac:1f:6b:2d:bf:ce"
          addresses    = ["192.168.10.222"]
        }]
      }
    }
  }
}
