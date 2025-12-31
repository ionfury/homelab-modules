run "combined_features_do_not_conflict" {
  command = plan

  variables {
    name     = "dev"
    features = ["longhorn", "kernel-fast"]

    nameservers = ["1.1.1.1", "8.8.8.8"]
    timeservers = ["time.cloudflare.com"]

    networking = {
      tld            = "internal.dev.example.com"
      vip            = "10.0.0.10"
      node_subnet    = "10.0.0.0/24"
      pod_subnet     = "10.244.0.0/16"
      service_subnet = "10.96.0.0/12"
    }

    machines = {
      node1 = {
        type = "controlplane"

        install = {
          selector = "ssd"
          wipe     = true
          data = {
            enabled = true
          }
        }

        disks = [
          {
            mountpoint = "/var/mnt/disk1"
          }
        ]

        labels      = []
        annotations = []
        files       = []

        interfaces = [
          {
            hardwareAddr     = "aa:bb:cc:dd:ee:10"
            dhcp_routeMetric = 100
            addresses = [
              { ip = "192.168.10.40", cidr = "24" }
            ]
            vlans = []
          }
        ]
      }
    }
  }

  #
  # -------------------------------------------------------------------
  # Assertions
  # -------------------------------------------------------------------
  #

  #
  # Longhorn annotation is present
  #
  assert {
    condition = (
      length([
        for a in output.machines["node1"].annotations :
        a if a.key == "node.longhorn.io/default-disks-config"
      ]) == 1
    )

    error_message = "Longhorn annotation missing when both features enabled."
  }

  #
  # Kernel-fast args are present
  #
  assert {
    condition = (
      length(output.machines["node1"].install.extra_kernel_args) > 0
    )

    error_message = "kernel-fast did not inject kernel args when combined with longhorn."
  }

  #
  # Both behaviors coexist (no overwrite)
  #
  assert {
    condition = (
      contains(
        output.machines["node1"].install.extensions,
        "iscsi-tools"
      )
    )

    error_message = "Longhorn extensions missing when combined with kernel-fast."
  }
}
