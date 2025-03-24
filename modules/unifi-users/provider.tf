provider "unifi" {
  api_url        = var.unifi_address
  api_key        = var.unifi_api_key
  username       = ""
  password       = ""
  allow_insecure = true
  site           = var.unifi_site
}
