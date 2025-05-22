variable "machines" {
  type = map(any)
}

variable "machine_talos_version" {
  type = map(string)
}

variable "machine_schematic_id" {
  type = map(string)
}

variable "talos_config_path" {
  type = string
}

variable "timeout" {
  type = string
}
