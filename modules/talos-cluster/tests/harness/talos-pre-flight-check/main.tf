terraform {
  required_version = ">= 1.8.8"
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}

# tflint-ignore: terraform_unused_declarations
variable "machine_ip_address" {
  description = "The IP address of the machine to check."
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "machine_ipmi_address" {
  description = "The IPMI address of the machine to check."
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "machine_ipmi_username" {
  description = "The IPMI username of the machine to check."
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "machine_ipmi_password" {
  description = "The IPMI password of the machine to check."
  type        = string
}

# tflint-ignore: terraform_unused_declarations
data "external" "pre_flight_check" {
  program = ["bash", pathexpand("${path.module}/resources/scripts/pre_flight_check.sh")]

  query = {
    machine_ip_address    = var.machine_ip_address
    machine_ipmi_address  = var.machine_ipmi_address
    machine_ipmi_username = var.machine_ipmi_username
    machine_ipmi_password = var.machine_ipmi_password

    max_attempts    = 8
    wait_time       = 15
    boot_wait_time  = 90
    power_on_if_off = "true"
  }
}

# tflint-ignore: terraform_unused_declarations
output "pre_flight_check" {
  value = data.external.talos_info.result
}
