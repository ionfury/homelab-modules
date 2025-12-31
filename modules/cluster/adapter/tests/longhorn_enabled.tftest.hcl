run "longhorn_disk_annotation_is_generated" {
  command = plan

  variables {
    name     = "dev"
    features = ["longhorn"]

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

        disks = [
          {
            mountpoint = "/var/mnt/disk1"
            tags       = ["fast"]
          },
          {
            mountpoint = "/var/mnt/disk2"
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
              { ip = "192.168.10.10", cidr = "24" }
            ]
            vlans = []
          }
        ]
      }
    }
  }

  assert {
    condition = contains(
      [
        for a in output.machines["node1"].annotations :
        a.key
      ],
      "node.longhorn.io/default-disks-config"
    )

    error_message = "Expected Longhorn disk annotation to be present."
  }

  assert {
    condition = (
      length(
        jsondecode(
          trim(
            output.machines["node1"].annotations[0].value,
            "'"
          )
        )
      ) == 3
    )

    error_message = "Expected 3 Longhorn disks (root + 2 data disks)."
  }

  assert {
    condition = (
      [
        for d in jsondecode(
          trim(
            output.machines["node1"].annotations[0].value,
            "'"
          )
        ) : d.path
        ] == [
        "/var/lib/longhorn",
        "/var/mnt/disk1",
        "/var/mnt/disk2",
      ]
    )

    error_message = "Unexpected Longhorn disk paths."
  }

  assert {
    condition = (
      [
        for d in jsondecode(
          trim(
            output.machines["node1"].annotations[0].value,
            "'"
          )
        ) : d.tags
        ] == [
        ["root"],
        ["fast"],
        [],
      ]
    )

    error_message = "Disk tags were not propagated correctly."
  }
}
