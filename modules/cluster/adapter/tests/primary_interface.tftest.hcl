run "primary_interface_is_first" {
  command = plan

  variables {
    name     = "dev"
    features = []

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
        }

        interfaces = [
          {
            hardwareAddr = "aa:bb:cc:dd:ee:01"
            addresses    = [{ ip = "10.0.0.11" }]
          },
          {
            hardwareAddr = "aa:bb:cc:dd:ee:ff"
            addresses    = [{ ip = "10.0.0.99" }]
          }
        ]
      }
    }
  }

  assert {
    condition = (
      output.dhcp_reservations["node1"].ip == "10.0.0.11"
    )

    error_message = "Adapter did not treat first interface as primary."
  }
}
