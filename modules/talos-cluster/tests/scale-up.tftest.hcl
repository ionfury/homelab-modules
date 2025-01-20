run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  cluster_name                           = run.random.resource_name
  cluster_endpoint                       = "192.168.10.218"
  cluster_allowSchedulingOnControlPlanes = true

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

run "scale_up" {
  variables {
    talos_version = "v1.9.0"
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
        type           = "worker"
        first_scale_in = true
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
    }
  }
}

# Scale in has no health check, so we need to wait before we can destroy the machines.
run "wait" {
  module {
    source = "./tests/harness/wait"
  }

  variables {
    timeout = "3m"
  }
}
