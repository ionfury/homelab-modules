locals {
  bootstrap_node     = [for host_key, host in var.hosts : host_key if host.role == "controlplane"][0]
  bootstrap_endpoint = [for host_key, host in var.hosts : host.interfaces[0].addresses[0] if host.role == "controlplane"][0]
}

resource "talos_machine_configuration_apply" "hosts" {
  for_each = var.hosts

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.key
  endpoint                    = each.value.interfaces[0].addresses[0]

  on_destroy = {
    graceful = var.gracefully_destroy_nodes
    reboot   = true
    reset    = true
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.hosts]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_node
  endpoint             = local.bootstrap_endpoint
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_node
  endpoint             = local.bootstrap_endpoint
}
