locals {
  machine_schematic_id = {
    for k in keys(local.machines) : k => try(
      data.talos_image_factory_urls.machine_image_url_sbc[k].schematic_id,
      data.talos_image_factory_urls.machine_image_url_metal[k].schematic_id
    )
  }

  machine_talos_version = {
    for k in keys(local.machines) : k => try(
      data.talos_image_factory_urls.machine_image_url_sbc[k].talos_version,
      data.talos_image_factory_urls.machine_image_url_metal[k].talos_version
    )
  }
  machine_installer = {
    for k in keys(local.machines) : k => try(
      data.talos_image_factory_urls.machine_image_url_sbc[k].urls.installer,
      data.talos_image_factory_urls.machine_image_url_metal[k].urls.installer
    )
  }

  machine_installer_secureboot = {
    for k in keys(local.machines) : k => try(
      data.talos_image_factory_urls.machine_image_url_sbc[k].urls.installer_secureboot,
      data.talos_image_factory_urls.machine_image_url_metal[k].urls.installer_secureboot
    )
  }
}

data "talos_image_factory_extensions_versions" "machine_version" {
  for_each = local.machines

  talos_version = var.talos_version

  filters = {
    names = each.value.extensions
  }
}

resource "talos_image_factory_schematic" "machine_schematic" {
  for_each = local.machines

  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = try(data.talos_image_factory_extensions_versions.machine_version[each.key].extensions_info[*].name, [])
        }
        extraKernelArgs = concat(each.value.extra_kernel_args)
        secureboot = {
          enabled = each.value.secureboot
        }
      }
    }
  )
}

data "talos_image_factory_urls" "machine_image_url_metal" {
  for_each = { for k, v in local.machines : k => v if v.platform != "" }

  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.machine_schematic[each.key].id
  platform      = each.value.platform
  architecture  = each.value.architecture
}

data "talos_image_factory_urls" "machine_image_url_sbc" {
  for_each = { for k, v in local.machines : k => v if v.sbc != "" }

  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.machine_schematic[each.key].id
  architecture  = each.value.architecture
  sbc           = each.value.sbc
}

# Hack: https://github.com/siderolabs/terraform-provider-talos/issues/140
resource "null_resource" "talos_upgrade_trigger" {
  depends_on = [null_resource.talos_cluster_health]
  for_each   = local.machines

  triggers = {
    desired_talos_tag    = local.machine_talos_version[each.key]
    desired_schematic_id = local.machine_schematic_id[each.key]
  }

  # Should only upgrade if there's a schematic mismatch
  provisioner "local-exec" {
    command = "flock $LOCK_FILE --command ${path.module}/resources/scripts/upgrade-node.sh"

    environment = {
      LOCK_FILE = "${path.module}/resources/.upgrade-node.lock"

      DESIRED_TALOS_TAG       = self.triggers.desired_talos_tag
      DESIRED_TALOS_SCHEMATIC = self.triggers.desired_schematic_id
      TALOS_CONFIG_PATH       = local_sensitive_file.talosconfig.filename
      TALOS_NODE              = split("/", yamldecode(each.value.talos_config).network.interfaces[0].addresses[0])[0] #each.key
      TIMEOUT                 = var.timeout
    }
  }
}
