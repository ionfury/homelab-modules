data "cloudflare_zone" "this" {
  name = var.tld
}

data "cloudflare_accounts" "this" {
  name = var.cloudflare_account_name
}

resource "random_password" "this" {
  length  = 64
  special = false
}

resource "cloudflare_tunnel" "this" {
  account_id = data.cloudflare_accounts.this.accounts[0].id
  name       = var.cluster_name
  secret     = base64encode(random_password.this.result)
}

resource "cloudflare_record" "this" {
  name    = "${var.cluster_name}.${var.tld}"
  zone_id = data.cloudflare_zone.this.id
  value   = cloudflare_tunnel.this.cname
  proxied = true
  type    = "CNAME"
  ttl     = 1
}

resource "kubernetes_secret" "cloudflare_tunnel_secret" {
  metadata {
    name        = "cloudflare-tunnel-secret"
    namespace   = "kube-system"
    annotations = var.cloudflare_tunnel_secret_annotations
  }

  data = {
    AccountTag   = cloudflare_tunnel.this.account_id
    TunnelSecret = cloudflare_tunnel.this.secret
    TunnelID     = cloudflare_tunnel.this.id
  }
}
