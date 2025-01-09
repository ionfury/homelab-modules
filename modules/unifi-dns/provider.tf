provider "unifi" {
  api_url        = var.unifi_address
  username       = var.unifi_username
  password       = var.unifi_password
  allow_insecure = true
  site           = var.unifi_site
}
