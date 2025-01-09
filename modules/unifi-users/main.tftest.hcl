variables {
  unifi_address = "https://192.168.1.1"
  unifi_site    = "default"
  # unifi_username = "" # Set via UNIFI_USERNAME env in .taskfiles/tofu/resources/test/.env
  # unifi_password = "" # Set via UNIFI_PASSWORD env in .taskfiles/tofu/resources/test/.env

  unifi_users = {
    a = {
      ip  = "192.168.169.42"
      mac = "00:1a:2b:3c:4d:5e"
    }
  }
}

/*
Need a real IP & MAC to test.  Not worth testing, just would validate the provider (which probably might break in the future...)

main.tftest.hcl... fail
  run "test"... fail
╷
│ Error: api.err.InvalidFixedIP (400 ) for POST https://192.168.1.1/proxy/network/api/s/default/group/user
│ 
│   with unifi_user.user["a"],
│   on main.tf line 5, in resource "unifi_user" "user":
│    5: resource "unifi_user" "user" {
│ 
╵

Failure! 0 passed, 1 failed.

run "test" {
  assert {
    condition     = unifi_user.user["a"].ip == "192.168.169.42"
    error_message = "User IP does not match expected IP."
  }
}
*/
