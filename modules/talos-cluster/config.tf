locals {
  nodes            = [for host_key, host in var.hosts : host_key]
  controlplane_ips = [for host_key, host in var.hosts : host.interfaces[0].addresses[0] if host.role == "controlplane"]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "control_plane" {
  machine_type = "controlplane"

  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version
  machine_secrets    = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.controlplane_ips
  nodes                = local.nodes
}
