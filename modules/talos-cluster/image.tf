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
