output "talos_info" {
  value = data.external.talos_info.result
}

output "talos_version" {
  value = data.external.talos_info.result["talos_version"]
}

output "schematic_version" {
  value = data.external.talos_info.result["schematic_version"]
}

output "machine_type" {
  value = data.external.talos_info.result["machine_type"]
}

output "interfaces" {
  value = data.external.talos_info.result["interfaces"]
}
