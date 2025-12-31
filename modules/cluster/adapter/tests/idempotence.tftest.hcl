run "adapter_outputs_are_not_duplicated" {
  command = plan

  variables {
    name     = "dev"
    features = ["longhorn", "spegel"]

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
        type = "worker"

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
            hardwareAddr     = "aa:bb:cc:dd:ee:20"
            dhcp_routeMetric = 100
            addresses = [
              { ip = "192.168.10.50", cidr = "24" }
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
  # Exactly one Longhorn label
  #
  assert {
    condition = (
      length([
        for l in output.machines["node1"].labels :
        l if l.key == "node.longhorn.io/create-default-disk"
      ]) == 1
    )

    error_message = "Duplicate Longhorn labels detected."
  }

  #
  # Exactly one Longhorn kubelet root mount
  #
  assert {
    condition = (
      length([
        for m in output.machines["node1"].kubelet_extraMounts :
        m if m.destination == "/var/lib/longhorn"
      ]) == 1
    )

    error_message = "Duplicate Longhorn kubelet mounts detected."
  }

  #
  # Exactly one Spegel file
  #
  assert {
    condition = (
      length([
        for f in output.machines["node1"].files :
        f.path == "/etc/cri/conf.d/20-customization.part"
      ]) == 1
    )

    error_message = "Duplicate Spegel files detected."
  }
}
