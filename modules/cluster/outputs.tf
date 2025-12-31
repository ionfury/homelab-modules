output "cluster_endpoint" {
  value = module.runtime.cluster_endpoint
}

output "kubeconfig" {
  value     = module.runtime.kubeconfig
  sensitive = true
}

output "kubeconfig_raw" {
  value     = module.runtime.kubeconfig_raw
  sensitive = true
}

output "talosconfig_raw" {
  value     = module.runtime.talosconfig_raw
  sensitive = true
}
