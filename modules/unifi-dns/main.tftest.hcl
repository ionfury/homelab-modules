variables {
  unifi_address = "https://192.168.1.1"
  unifi_site    = "default"
  # unifi_username = "" # Set via UNIFI_USERNAME env in .taskfiles/tofu/resources/test/.env
  # unifi_password = "" # Set via UNIFI_PASSWORD env in .taskfiles/tofu/resources/test/.env

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
/*
Error in provider on destroy:

OpenTofu encountered an error destroying resources created while executing main.tftest.hcl/test.
╷
│ Error: invalid character '<' looking for beginning of value
│ 
│   with unifi_dns_record.record["b"],
│   on main.tf line 1, in resource "unifi_dns_record" "record":
│    1: resource "unifi_dns_record" "record" {
│ 
╵
╷
│ Error: invalid character '<' looking for beginning of value
│ 
│   with unifi_dns_record.record["a"],
│   on main.tf line 1, in resource "unifi_dns_record" "record":
│    1: resource "unifi_dns_record" "record" {
│ 
╵

OpenTofu left the following resources in state after executing main.tftest.hcl/test, these left-over resources can be viewed by reading the statefile written to disk(errored_test.tfstate) and they need to be cleaned up manually:
  - unifi_dns_record.record["a"]
  - unifi_dns_record.record["b"]

Writing state to file: errored_test.tfstate

run "test" {
  assert {
    condition     = unifi_dns_record.record["a"].value == "192.168.1.1"
    error_message = "DNS record value does not match expected value."
  }
  assert {
    condition     = unifi_dns_record.record["b"].value == "192.168.1.2"
    error_message = "DNS record value does not match expected value."
  }
}
*/
