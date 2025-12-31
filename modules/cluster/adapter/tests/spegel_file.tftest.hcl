run "spegel_injects_containerd_config_file" {
  command = plan

  variables {
    name     = "dev"
    features = ["spegel"]

    nameservers = ["1.1.1.1", "8.8.8.8"]
    timeservers = ["time.cloudflare.com"]

    networking = {
      tld            = ""
      vip            = ""
      node_subnet    = ""
      pod_subnet     = ""
      service_subnet = ""
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

        files = [
          {
            path        = "/etc/example.conf"
            op          = "create"
            permissions = "0o644"
            content     = "example=true"
          }
        ]

        interfaces = [
          {
            hardwareAddr     = "aa:bb:cc:dd:ee:02"
            dhcp_routeMetric = 100
            addresses = [
              { ip = "192.168.10.30", cidr = "24" }
            ]
            vlans = []
          }
        ]
      }
    }
  }

  assert {
    condition = (
      length([
        for f in output.machines["node1"].files :
        f if f.path == "/etc/cri/conf.d/20-customization.part"
      ]) == 1
    )

    error_message = "Expected Spegel containerd customization file to be injected."
  }

  assert {
    condition = (
      length([
        for f in output.machines["node1"].files :
        f if f.path == "/etc/example.conf"
      ]) == 1
    )

    error_message = "Existing machine files were unexpectedly modified."
  }

  assert {
    condition = (
      strcontains(
        [
          for f in output.machines["node1"].files :
          f.content if f.path == "/etc/cri/conf.d/20-customization.part"
        ][0],
        "discard_unpacked_layers"
      )
    )

    error_message = "Spegel file content did not include expected containerd configuration."
  }

  assert {
    condition = (
      [
        for f in output.machines["node1"].files :
        f.permissions if f.path == "/etc/cri/conf.d/20-customization.part"
      ][0] == "0o666"
    )

    error_message = "Spegel file permissions were not set correctly."
  }
}
