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

# The above can be unreliable...  Use this to kick off helm deployments in that case.
# tflint-ignore: terraform_unused_declarations
resource "time_sleep" "wait" {
  depends_on      = [talos_cluster_kubeconfig.this]
  create_duration = "120s"
}
