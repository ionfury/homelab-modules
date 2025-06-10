locals {
  cluster_name     = try(yamldecode(var.talos_cluster_config).clusterName, "talos.local")
  cluster_endpoint = yamldecode(var.talos_cluster_config).controlPlane.endpoint

  machines          = { for v in var.machines : yamldecode(v.talos_config).network.hostname => v }
  addresses         = { for k, v in local.machines : k => split("/", yamldecode(v.talos_config).network.interfaces[0].addresses[0])[0] }
  machine_ips       = [for k, v in local.machines : local.addresses[k]]
  control_plane_ips = [for k, v in local.machines : local.addresses[k] if yamldecode(v.talos_config).type == "controlplane"]
  #worker_ips        = [for k, v in local.machines : local.addresses[k] if yamldecode(v.talos_config).type == "worker"]
  bootstrap_ip = local.control_plane_ips[0]
}

data "helm_template" "bootstrap_charts" {
  for_each = { for i, chart in var.bootstrap_charts : chart.name => chart }

  repository   = each.value.repository
  chart        = each.value.chart
  name         = each.value.name
  version      = each.value.version
  namespace    = each.value.namespace
  kube_version = var.kubernetes_version
  values       = [each.value.values]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "this" {
  for_each = local.machines

  cluster_name       = local.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = yamldecode(each.value.talos_config).type
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version

  config_patches = [
    templatefile("${path.module}/resources/talos-patches/cluster.yaml.tftpl", {
      type           = yamldecode(each.value.talos_config).type
      cluster_config = var.talos_cluster_config
    }),
    templatefile("${path.module}/resources/talos-patches/inline_manifests.yaml.tftpl", {
      type      = yamldecode(each.value.talos_config).type
      manifests = data.helm_template.bootstrap_charts
    }),
    templatefile("${path.module}/resources/talos-patches/machine_install.yaml.tftpl", {
      machine_install_disk_image = each.value.secureboot ? local.machine_installer_secureboot[each.key] : local.machine_installer[each.key]
    }),
    templatefile("${path.module}/resources/talos-patches/machine.yaml.tftpl", {
      machine_config = each.value.talos_config
    }),
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.control_plane_ips
  nodes                = local.machine_ips
}
