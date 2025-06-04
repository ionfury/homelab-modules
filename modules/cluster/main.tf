locals {
  cluster_endpoint         = "${var.cluster_name}.${var.cluster_tld}"
  cluster_endpoint_address = "https://${local.cluster_endpoint}:6443"

  talos_cluster_config = templatefile("${path.module}/resources/templates/talos_cluster.yaml.tftpl", {
    cluster_endpoint       = local.cluster_endpoint_address
    cluster_name           = var.cluster_name
    cluster_pod_subnet     = var.cluster_pod_subnet
    cluster_service_subnet = var.cluster_service_subnet
    cluster_extraManifests = local.prometheus_extraManifests
  })

  machines = [
    for name, machine in var.machines : {
      talos_config = templatefile("${path.module}/resources/templates/talos_machine.yaml.tftpl", {
        cluster_node_subnet = var.cluster_node_subnet
        cluster_vip         = var.cluster_vip

        machine_hostname    = name
        machine_type        = machine.type
        machine_interfaces  = machine.interfaces
        machine_nameservers = var.nameservers
        machine_timeservers = var.timeservers
        machine_install     = machine.install
        machine_labels      = machine.labels
        machine_annotations = machine.annotations
        machine_files       = machine.files
      })
      extensions        = machine.install.extensions
      extra_kernel_args = machine.install.extra_kernel_args
      secureboot        = machine.install.secureboot
      architecture      = machine.install.architecture
      platform          = machine.install.platform
      sbc               = machine.install.sbc
    }
  ]

  bootstrap_charts = [
    {
      repository = "https://helm.cilium.io/"
      chart      = "cilium"
      name       = "cilium"
      version    = var.cilium_version
      namespace  = "kube-system"
      values     = var.cilium_helm_values
    }
  ]

  prometheus_extraManifests = [
    # Prometheus CRDs
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml",
  ]

  cluster_env_vars = {
    cluster_name           = var.cluster_name
    cluster_tld            = var.cluster_tld
    cluster_endpoint       = local.cluster_endpoint
    cluster_vip            = var.cluster_vip
    cluster_node_subnet    = var.cluster_node_subnet
    cluster_pod_subnet     = var.cluster_pod_subnet
    cluster_service_subnet = var.cluster_service_subnet
    cluster_path           = "${var.github.repository_path}/${var.cluster_name}"
    talos_version          = var.talos_version
    cilium_version         = var.cilium_version
    flux_version           = var.flux_version
    prometheus_version     = var.prometheus_version
    kubernetes_version     = var.kubernetes_version
    default_replica_count  = min(3, length(var.machines))
  }

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
  source = "../cluster-unifi-dns"

  cluster_endpoint = local.cluster_endpoint
  machines         = var.machines
  unifi = {
    address = var.unifi.address
    site    = var.unifi.site
    api_key = data.aws_ssm_parameter.params_get[var.unifi.api_key_store].value
  }
}

module "cluster_talos" {
  source = "../cluster-talos"

  talos_version          = var.talos_version
  kubernetes_version     = var.kubernetes_version
  talos_config_path      = var.talos_config_path
  kubernetes_config_path = var.kubernetes_config_path
  talos_cluster_config   = local.talos_cluster_config
  machines               = local.machines
  bootstrap_charts       = local.bootstrap_charts
  on_destroy             = var.cluster_on_destroy
}

module "cluster_bootstrap" {
  source = "../cluster-bootstrap"

  cluster_name     = var.cluster_name
  flux_version     = var.flux_version
  tld              = var.cluster_tld
  cluster_env_vars = local.cluster_env_vars
  kubeconfig = {
    host                   = module.cluster_talos.kubeconfig_host
    client_certificate     = module.cluster_talos.kubeconfig_client_certificate
    client_key             = module.cluster_talos.kubeconfig_client_key
    cluster_ca_certificate = module.cluster_talos.kubeconfig_client_certificate
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
