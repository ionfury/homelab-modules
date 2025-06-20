run "random" {
  module {
    source = "./tests/harness/random"
  }

  variables {
    length = 2
  }
}

run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "node"
    vm_count                = 1
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"

    memory = "4G"
  }
}

run "provision_cluster" {
  module {
    source = "../cluster-talos"
  }

  variables {
    talos_version        = "v1.10.0"
    kubernetes_version   = "1.32.0"
    talos_cluster_config = <<EOT
clusterName: ${run.random.resource_name}
allowSchedulingOnControlPlanes: true
controlPlane:
  endpoint: https://${run.provision.vmi["node-1"].ip}:6443
EOT

    machines = [
      {
        install_disk_filters = { size = "> 1GB" }
        talos_config         = <<EOT
type: controlplane
network:
  hostname: cluster-bootstrap-apply-1
  nameservers:
    - 1.1.1.1
  interfaces:
    - deviceSelector:
        hardwareAddr: ${run.provision.vmi["node-1"].mac}
      dhcp: true
      addresses:
        - ${run.provision.vmi["node-1"].ip}/32
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

run "get" {
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
    cluster_name = run.random.resource_name
    flux_version = "v2.4.0"
    tld          = "tomnowak.work"

    cluster_env_vars = [{
      name  = "hello"
      value = "world"
    }]

    kubeconfig = {
      host                   = run.provision_cluster.kubeconfig_host
      client_certificate     = run.provision_cluster.kubeconfig_client_certificate
      client_key             = run.provision_cluster.kubeconfig_client_key
      cluster_ca_certificate = run.provision_cluster.kubeconfig_cluster_ca_certificate
    }

    github = {
      org             = "ionfury"
      repository      = "homelab-integration"
      repository_path = "kubernetes/clusters"
      token           = run.get.values["/homelab/integration/accounts/github/token"]
    }

    cloudflare = {
      account   = "homelab"
      email     = "ionfury@gmail.com"
      api_token = run.get.values["/homelab/integration/accounts/cloudflare/token"]
      zone_id   = "799905ff93d585a9a0633949275cbf98"
    }

    external_secrets = {
      id     = run.get.values["/homelab/integration/accounts/external-secrets/id"]
      secret = run.get.values["/homelab/integration/accounts/external-secrets/secret"]
    }

    healthchecksio = {
      api_key = run.get.values["/homelab/integration/accounts/healthchecksio/api-key"]
    }
  }
}
