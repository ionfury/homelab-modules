output "tunnel_id" {
  value = cloudflare_tunnel.this.id
}

output "tunnel_token" {
  value     = cloudflare_tunnel.this.tunnel_token
  sensitive = true
}

output "tunnel_secret" {
  value     = cloudflare_tunnel.this.secret
  sensitive = true
}

output "tunnel_account_id" {
  value = cloudflare_tunnel.this.account_id
}

output "tunnel_info_json" {
  sensitive = true
  value = jsonencode(
    {
      id         = cloudflare_tunnel.this.id
      token      = cloudflare_tunnel.this.tunnel_token
      secret     = cloudflare_tunnel.this.secret
      account_id = cloudflare_tunnel.this.account_id
    }
  )
}
