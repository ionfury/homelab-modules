locals {
  # tflint-ignore: terraform_unused_declarations
  unifi_dns_records = tomap({
    for machine, details in var.machines : machine => {
      name  = var.cluster_endpoint
      value = details.interfaces[0].addresses[0]
    }
  })

  # tflint-ignore: terraform_unused_declarations
  unifi_users = tomap({
    for machine, details in var.machines : machine => {
      mac = details.interfaces[0].hardwareAddr
      ip  = details.interfaces[0].addresses[0]
    }
  })

  generated_cluster_env_vars = {
    cluster_name           = var.cluster_name
    cluster_endpoint       = var.cluster_endpoint
    cluster_vip            = var.cluster_vip
    cluster_node_subnet    = var.cluster_node_subnet
    cluster_pod_subnet     = var.cluster_pod_subnet
    cluster_service_subnet = var.cluster_service_subnet
    cluster_path           = "${var.github.repository_path}/${var.cluster_name}"
    talos_version          = var.talos_version
    cilium_version         = var.cilium_version
    flux_version           = var.flux_version
    prometheus_version     = var.prometheus_version
  }

  cluster_env_vars = merge(var.cluster_env_vars, local.generated_cluster_env_vars)

  cluster_extraManifests = [
    # Prometheus CRDs
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml",
    "https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-${var.prometheus_version}/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml",
  ]
  cluster_inlineManifests = []
  cluster_etcd_extraArgs = var.prepare_kube_prometheus_metrics ? [{
    name  = "listen-metrics-urls"
    value = "http://0.0.0.0:2381"
  }] : []
  cluster_scheduler_extraArgs = var.prepare_kube_prometheus_metrics ? [{
    name  = "bind-address"
    value = "0.0.0.0"
  }] : []
  cluster_controllerManager_extraArgs = var.prepare_kube_prometheus_metrics ? [{
    name  = "bind-address"
    value = "0.0.0.0"
  }] : []

  longhorn_machine_kubelet_extraMount = var.prepare_longhorn ? [{
    destination = "/var/lib/longhorn"
    type        = "bind"
    source      = "/var/lib/longhorn"
    options = [
      "bind",
      "rshared",
      "rw",
    ]
  }] : []
  longhorn_disk2_machine_kubelet_extraMount = var.longhorn_mount_disk2 ? [{
    destination = "/var/mnt/disk2"
    type        = "bind"
    source      = "/var/mnt/disk2"
    options = [
      "bind",
      "rshared",
      "rw",
    ]
  }] : []

  machine_files = var.prepare_spegel ? [{
    path        = "/etc/cri/conf.d/20-customization.part"
    op          = "create"
    permissions = "0o666"
    content     = <<-EOT
        [plugins."io.containerd.cri.v1.images"]
          discard_unpacked_layers = false
      EOT
  }] : []
  machine_extensions = var.prepare_longhorn ? [
    "iscsi-tools",
    "util-linux-tools"
  ] : []
  machine_extra_kernel_args = var.speedy_kernel_args ? [
    "apparmor=0",
    "init_on_alloc=0",
    "init_on_free=0",
    "mitigations=off",
    "security=none"
  ] : []
  machine_kubelet_extraMounts = concat(local.longhorn_machine_kubelet_extraMount, local.longhorn_disk2_machine_kubelet_extraMount)

  createDefaultDiskLabel = var.prepare_longhorn ? [{
    key   = "node.longhorn.io/create-default-disk"
    value = "config"
  }] : []

  # HACK: This is too much effort to decompose right now.
  defaultDiskConfigAnnotation = var.prepare_longhorn && var.longhorn_mount_disk2 ? [{
    key   = "node.longhorn.io/default-disks-config"
    value = "'${jsonencode([{ "name" : "disk1", "path" : "/var/lib/longhorn", "allowScheduling" : true, "tags" : ["fast", "ssd"] }, { "name" : "disk2", "path" : "/var/mnt/disk2", "storageReserved" : 0, "allowScheduling" : true, "tags" : ["slow", "hdd"] }])}'"
  }] : []

  defaultNodeTagsAnnotation = var.prepare_longhorn ? [{
    key   = "node.longhorn.io/default-node-tags"
    value = "'${jsonencode(["storage"])}'"
  }] : []

  machine_labels      = local.createDefaultDiskLabel
  machine_annotations = concat(local.defaultDiskConfigAnnotation, local.defaultNodeTagsAnnotation)
}

