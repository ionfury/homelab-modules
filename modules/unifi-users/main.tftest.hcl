variables {
  unifi_address  = "plan"
  unifi_site     = "plan"
  unifi_username = "plan"
  unifi_password = "plan"

  unifi_users = {
    a = {
      ip  = "192.168.169.42"
      mac = "00:1a:2b:3c:4d:5e"
    }
  }
}

run "test" {
  command = plan

  assert {
    condition     = unifi_user.user["a"].ip == "192.168.169.42"
    error_message = "User IP does not match expected IP."
  }
}
