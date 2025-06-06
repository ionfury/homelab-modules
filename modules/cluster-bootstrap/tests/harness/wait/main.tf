terraform {
  required_version = ">= 1.8.8"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "time" {
  # Configuration options
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "60s"
}
