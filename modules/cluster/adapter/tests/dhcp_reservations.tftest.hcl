run "dhcp_reservations_for_all_machines" {
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
            addresses = [
              { ip = "10.0.0.11" }
            ]
          }
        ]
      }

      node2 = {
        type = "worker"

        install = {
          selector = "ssd"
        }

        interfaces = [
          {
            hardwareAddr = "aa:bb:cc:dd:ee:02"
            addresses = [
              { ip = "10.0.0.12" }
            ]
          }
        ]
      }
    }
  }

  assert {
    condition = (
      length(output.dhcp_reservations) == 2
    )

    error_message = "Expected DHCP reservations for all machines."
  }

  assert {
    condition = (
      output.dhcp_reservations["node1"].mac == "aa:bb:cc:dd:ee:01" &&
      output.dhcp_reservations["node1"].ip == "10.0.0.11"
    )

    error_message = "Incorrect DHCP reservation for node1."
  }

  assert {
    condition = (
      output.dhcp_reservations["node2"].mac == "aa:bb:cc:dd:ee:02" &&
      output.dhcp_reservations["node2"].ip == "10.0.0.12"
    )

    error_message = "Incorrect DHCP reservation for node2."
  }
}
