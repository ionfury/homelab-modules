resource "local_sensitive_file" "machineconf" {
  for_each        = data.talos_machine_configuration.this
  content         = each.value.machine_configuration
  filename        = pathexpand("${var.talos_config_path}/${var.cluster_name}-${each.key}-machine_configuration.yaml")
  file_permission = "0644"
}

output "machineconf_filenames" {
  value = [for f in local_sensitive_file.machineconf : f.filename]
}

resource "local_sensitive_file" "talosconfig" {
  content         = data.talos_client_configuration.this.talos_config
  filename        = pathexpand("${var.talos_config_path}/${var.cluster_name}.yaml")
  file_permission = "0644"
}

output "talosconfig_filename" {
  value = local_sensitive_file.talosconfig.filename
}

resource "local_sensitive_file" "kubeconfig" {
  content         = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename        = pathexpand("${var.kube_config_path}/${var.cluster_name}.yaml")
  file_permission = "0644"
}

output "kubeconfig_filename" {
  value = local_sensitive_file.kubeconfig.filename
}

output "kubeconfig_host" {
  sensitive = true
  value     = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
}

output "kubeconfig_client_certificate" {
  sensitive = true
  value     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
}

output "kubeconfig_client_key" {
  sensitive = true
  value     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
}

output "kubeconfig_cluster_ca_certificate" {
  sensitive = true
  value     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
}
