module "talos_cluster_upgrade" {
  source = "../talos-cluster-upgrade"

  machines              = local.machines
  machine_talos_version = local.machine_talos_version
  machine_schematic_id  = local.machine_schematic_id

  talos_config_path = local_sensitive_file.talosconfig.filename
  timeout           = var.timeout

  depends_on = [talos_machine_bootstrap.this, talos_machine_configuration_apply.machines]
}
