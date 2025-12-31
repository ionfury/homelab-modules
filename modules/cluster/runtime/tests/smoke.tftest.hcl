run "plan" {
  command = plan

  variables {
    cluster_name     = "test"
    cluster_tld      = "internal.test"
    cluster_endpoint = "k8s.internal.test"

    dns_records = {
      node1 = {
        name   = "k8s.internal.test"
        record = "10.0.0.1"
      }
    }

    dhcp_reservations = {
      node1 = {
        mac = "aa:bb:cc:dd:ee:01"
        ip  = "10.0.0.1"
      }
    }

    machines = {
      node1 = {
        talos_config      = <<-EOT
type: controlplane
network:
  hostname: node1
  interfaces:
    - addresses:
        - 10.0.0.1/24
EOT
        selector          = "any"
        extensions        = []
        extra_kernel_args = []
        secureboot        = false
        architecture      = "amd64"
        platform          = "metal"
        sbc               = ""
      }
    }

    talos_cluster_config = <<-EOT
controlPlane:
  endpoint: https://k8s.internal.test:6443
clusterName: test
network:
  cni:
    name: none
  podSubnets:
    - 10.244.0.0/16
  serviceSubnets:
    - 10.96.0.0/12
EOT

    bootstrap_charts = []

    cluster_env_vars = [
      { name = "a", value = "b" }
    ]

    versions = {
      kubernetes = "1.34.0"
      talos      = "v1.10.0"
      flux       = "v2.4.0"
    }

    nameservers            = ["1.1.1.1"]
    timeservers            = ["2.2.2.2"]
    talos_config_path      = "/tmp"
    kubernetes_config_path = "/tmp"
    ssm_output_path        = "/tmp"

    on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
    }

    unifi = {
      address       = "https://example"
      site          = "default"
      api_key_store = "/dummy"
    }

    github = {
      org             = "org"
      repository      = "repo"
      repository_path = "path"
      token_store     = "/dummy"
    }

    cloudflare = {
      account         = "acct"
      email           = "email"
      api_token_store = "/dummy"
      zone_id         = "zone"
    }

    external_secrets = {
      id_store     = "/dummy"
      secret_store = "/dummy"
    }

    healthchecksio = {
      api_key_store = "/dummy"
    }
  }

  assert {
    condition     = output.cluster_endpoint == "k8s.internal.test"
    error_message = "cluster_endpoint was not propagated through runtime"
  }

  assert {
    condition     = output.kubeconfig != null
    error_message = "kubeconfig output missing"
  }

  assert {
    condition     = output.talosconfig_raw != null
    error_message = "talosconfig_raw output missing"
  }
}
