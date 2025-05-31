/*resource "null_resource" "talos_cluster_health" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "sleep 300 && talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT --run-e2e"

    environment = {
      TALOSCONFIG = pathexpand(var.talos_config_path)
      NODE        = var.node
      TIMEOUT     = "10m"
    }
  }
}
*/

data "external" "talos_info" {
  program = ["bash", pathexpand("${path.module}/resources/scripts/get_info.sh")]

  query = {
    talos_config_path = pathexpand(var.talos_config_path)
    node              = var.node
  }
}
