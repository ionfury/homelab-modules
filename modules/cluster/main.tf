locals {
  cluster_endpoint         = "${var.cluster_name}.k8s.${var.cluster_tld}"
  cluster_endpoint_address = "https://${local.cluster_endpoint}:6443"
  cluster_path             = "${var.github.repository_path}/${var.cluster_name}"

  talos_cluster_config = templatefile("${path.module}/resources/templates/talos_cluster.yaml.tftpl", {
    cluster_endpoint                    = local.cluster_endpoint_address
    cluster_name                        = var.cluster_name
    cluster_pod_subnet                  = var.cluster_pod_subnet
    cluster_service_subnet              = var.cluster_service_subnet
    cluster_etcd_extraArgs              = var.cluster_etcd_extraArgs
    cluster_controllerManager_extraArgs = var.cluster_controllerManager_extraArgs
    cluster_scheduler_extraArgs         = var.cluster_scheduler_extraArgs
    cluster_extraManifests              = concat(local.prometheus_extraManifests, local.gateway_api_extraManifests)
  })

  machines = [
    for name, machine in var.machines : {
      talos_config = templatefile("${path.module}/resources/templates/talos_machine.yaml.tftpl", {
        cluster_node_subnet         = var.cluster_node_subnet
        cluster_vip                 = var.cluster_vip
        machine_hostname            = name
        machine_type                = machine.type
        machine_interfaces          = machine.interfaces
        machine_nameservers         = var.nameservers
        machine_timeservers         = var.timeservers
        machine_install             = machine.install
        machine_disks               = machine.disks
        machine_labels              = machine.labels
        machine_annotations         = machine.annotations
        machine_files               = machine.files
        machine_kubelet_extraMounts = machine.kubelet_extraMounts
      })
      selector          = machine.install.selector
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

  gateway_api_extraManifests = [
    "https://github.com/kubernetes-sigs/gateway-api/releases/download/${var.gateway_api_version}/experimental-install.yaml"
  ]

  generated_cluster_env_vars = [
    {
      name  = "cluster_name"
      value = var.cluster_name
    },
    {
      name  = "cluster_tld"
      value = var.cluster_tld
    },
    {
      name  = "cluster_endpoint"
      value = local.cluster_endpoint_address
    },
    {
      name  = "cluster_vip"
      value = var.cluster_vip
    },
    {
      name  = "cluster_node_subnet"
      value = var.cluster_node_subnet
    },
    {
      name  = "cluster_pod_subnet"
      value = var.cluster_pod_subnet
    },
    {
      name  = "cluster_service_subnet"
      value = var.cluster_service_subnet
    },
    {
      name  = "cluster_path"
      value = local.cluster_path
    },
    {
      name  = "talos_version"
      value = var.talos_version
    },
    {
      name  = "cilium_version"
      value = var.cilium_version
    },
    {
      name  = "flux_version"
      value = var.flux_version
    },
    {
      name  = "prometheus_version"
      value = var.prometheus_version
    },
    {
      name  = "kubernetes_version"
      value = var.kubernetes_version
    },
    {
      name  = "default_replica_count"
      value = "\"${tostring(min(3, length(var.machines)))}\""
    }
  ]

  cluster_env_vars = concat(var.cluster_env_vars, local.generated_cluster_env_vars)

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
  # depends_on = [module.cluster_talos]
  source = "../cluster-bootstrap"

  cluster_name     = var.cluster_name
  flux_version     = var.flux_version
  tld              = var.cluster_tld
  cluster_env_vars = local.cluster_env_vars
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
