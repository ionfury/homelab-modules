locals {
  note = "Managed by Terraform."
}

resource "unifi_user" "user" {
  for_each = var.unifi_users

  name     = each.key
  mac      = each.value.mac
  fixed_ip = each.value.ip
  note     = local.note
}
