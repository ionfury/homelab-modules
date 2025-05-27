mock_provider "unifi" {
  alias = "mock"
}

mock_provider "aws" {
  alias = "mock"
}

run "plan" {
  providers = {
    unifi = unifi.mock
    aws   = aws.mock
  }

  variables {
    unifi = {
      address       = "https://10.10.10.10"
      site          = "site"
      api_key_store = "/fake/api-key"
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
}
