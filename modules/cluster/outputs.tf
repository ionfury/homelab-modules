output "machineconf_filenames" {
  value = module.talos_cluster.machineconf_filenames
}

output "talosconfig_filename" {
  value = module.talos_cluster.talosconfig_filename
}

output "kubeconfig_filename" {
  value = module.talos_cluster.kubeconfig_filename
}
