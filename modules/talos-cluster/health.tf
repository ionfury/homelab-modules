# This reports healthy when kube api is available.
# tflint-ignore: terraform_unused_declarations
data "talos_cluster_health" "k8s_api_available" {
  client_configuration   = data.talos_client_configuration.this.client_configuration
  endpoints              = local.controlplane_ips
  control_plane_nodes    = local.controlplane_ips
  skip_kubernetes_checks = true

  timeouts = {
    read = var.timeout
  }
}

# This prevents the module from reporting completion until the cluster is up and operational.
# tflint-ignore: terraform_unused_declarations
data "talos_cluster_health" "this" {
  client_configuration   = data.talos_client_configuration.this.client_configuration
  endpoints              = local.controlplane_ips
  control_plane_nodes    = local.controlplane_ips
  skip_kubernetes_checks = false

  timeouts = {
    read = var.timeout
  }
}

# This reports healthy when the cluster is upgraded.
# tflint-ignore: terraform_unused_declarations
data "talos_cluster_health" "upgrade" {
  depends_on = [null_resource.talos_upgrade_trigger]

  client_configuration   = data.talos_client_configuration.this.client_configuration
  endpoints              = local.controlplane_ips
  control_plane_nodes    = local.controlplane_ips
  skip_kubernetes_checks = false

  timeouts = {
    read = var.timeout
  }
}
