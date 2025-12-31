locals {
  params_get = toset([
    var.unifi.api_key_store,
    var.github.token_store,
    var.cloudflare.api_token_store,
    var.external_secrets.id_store,
    var.external_secrets.secret_store,
    var.healthchecksio.api_key_store
  ])

  params_put = {
    kubeconfig = {
      name        = "${var.ssm_output_path}/${var.cluster_name}/kubeconfig"
      description = "Kubeconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.cluster_talos.kubeconfig_raw
    }
    talosconfig = {
      name        = "${var.ssm_output_path}/${var.cluster_name}/talosconfig"
      description = "Talosconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.cluster_talos.talosconfig_raw
    }
  }
}

data "aws_ssm_parameter" "params_get" {
  for_each = local.params_get
  name     = each.value
}

module "cluster_unifi_dns" {
  source = "../networking"

  cluster_endpoint   = var.cluster_endpoint
  dns_records       = var.dns_records
  dhcp_reservations = var.dhcp_reservations

  unifi = {
    address = var.unifi.address
    site    = var.unifi.site
    api_key = data.aws_ssm_parameter.params_get[var.unifi.api_key_store].value
  }
}


module "cluster_talos" {
  source = "../talos"

  talos_version          = var.versions.talos
  kubernetes_version     = var.versions.kubernetes
  talos_config_path      = var.talos_config_path
  kubernetes_config_path = var.kubernetes_config_path

  talos_cluster_config = var.talos_cluster_config
  machines             = [for k, v in var.machines : v]
  bootstrap_charts     = var.bootstrap_charts
  on_destroy           = var.on_destroy
}

module "cluster_bootstrap" {
  source = "../bootstrap"

  cluster_name     = var.cluster_name
  flux_version     = var.versions.flux
  tld              = var.cluster_tld
  cluster_env_vars = var.cluster_env_vars

  kubeconfig = {
    host                   = module.cluster_talos.kubeconfig_host
    client_certificate     = module.cluster_talos.kubeconfig_client_certificate
    client_key             = module.cluster_talos.kubeconfig_client_key
    cluster_ca_certificate = module.cluster_talos.kubeconfig_cluster_ca_certificate
  }

  github = {
    org             = var.github.org
    repository      = var.github.repository
    repository_path = var.github.repository_path
    token           = data.aws_ssm_parameter.params_get[var.github.token_store].value
  }

  cloudflare = {
    account   = var.cloudflare.account
    email     = var.cloudflare.email
    api_token = data.aws_ssm_parameter.params_get[var.cloudflare.api_token_store].value
    zone_id   = var.cloudflare.zone_id
  }

  external_secrets = {
    id     = data.aws_ssm_parameter.params_get[var.external_secrets.id_store].value
    secret = data.aws_ssm_parameter.params_get[var.external_secrets.secret_store].value
  }

  healthchecksio = {
    api_key = data.aws_ssm_parameter.params_get[var.healthchecksio.api_key_store].value
  }
}

resource "aws_ssm_parameter" "params_put" {
  for_each = local.params_put

  name        = each.value.name
  description = each.value.description
  type        = each.value.type
  value       = each.value.value

  tags = {
    managed-by = "terraform"
  }
}
