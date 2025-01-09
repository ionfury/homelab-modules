output "talosconfig_raw" {
  sensitive = true
  value     = data.talos_client_configuration.this.talos_config
}

output "kubeconfig_raw" {
  sensitive = true
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
}

output "kubeconfig_host" {
  value = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
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
