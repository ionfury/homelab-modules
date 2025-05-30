resource "null_resource" "talos_cluster_health" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "talosctl --talosconfig $TALOSCONFIG health --nodes $NODE --wait-timeout $TIMEOUT"

    environment = {
      TALOSCONFIG = pathexpand(var.talos_config_path)
      NODE        = var.node
      TIMEOUT     = "10m"
    }
  }
}


data "external" "talos_info" {
  depends_on = [null_resource.talos_cluster_health]
  program    = ["bash", pathexpand("${path.module}/resources/scripts/get_info.sh")]

  query = {
    talos_config_path = pathexpand(var.talos_config_path)
    node              = var.node
  }
}
