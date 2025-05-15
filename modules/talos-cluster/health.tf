# data.talos_cluster_health does not work in the case of scaling-in nodes into an existing cluster.  See: https://github.com/siderolabs/terraform-provider-talos/issues/221
# Run a null resource provisioner callout to talos_cluster_health to get the same functionality.

# This prevents the module from reporting completion until the cluster is up and operational.
# tflint-ignore: terraform_unused_declarations
resource "null_resource" "talos_cluster_health" {
  depends_on = [talos_machine_bootstrap.this, talos_machine_configuration_apply.machines]
  for_each   = { for k, v in local.machines : k => v if yamldecode(v.talos_config) == "controlplane" }

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT"

    environment = {
      TALOSCONFIG = pathexpand(local_sensitive_file.talosconfig.filename)
      NODE        = each.key
      TIMEOUT     = var.timeout
    }
  }
}

# This reports healthy when the cluster is upgraded.
# tflint-ignore: terraform_unused_declarations
resource "null_resource" "talos_cluster_health_upgrade" {
  depends_on = [null_resource.talos_upgrade_trigger]
  for_each   = { for k, v in local.machines : k => v if yamldecode(v.talos_config) == "controlplane" }

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT"

    environment = {
      TALOSCONFIG = pathexpand(local_sensitive_file.talosconfig.filename)
      NODE        = each.key
      TIMEOUT     = var.timeout
    }
  }
}
