locals {
  account_id = data.cloudflare_accounts.this.result[0].id
  zone_id    = var.cloudflare.zone_id #lookup(data.cloudflare_zones.domain.zones[0], "id")
}
data "cloudflare_accounts" "this" {
  name = var.cloudflare.account
}
/* 
Blocks of type "filter" are not expected here?
https://search.opentofu.org/provider/cloudflare/cloudflare/latest/docs/datasources/zone
data "cloudflare_zones" "this" {
  filter {
    name = var.tld
  }
}
*/
resource "random_password" "this" {
  length  = 64
  special = false
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id    = local.account_id
  name          = var.cluster_name
  tunnel_secret = base64encode(random_password.this.result)
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "this" {
  account_id = local.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

resource "cloudflare_dns_record" "ingress" {
  zone_id = local.zone_id
  name    = "${var.cluster_name}.${var.tld}"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.this.id}.cfargotunnel.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "kubernetes_secret" "cloudflare_tunnel_secret" {
  metadata {
    name        = "cloudflare-tunnel-secret"
    namespace   = "kube-system"
    annotations = var.cloudflare_tunnel_secret_annotations
  }

  data = {
    AccountTag   = cloudflare_zero_trust_tunnel_cloudflared.this.account_id
    TunnelSecret = cloudflare_zero_trust_tunnel_cloudflared.this.tunnel_secret
    TunnelID     = cloudflare_zero_trust_tunnel_cloudflared.this.id
  }
}
