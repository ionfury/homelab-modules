run "kernel_fast_injects_kernel_args" {
  command = plan

  variables {
    name     = "dev"
    features = ["kernel-fast"]

    networking = {
      tld            = "internal.dev.example.com"
      vip            = "10.0.0.10"
      node_subnet    = "10.0.0.0/24"
      pod_subnet     = "10.244.0.0/16"
      service_subnet = "10.96.0.0/12"
    }

    machines = {
      node1 = {
        type = "worker"

        install = {
          selector = "ssd"
          wipe     = true
        }

        disks       = []
        labels      = []
        annotations = []
        files       = []

        interfaces = [
          {
            hardwareAddr     = "aa:bb:cc:dd:ee:01"
            dhcp_routeMetric = 100
            addresses = [
              { ip = "192.168.10.20", cidr = "24" }
            ]
            vlans = []
          }
        ]
      }
    }
  }

  assert {
    condition = (
      length(
        output.machines["node1"].install.extra_kernel_args
      ) > 0
    )

    error_message = "Expected kernel-fast to inject kernel arguments."
  }

  assert {
    condition = alltrue([
      for arg in [
        "apparmor=0",
        "mitigations=off",
        "security=none",
      ] :
      contains(
        output.machines["node1"].install.extra_kernel_args,
        arg
      )
    ])

    error_message = "Expected kernel-fast kernel arguments were missing."
  }
}
