/*
output "machineconf_filenames" {
  value = module.cluster_talos.machineconf_filenames
}

output "talosconfig_filename" {
  value = module.cluster_talos.talosconfig_filename
}

output "kubeconfig_filename" {
  value = module.cluster_talos.kubeconfig_filename
}
*/

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
