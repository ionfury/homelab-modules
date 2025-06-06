

terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
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