module "params_get" {
  source = "../params-get"

  aws = var.aws
  parameters = [
    var.unifi.username_store,
    var.unifi.password_store,
    var.github.token_store,
    var.external_secrets.id_store,
    var.external_secrets.secret_store,
    var.cloudflare.api_key_store,
    var.healthchecksio.api_key_store
  ]
}
/*
This unifi provider is unreliable, getting random errors like the following:
│ Error: invalid character '<' looking for beginning of value
│ 
│   with module.unifi_dns.unifi_dns_record.record["node43"],
│   on ../unifi-dns/main.tf line 1, in resource "unifi_dns_record" "record":
│    1: resource "unifi_dns_record" "record" {
│ 
Look at the following issues to add support into the mainline provider:
https://github.com/paultyng/terraform-provider-unifi/issues/460
https://github.com/paultyng/terraform-provider-unifi/issues/461
module "unifi_dns" {
  source = "../unifi-dns"

  unifi_address     = var.unifi.address
  unifi_site        = var.unifi.site
  unifi_username    = module.params_get.values[var.unifi.username_store]
  unifi_password    = module.params_get.values[var.unifi.password_store]
  unifi_dns_records = local.unifi_dns_records
}
*/
/*
╷
│ Error: not found
│ 
│   with module.unifi_users.unifi_user.user["node43"],
│   on ../unifi-users/main.tf line 5, in resource "unifi_user" "user":
│    5: resource "unifi_user" "user" {
│ 
╵
module "unifi_users" {
  source = "../unifi-users"

  unifi_address  = var.unifi.address
  unifi_site     = var.unifi.site
  unifi_username = module.params_get.values[var.unifi.username_store]
  unifi_password = module.params_get.values[var.unifi.password_store]
  unifi_users    = local.unifi_users
}*/
module "talos_cluster" {
  source = "../talos-cluster"

  cluster_name           = var.cluster_name
  cluster_endpoint       = var.cluster_endpoint
  cluster_vip            = var.cluster_vip
  cluster_node_subnet    = var.cluster_node_subnet
  cluster_pod_subnet     = var.cluster_pod_subnet
  cluster_service_subnet = var.cluster_service_subnet

  cluster_allowSchedulingOnControlPlanes = true
  cluster_coreDNS_disabled               = false
  cluster_proxy_disabled                 = true
  cluster_extraManifests                 = local.cluster_extraManifests
  cluster_inlineManifests                = local.cluster_inlineManifests
  cluster_etcd_extraArgs                 = local.cluster_etcd_extraArgs
  cluster_scheduler_extraArgs            = local.cluster_scheduler_extraArgs
  cluster_controllerManager_extraArgs    = local.cluster_controllerManager_extraArgs

  machine_files               = local.machine_files
  machine_extensions          = local.machine_extensions
  machine_kubelet_extraMounts = local.machine_kubelet_extraMounts
  machine_extra_kernel_args   = local.machine_extra_kernel_args
  machine_network_nameservers = var.nameservers
  machine_time_servers        = var.timeservers
  machine_annotations         = local.machine_annotations
  machine_labels              = local.machine_labels

  cilium_version      = var.cilium_version
  cilium_helm_values  = var.cilium_helm_values
  kubernetes_version  = var.kubernetes_version
  talos_version       = var.talos_version
  kube_config_path    = var.kube_config_path
  talos_config_path   = var.talos_config_path
  timeout             = var.timeout
  machines            = var.machines
  stage_talos_upgrade = false
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
