locals {
  cluster_endpoint_address = "https://${var.cluster_endpoint}:6443"
  unifi_dns_records = tomap({
    for machine, details in var.machines :
    machine => {
      name   = var.cluster_endpoint
      record = split("/", details.interfaces[0].addresses[0])[0]
    }
    if details.type == "controlplane"
  })

  unifi_users = tomap({
    for machine, details in var.machines : machine => {
      mac = details.interfaces[0].hardwareAddr
      ip  = split("/", details.interfaces[0].addresses[0])[0]
    }
  })

  generated_cluster_env_vars = {
    cluster_name           = var.cluster_name
    cluster_endpoint       = local.cluster_endpoint_address
    cluster_vip            = var.cluster_vip
    cluster_node_subnet    = var.cluster_node_subnet
    cluster_pod_subnet     = var.cluster_pod_subnet
    cluster_service_subnet = var.cluster_service_subnet
    cluster_path           = "${var.github.repository_path}/${var.cluster_name}"
    talos_version          = var.talos_version
    cilium_version         = var.cilium_version
    flux_version           = var.flux_version
    prometheus_version     = var.prometheus_version
    default_replica_count  = min(3, length(var.machines))
  }

  cluster_env_vars = merge(var.cluster_env_vars, local.generated_cluster_env_vars)

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
    #  rpc error: code = ResourceExhausted desc = grpc: received message larger than max (5039431 vs. 4194304)
    /*{
      repository = "https://prometheus-community.github.io/helm-charts"
      chart      = "prometheus-operator-crds"
      name       = "prometheus-crds"
      version    = var.prometheus_version
      namespace  = "kube-system"
      values     = ""
    },*/
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
}

module "params_get" {
  source = "../params-get"

  aws = var.aws
  parameters = [
    var.unifi.api_key_store,
    var.github.token_store,
    var.external_secrets.id_store,
    var.external_secrets.secret_store,
    var.cloudflare.api_key_store,
    var.healthchecksio.api_key_store
  ]
}

module "unifi_dns" {
  source = "../unifi-dns"

  unifi_address     = var.unifi.address
  unifi_site        = var.unifi.site
  unifi_api_key     = module.params_get.values[var.unifi.api_key_store]
  unifi_dns_records = local.unifi_dns_records
}

module "unifi_users" {
  source = "../unifi-users"

  unifi_address = var.unifi.address
  unifi_site    = var.unifi.site
  unifi_api_key = module.params_get.values[var.unifi.api_key_store]
  unifi_users   = local.unifi_users
}


module "talos_cluster" {
  depends_on = [module.unifi_dns]
  source     = "../talos-cluster"

  talos_version          = var.talos_version
  kubernetes_version     = var.kubernetes_version
  talos_config_path      = var.talos_config_path
  kubernetes_config_path = var.kubernetes_config_path
  talos_cluster_config   = local.talos_cluster_config
  machines               = local.machines
  bootstrap_charts       = local.bootstrap_charts
}

module "bootstrap" {
  source = "../bootstrap"

  cluster_name     = var.cluster_name
  flux_version     = var.flux_version
  tld              = var.tld
  cluster_env_vars = local.cluster_env_vars

  kubernetes_config_host                   = module.talos_cluster.kubeconfig_host
  kubernetes_config_client_certificate     = module.talos_cluster.kubeconfig_client_certificate
  kubernetes_config_client_key             = module.talos_cluster.kubeconfig_client_key
  kubernetes_config_cluster_ca_certificate = module.talos_cluster.kubeconfig_cluster_ca_certificate

  github_org             = var.github.org
  github_repository      = var.github.repository
  github_repository_path = var.github.repository_path
  github_token           = module.params_get.values[var.github.token_store]

  external_secrets_access_key_id     = module.params_get.values[var.external_secrets.id_store]
  external_secrets_access_key_secret = module.params_get.values[var.external_secrets.secret_store]

  cloudflare_account_name = var.cloudflare.account
  cloudflare_email        = var.cloudflare.email
  cloudflare_api_key      = module.params_get.values[var.cloudflare.api_key_store]

  healthchecksio_api_key = module.params_get.values[var.healthchecksio.api_key_store]
}

module "params_put" {
  source = "../params-put"

  aws = var.aws
  parameters = {
    kubeconfig = {
      name        = "/homelab/infrastructure/clusters/${var.cluster_name}/kubeconfig"
      description = "Kubeconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.talos_cluster.kubeconfig_raw
    }
    talosconfig = {
      name        = "/homelab/infrastructure/clusters/${var.cluster_name}/talosconfig"
      description = "Talosconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.talos_cluster.talosconfig_raw
    }
  }
}
