output "machineconf_filenames" {
  value = module.cluster_talos.machineconf_filenames
}

output "talosconfig_filename" {
  value = module.cluster_talos.talosconfig_filename
}

output "kubeconfig_filename" {
  value = module.cluster_talos.kubeconfig_filename
}
