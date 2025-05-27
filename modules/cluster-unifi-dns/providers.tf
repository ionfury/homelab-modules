provider "aws" {}
#  region = var.aws.region
#}

provider "unifi" {
  api_url        = var.unifi.address
  api_key        = data.aws_ssm_parameter.params_get[var.unifi.api_key_store].value
  username       = ""
  password       = ""
  allow_insecure = true
  site           = var.unifi.site
}
