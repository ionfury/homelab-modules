variables {
  unifi_address  = "plan"
  unifi_site     = "plan"
  unifi_username = "plan"
  unifi_password = "plan"

  unifi_dns_records = {
    a = {
      name  = "a.example.com"
      value = "192.168.1.1"
    }
    b = {
      name  = "b.example.com"
      value = "192.168.1.2"
    }
  }
}

run "test" {
  command = plan

  assert {
    condition     = unifi_dns_record.record["a"].value == "192.168.1.1"
    error_message = "DNS record value does not match expected value."
  }
  assert {
    condition     = unifi_dns_record.record["b"].value == "192.168.1.2"
    error_message = "DNS record value does not match expected value."
  }
}

