# This completes when the cluster is ready to be upgraded.
resource "null_resource" "talos_cluster_health" {
  for_each = { for k, v in var.machines : k => v if yamldecode(v.talos_config) == "controlplane" }

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT"

    environment = {
      TALOSCONFIG = pathexpand(var.talos_config_path)
      NODE        = each.key
      TIMEOUT     = var.timeout
    }
  }
}

# Hack: https://github.com/siderolabs/terraform-provider-talos/issues/140
# This upgrades the cluster
resource "null_resource" "talos_upgrade_trigger" {
  depends_on = [null_resource.talos_cluster_health]
  for_each   = var.machines

  triggers = {
    desired_talos_tag    = var.machine_talos_version[each.key]
    desired_schematic_id = var.machine_schematic_id[each.key]
  }

  # Should only upgrade if there's a schematic mismatch
  provisioner "local-exec" {
    command = "flock $LOCK_FILE --command ${path.module}/resources/scripts/upgrade-node.sh"

    environment = {
      LOCK_FILE = "${path.module}/resources/.upgrade-node.lock"

      DESIRED_TALOS_TAG       = self.triggers.desired_talos_tag
      DESIRED_TALOS_SCHEMATIC = self.triggers.desired_schematic_id
      TALOS_CONFIG_PATH       = var.talos_config_path
      TALOS_NODE              = split("/", yamldecode(each.value.talos_config).network.interfaces[0].addresses[0])[0] #each.key
      TIMEOUT                 = var.timeout
    }
  }
}

# This completes when the upgrade is complete.
resource "null_resource" "talos_cluster_health_upgrade" {
  depends_on = [null_resource.talos_upgrade_trigger]
  for_each   = { for k, v in var.machines : k => v if yamldecode(v.talos_config) == "controlplane" }

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT"

    environment = {
      TALOSCONFIG = pathexpand(var.talos_config_path)
      NODE        = each.key
      TIMEOUT     = var.timeout
    }
  }
}
