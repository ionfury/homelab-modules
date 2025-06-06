run "provision_hosts" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "cluster-bootstrap-apply"
    vm_count                = 1
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }
}

run "provision_cluster" {

  variables {
    talos_version        = "v1.10.0"
    kubernetes_version   = "1.32.0"
    talos_cluster_config = <<EOT
clusterName: cluster-bootstrap-apply
allowSchedulingOnControlPlanes: true
controlPlane:
  endpoint: https://${run.provision_hosts.lb.ip}:6443
EOT

    machines = [
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-bootstrap-apply-talos-vm-1
  nameservers:
    - 1.1.1.1
  interfaces:
    - deviceSelector:
        physical: true
      dhcp: true
      addresses:
        - ${run.provision_hosts.vms["cluster-bootstrap-apply-talos-vm-1"].ip}
EOT
      }
    ]

    on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
    }
  }
}

run "get_secrets" {
  module {
    source = "./tests/harness/aws_ssm_params_get"
  }

  variables {
    parameters = [
      "/homelab/integration/accounts/github/token",
      "/homelab/integration/accounts/cloudflare/token",
      "/homelab/integration/accounts/external-secrets/id",
      "/homelab/integration/accounts/external-secrets/secret",
      "/homelab/integration/accounts/healthchecksio/api-key"
    ]
  }
}

run "apply" {
  variables {
    cluster_name = "plan"
    flux_version = "v2.4.0"
    tld          = "tomnowak.work"

    cluster_env_vars = {
      hello = "world"
    }

    kubeconfig = {
      host                   = run.provision_cluster.kubeconfig_host
      client_certificate     = run.provision_cluster.client_certificate
      client_key             = run.provision_cluster.client_key
      cluster_ca_certificate = run.provision_cluster.cluster_ca_certificate
    }

    github = {
      org             = "ionfury"
      repository      = "homelab-integration"
      repository_path = "kubernetes/clusters"
      token_store     = "/homelab/integration/accounts/github/token"
    }

    cloudflare = {
      account         = "homelab"
      email           = "ionfury@gmail.com"
      api_token_store = "/homelab/integration/accounts/cloudflare/token"
      zone_id         = "799905ff93d585a9a0633949275cbf98"
    }

    external_secrets = {
      id_store     = "/homelab/integration/accounts/external-secrets/id"
      secret_store = "/homelab/integration/accounts/external-secrets/secret"
    }

    healthchecksio = {
      api_key_store = "/homelab/integration/accounts/healthchecksio/api-key"
    }
  }
}
