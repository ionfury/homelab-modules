module "adapter" {
  source = "./adapter"

  name                      = var.name
  features                  = var.features
  networking                = var.networking
  machines                  = var.machines
  etcd_extraArgs            = var.etcd_extraArgs
  controllerManager_extraArgs = var.controllerManager_extraArgs
  scheduler_extraArgs       = var.scheduler_extraArgs
  env_vars                  = var.env_vars
  versions = {
    prometheus  = var.versions.prometheus
    gateway_api = var.versions.gateway_api
  }
}

module "runtime" {
  source = "./runtime"

  cluster_name     = var.name
  cluster_tld      = var.networking.tld
  cluster_endpoint = module.adapter.cluster_endpoint

  dns_records       = module.adapter.dns_records
  dhcp_reservations = module.adapter.dhcp_reservations
  machines          = module.adapter.runtime_machines
  talos_cluster_config = module.adapter.talos_cluster_config
  bootstrap_charts     = module.adapter.bootstrap_charts
  cluster_env_vars     = module.adapter.cluster_env_vars

  versions               = var.versions
  nameservers            = var.nameservers
  timeservers            = var.timeservers
  talos_config_path      = var.talos_config_path
  kubernetes_config_path = var.kubernetes_config_path
  on_destroy             = var.on_destroy
  ssm_output_path        = var.ssm_output_path

  unifi            = var.unifi
  github           = var.github
  cloudflare       = var.cloudflare
  external_secrets = var.external_secrets
  healthchecksio   = var.healthchecksio
}
