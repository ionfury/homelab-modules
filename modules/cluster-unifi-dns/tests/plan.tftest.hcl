mock_provider "unifi" {
  alias = "mock"
}

run "plan" {
  command = plan
  providers = {
    unifi = unifi.mock
  }

  variables {
    unifi = {
      address = "https://10.10.10.10"
      site    = "site"
      api_key = "/fake/api-key"
    }

    cluster_endpoint = "endpoint.example.com"
    machines = {
      a = {
        type = "controlplane"
        interfaces = [{
          hardwareAddr = "aa:aa:aa:aa:aa:aa"
          addresses    = ["1.1.1.1/16"]
        }]
      }
      b = {
        type = "controlplane"
        interfaces = [{
          hardwareAddr = "bb:bb:bb:bb:bb:bb"
          addresses    = ["2.2.2.2/16"]
        }]
      }
      c = {
        type = "worker"
        interfaces = [{
          hardwareAddr = "cc:cc:cc:cc:cc:cc"
          addresses    = ["3.3.3.3/16"]
        }]
      }
    }
  }

  assert {
    condition     = unifi_dns_record.record["a"].record == "1.1.1.1"
    error_message = "DNS Record at 'a' not as expected'."
  }

  assert {
    condition     = unifi_dns_record.record["a"].name == "endpoint.example.com"
    error_message = "DNS Record at 'a' not as expected'."
  }

  assert {
    condition     = length(unifi_dns_record.record) == 2
    error_message = "DNS Record length not as expected!"
  }

  assert {
    condition     = length(unifi_user.user) == 3
    error_message = "User length is not as expected!"
  }

  assert {
    condition     = unifi_user.user["a"].name == "a" && unifi_user.user["a"].mac == "aa:aa:aa:aa:aa:aa" && unifi_user.user["a"].fixed_ip == "1.1.1.1"
    error_message = "Unifi user[a] is not as expected!"
  }
}
