terraform {
  required_version = ">= 1.6.6"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}

variable "node" {
  description = "The node to check."
  type        = string
}

variable "talos_config_path" {
  description = "The path to the talos config file."
  type        = string
}

data "external" "talos_version" {
  program = ["bash", pathexpand("${path.module}/resources/get_version.sh")]

  query = {
    talos_config_path = pathexpand(var.talos_config_path)
    node              = var.node
  }
}

output "talos_version" {
  value = data.external.talos_version.result.talos_version
}
