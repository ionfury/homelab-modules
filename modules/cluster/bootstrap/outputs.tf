output "tunnel_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.this.id
}

output "tunnel_token" {
  value     = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
  sensitive = true
}

output "tunnel_secret" {
  value     = cloudflare_zero_trust_tunnel_cloudflared.this.tunnel_secret
  sensitive = true
}

output "tunnel_account_id" {
  value = cloudflare_zero_trust_tunnel_cloudflared.this.account_id
}

output "tunnel_info_json" {
  sensitive = true
  value = jsonencode(
    {
      id         = cloudflare_zero_trust_tunnel_cloudflared.this.id
      token      = data.cloudflare_zero_trust_tunnel_cloudflared_token.this.token
      secret     = cloudflare_zero_trust_tunnel_cloudflared.this.tunnel_secret
      account_id = cloudflare_zero_trust_tunnel_cloudflared.this.account_id
    }
  )
}

