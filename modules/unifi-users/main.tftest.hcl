variables {
  unifi_address = "https://192.168.1.1"
  unifi_api_key = "plan"

  unifi_users = {
    a = {
      ip  = "192.168.169.42"
      mac = "00:1a:2b:3c:4d:5e"
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
    condition     = unifi_user.user["a"].fixed_ip == "192.168.169.42"
    error_message = "User IP does not match expected IP."
  }

  assert {
    condition     = unifi_user.user["a"].mac == "00:1a:2b:3c:4d:5e"
    error_message = "User MAC does not match expected MAC."
  }

  assert {
    condition     = unifi_user.user["a"].note == "Managed by Terraform."
    error_message = "User note does not match expected note."
  }

  assert {
    condition     = unifi_user.user["a"].allow_existing == true
    error_message = "User allow_existing does not match expected allow_existing."
  }

  assert {
    condition     = unifi_user.user["a"].blocked == null
    error_message = "User blocked does not match expected blocked."
  }

  assert {
    condition     = unifi_user.user["a"].local_dns_record == null
    error_message = "User local_dns_record does not match expected local_dns_record."
  }

  assert {
    condition     = unifi_user.user["a"].network_id == null
    error_message = "User network_id does not match expected network_id."
  }

  assert {
    condition     = unifi_user.user["a"].skip_forget_on_destroy == false
    error_message = "User skip_forget_on_destroy does not match expected skip_forget_on_destroy."
  }
}
