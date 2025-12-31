run "dns_records_only_for_controlplane" {
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
      cp1 = {
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

      worker1 = {
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
      length(output.dns_records) == 1
    )

    error_message = "Expected exactly one DNS record for control plane nodes."
  }

  assert {
    condition = (
      output.dns_records["cp1"].record == "10.0.0.11"
    )

    error_message = "Control plane DNS record IP incorrect."
  }

  assert {
    condition = (
      output.dns_records["cp1"].name == "k8s.internal.dev.example.com"
    )

    error_message = "Control plane DNS record name incorrect."
  }
}
