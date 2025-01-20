data "talos_image_factory_extensions_versions" "machine_version" {
  for_each = var.machines

  talos_version = var.talos_version

  filters = {
    names = concat(each.value.install.extensions, var.machine_extensions)
  }
}

resource "talos_image_factory_schematic" "machine_schematic" {
  for_each = var.machines

  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = try(data.talos_image_factory_extensions_versions.machine_version[each.key].extensions_info[*].name, [])
        }
        extraKernelArgs = concat(each.value.install.extraKernelArgs, var.machine_extra_kernel_args)
        secureboot = {
          enabled = each.value.install.secureboot
        }
      }
    }
  )
}

data "talos_image_factory_urls" "machine_image_url" {
  for_each = var.machines

  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.machine_schematic[each.key].id
  platform      = each.value.install.platform
  architecture  = each.value.install.architecture
}

# Hack: https://github.com/siderolabs/terraform-provider-talos/issues/140
resource "null_resource" "talos_upgrade_trigger" {
  depends_on = [null_resource.talos_cluster_health]
  for_each   = { for name, machine in var.machines : name => machine if machine.first_scale_in == false }

  triggers = {
    desired_talos_tag    = data.talos_image_factory_urls.machine_image_url[each.key].talos_version
    desired_schematic_id = data.talos_image_factory_urls.machine_image_url[each.key].schematic_id
    stage_talos_upgrade  = var.stage_talos_upgrade
  }

  # Should only upgrade if there's a schematic mismatch
  provisioner "local-exec" {
    command = "flock $LOCK_FILE --command ${path.module}/resources/scripts/upgrade-node.sh"

    environment = {
      LOCK_FILE = "${path.module}/resources/.upgrade-node.lock"

      DESIRED_TALOS_TAG       = self.triggers.desired_talos_tag
      DESIRED_TALOS_SCHEMATIC = self.triggers.desired_schematic_id
      TALOS_CONFIG_PATH       = local_sensitive_file.talosconfig.filename
      TALOS_NODE              = each.key
      STAGE                   = self.triggers.stage_talos_upgrade
      TIMEOUT                 = "10m"
    }
  }
}
