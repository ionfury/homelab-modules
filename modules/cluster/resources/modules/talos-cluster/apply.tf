resource "talos_machine_configuration_apply" "machines" {
  for_each = local.machines

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.key
  endpoint                    = split("/", yamldecode(each.value.talos_config).network.interfaces[0].addresses[0])[0]

  on_destroy = {
    graceful = var.on_destroy.graceful
    reboot   = var.on_destroy.reboot
    reset    = var.on_destroy.reset
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.machines]

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
