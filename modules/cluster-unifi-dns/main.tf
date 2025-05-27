locals {
  unifi_dns_records = tomap({
    for machine, details in var.machines :
    machine => {
      name   = var.cluster_endpoint
      record = split("/", details.interfaces[0].addresses[0])[0]
    }
    if details.type == "controlplane"
  })

  unifi_users = tomap({
    for machine, details in var.machines : machine => {
      mac = details.interfaces[0].hardwareAddr
      ip  = split("/", details.interfaces[0].addresses[0])[0]
    }
  })

  params_get = toset([
    var.unifi.api_key_store,
  ])
}

data "aws_ssm_parameter" "params_get" {
  for_each = local.params_get
  name     = each.value
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
