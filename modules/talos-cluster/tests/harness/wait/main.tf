terraform {
  required_version = ">= 1.6.6"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

variable "duration" {
  description = "The duration to wait for the cluster to become healthy."
  type        = string
  default     = "120s"
}

resource "time_sleep" "wait" {
  create_duration = var.duration
}
