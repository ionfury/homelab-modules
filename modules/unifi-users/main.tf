locals {
  note = "Managed by Terraform."
}

resource "unifi_user" "user" {
  for_each = var.unifi_users

  name     = each.key
  mac      = each.value.mac
  fixed_ip = each.value.ip

  allow_existing         = each.value.allow_existing
  blocked                = each.value.blocked
  local_dns_record       = each.value.local_dns_record
  network_id             = each.value.network_id
  skip_forget_on_destroy = each.value.skip_forget_on_destroy

  note = local.note
}
