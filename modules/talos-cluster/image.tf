data "talos_image_factory_extensions_versions" "host_version" {
  for_each = var.hosts

  talos_version = var.talos_version

  filters = {
    names = each.value.install.extensions
  }
}

resource "talos_image_factory_schematic" "host_schematic" {
  for_each = var.hosts

  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = try(data.talos_image_factory_extensions_versions.host_version[each.key].extensions_info[*].name, [])
        }
        extraKernelArgs = each.value.install.extraKernelArgs
        secureboot = {
          enabled = each.value.install.secureboot
        }
      }
    }
  )
}

data "talos_image_factory_urls" "host_image_url" {
  for_each = var.hosts

  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.host_schematic[each.key].id
  platform      = each.value.install.platform
  architecture  = each.value.install.architecture
}


# Hack: https://github.com/siderolabs/terraform-provider-talos/issues/140
resource "null_resource" "talos_upgrade_trigger" {
  depends_on = [data.talos_cluster_health.this]
  for_each   = var.hosts

  triggers = {
    image        = data.talos_image_factory_urls.host_image_url[each.key].urls.installer
    state_marker = var.run_talos_upgrade
  }

  provisioner "local-exec" {
    command = <<EOT
if [ "${self.triggers.state_marker}" == "true" ]; then
  echo "Running talosctl upgrade on ${each.key} with image ${self.triggers.image}..."
  talosctl --talosconfig ${local_sensitive_file.talosconfig.filename} -n ${each.key} upgrade --image ${self.triggers.image}
else
  echo "Skipping upgrade for initial creation on ${each.key}..."
fi
EOT
  }
}
