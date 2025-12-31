output "cluster_endpoint" {
  value = var.cluster_endpoint
}

output "kubeconfig" {
  value = {
    host                   = module.cluster_talos.kubeconfig_host
    client_certificate     = module.cluster_talos.kubeconfig_client_certificate
    client_key             = module.cluster_talos.kubeconfig_client_key
    cluster_ca_certificate = module.cluster_talos.kubeconfig_cluster_ca_certificate
  }

  sensitive = true
}

output "kubeconfig_raw" {
  value     = module.cluster_talos.kubeconfig_raw
  sensitive = true
}

output "talosconfig_raw" {
  value     = module.cluster_talos.talosconfig_raw
  sensitive = true
}
