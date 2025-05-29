terraform {
  required_version = ">= 1.8.8"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
    unifi = {
      source  = "filipowm/unifi"
      version = "1.0.0"
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

data "external" "talos_info" {
  program = ["bash", pathexpand("${path.module}/resources/scripts/get_info.sh")]

  query = {
    talos_config_path = pathexpand(var.talos_config_path)
    node              = var.node
  }
}

output "talos_info" {
  value = data.external.talos_info.result
}
