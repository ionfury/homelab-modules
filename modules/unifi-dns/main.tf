resource "unifi_dns_record" "record" {
  for_each = var.unifi_dns_records

  name     = coalesce(each.value.name, each.key)
  record   = each.value.record
  enabled  = each.value.enabled
  port     = each.value.port
  priority = each.value.priority
  type     = each.value.type
  ttl      = each.value.ttl
  weight   = each.value.weight
}

