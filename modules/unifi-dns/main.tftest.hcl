variables {
  unifi_address = "https://192.168.1.1"
  unifi_api_key = "plan"

  unifi_dns_records = {
    a = {
      name   = "a.example.com"
      record = "192.168.1.1"
    }
    b = {
      name   = "b.example.com"
      record = "192.168.1.2"
    }
  }
}

mock_provider "unifi" {
  alias = "mock"
}

run "mock" {
  providers = {
    unifi = unifi.mock
  }

  assert {
    condition     = unifi_dns_record.record["a"].record == "192.168.1.1"
    error_message = "DNS record value does not match expected value."
  }
  assert {
    condition     = unifi_dns_record.record["b"].record == "192.168.1.2"
    error_message = "DNS record value does not match expected value."
  }
}

