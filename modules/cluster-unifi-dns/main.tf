locals {
  unifi_dns_records = tomap({
    for machine, details in var.machines :
    machine => {
      name   = var.cluster_endpoint
      record = details.interfaces[0].addresses[0].ip
    }
    if details.type == "controlplane"
  })

  unifi_users = tomap({
    for machine, details in var.machines : machine => {
      mac = details.interfaces[0].hardwareAddr
      ip  = details.interfaces[0].addresses[0].ip
    }
  })
}

resource "unifi_dns_record" "record" {
  for_each = local.unifi_dns_records

  name    = coalesce(each.value.name, each.key)
  record  = each.value.record
  enabled = true
  type    = "A"
  ttl     = 0
}

resource "unifi_user" "user" {
  for_each = local.unifi_users

  name     = each.key
  mac      = each.value.mac
  fixed_ip = each.value.ip
  note     = "Managed by Terraform."
}
