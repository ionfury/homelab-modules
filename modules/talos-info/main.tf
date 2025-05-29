data "external" "talos_info" {
  program = ["bash", pathexpand("${path.module}/resources/scripts/get_info.sh")]

  query = {
    talos_config_path = pathexpand(var.talos_config_path)
    node              = var.node
  }
}
