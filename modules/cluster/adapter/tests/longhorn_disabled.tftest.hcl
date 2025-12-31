run "longhorn_annotation_is_not_generated_when_feature_disabled" {
  command = plan

  variables {
    name     = "dev"
    features = [] # <-- longhorn NOT enabled

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
            tags    = ["root"]
          }
        }

        # Disks are present, but feature is disabled
        disks = [
          {
            mountpoint = "/var/mnt/disk1"
            tags       = ["fast"]
          }
        ]

        labels      = []
        annotations = []
        files       = []

        interfaces = [
          {
            hardwareAddr     = "aa:bb:cc:dd:ee:ff"
            dhcp_routeMetric = 100
            addresses = [
              { ip = "192.168.10.11", cidr = "24" }
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
        [
          for a in output.machines["node1"].annotations :
          a if a.key == "node.longhorn.io/default-disks-config"
        ]
      ) == 0
    )

    error_message = "Longhorn disk annotation was generated even though feature was disabled."
  }

  assert {
    condition = (
      length(
        [
          for l in output.machines["node1"].labels :
          l if l.key == "node.longhorn.io/create-default-disk"
        ]
      ) == 0
    )

    error_message = "Longhorn label was generated even though feature was disabled."
  }

  assert {
    condition = (
      length(
        [
          for m in output.machines["node1"].kubelet_extraMounts :
          m if m.destination == "/var/lib/longhorn"
        ]
      ) == 0
    )

    error_message = "Longhorn kubelet mount was generated even though feature was disabled."
  }
}
