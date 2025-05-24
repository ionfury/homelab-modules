locals {
  params_get = toset([
    var.github.token_store,
    var.external_secrets.id_store,
    var.external_secrets.secret_store,
    var.cloudflare.api_token_store,
    var.healthchecksio.api_key_store
  ])
}

data "aws_ssm_parameter" "params_get" {
  for_each = local.params_get
  name     = each.value
}
