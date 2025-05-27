locals {
  cluster_endpoint_address = "https://${var.cluster_endpoint}:6443"

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

  params_put = {
    kubeconfig = {
      name        = "${var.ssm_output_path}/${var.cluster_name}/kubeconfig"
      description = "Kubeconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.talos_cluster.kubeconfig_raw
    }
    talosconfig = {
      name        = "${var.ssm_output_path}/${var.cluster_name}/talosconfig"
      description = "Talosconfig for cluster '${var.cluster_name}'."
      type        = "SecureString"
      value       = module.talos_cluster.talosconfig_raw
    }
  }
}

module "talos_cluster" {
  source = "./resources/modules/talos-cluster"

  talos_version          = var.talos_version
  kubernetes_version     = var.kubernetes_version
  talos_config_path      = var.talos_config_path
  kubernetes_config_path = var.kubernetes_config_path
  talos_cluster_config   = local.talos_cluster_config
  machines               = local.machines
  bootstrap_charts       = local.bootstrap_charts
  on_destroy             = var.cluster_on_destroy
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
