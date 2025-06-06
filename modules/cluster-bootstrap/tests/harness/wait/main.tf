terraform {
  required_version = ">= 1.8.8"
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}

provider "time" {
  # Configuration options
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}
