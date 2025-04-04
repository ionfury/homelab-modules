run "random" {
  module {
    source = "./tests/harness/random"
  }
}

run "test" {
  variables {
    cluster_name     = run.random.resource_name
    cluster_endpoint = "${run.random.resource_name}.tomnowak.work"
    tld              = "tomnowak.work"

    cluster_vip            = "192.168.10.6"
    cluster_node_subnet    = "192.168.10.0/24"
    cluster_pod_subnet     = "172.30.0.0/16"
    cluster_service_subnet = "172.31.0.0/16"
    cluster_env_vars = {
      test = "best"
    }

    cilium_helm_values = <<EOT
ipam:
  mode: kubernetes
kubeProxyReplacement: true
cgroup:
  autoMount:
    enabled: false
  hostRoot: /sys/fs/cgroup
k8sServiceHost: 127.0.0.1
k8sServicePort: 7445
securityContext:
  capabilities:
    ciliumAgent:
      - CHOWN
      - KILL
      - NET_ADMIN
      - NET_RAW
      - IPC_LOCK
      - SYS_ADMIN
      - SYS_RESOURCE
      - PERFMON
      - BPF
      - DAC_OVERRIDE
      - FOWNER
      - SETGID
      - SETUID
    cleanCiliumState:
      - NET_ADMIN
      - SYS_ADMIN
      - SYS_RESOURCE
EOT
    cilium_version     = "1.16.5"
    kubernetes_version = "1.30.2"
    talos_version      = "v1.9.1"
    flux_version       = "v2.4.0"
    prometheus_version = "17.0.2"

    prepare_longhorn     = true
    longhorn_mount_disk2 = false
    prepare_spegel       = true
    speedy_kernel_args   = true

    nameservers = ["192.168.10.1"]
    timeservers = ["0.pool.ntp.org", "1.pool.ntp.org"]

    talos_config_path = "~/.talos/testing"
    kube_config_path  = "~/.kube/testing"
    timeout           = "10m"

    machines = {
      node44 = {
        type    = "controlplane"
        install = { diskSelectors = ["type: 'ssd'"] }
        interfaces = [{
          hardwareAddr = "ac:1f:6b:2d:ba:1e"
          addresses    = ["192.168.10.218"]
        }]
      }
    }

    aws = {
      region  = "us-east-2"
      profile = "terragrunt"
    }

    unifi = {
      address       = "https://192.168.1.1"
      api_key_store = "/homelab/infrastructure/accounts/unifi/api-key"
      site          = "default"
    }

    github = {
      org             = "ionfury"
      repository      = "homelab"
      repository_path = "kubernetes/clusters"
      token_store     = "/homelab/infrastructure/accounts/github/token"
    }

    cloudflare = {
      account       = "homelab"
      email         = "ionfury@gmail.com"
      api_key_store = "/homelab/infrastructure/accounts/cloudflare/api-key"
    }

    external_secrets = {
      id_store     = "/homelab/infrastructure/accounts/external-secrets/id"
      secret_store = "/homelab/infrastructure/accounts/external-secrets/secret"
    }

    healthchecksio = {
      api_key_store = "/homelab/infrastructure/accounts/healthchecksio/api-key"
    }
  }
}
