resource "unifi_dns_record" "record" {
  for_each = var.unifi_dns_records

  name        = coalesce(each.value.name, each.key)
  value       = each.value.value
  enabled     = each.value.enabled
  port        = each.value.port
  priority    = each.value.priority
  record_type = each.value.record_type
  ttl         = each.value.ttl
}
