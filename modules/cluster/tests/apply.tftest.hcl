variables {
  cluster_name           = "integration"
  cluster_tld            = "tomnowak.work"
  cluster_vip            = "192.168.10.6"
  cluster_node_subnet    = "192.168.10.0/24"
  cluster_pod_subnet     = "172.30.0.0/16"
  cluster_service_subnet = "172.31.0.0/16"

  cilium_version     = "1.16.5"
  kubernetes_version = "1.32.0"
  prometheus_version = "20.0.0"
  flux_version       = "v2.4.0"

  nameservers = ["192.168.10.1"]
  timeservers = ["0.pool.ntp.org"]

  talos_config_path      = "~/.talos/testing"
  kubernetes_config_path = "~/.kube/testing"

  ssm_output_path = "/homelab/integration/clusters"

  cilium_helm_values = <<EOT
autoDirectNodeRoutes: true
ipv4NativeRoutingCIDR: 172.30.0.0/16
bandwidthManager:
  bbr: true
  enabled: true
bgpControlPlane:
  enabled: false
ipam:
  mode: kubernetes
cgroup:
  autoMount:
    enabled: false
  hostRoot: /sys/fs/cgroup
cluster:
  id: 1
  name: integration
kubeProxyReplacement: true
enableIPv4BIGTCP: true
endpointRoutes:
  enabled: false
envoy:
  enabled: true
externalIPs:
  enabled: false
hubble:
  enabled: false
l2announcements:
  enabled: true
loadBalancer:
  acceleration: best-effort
  algorithm: maglev
  mode: dsr
operator:
  rollOutPods: true
  prometheus:
    enabled: true
    serviceMonitor:
      enabled: true
  dashboards:
    enabled: true
    annotations:
      grafana_folder: Network
prometheus:
  enabled: true
  serviceMonitor:
    enabled: true
    trustCRDsExist: true
k8sServiceHost: 127.0.0.1
k8sServicePort: 7445
rollOutCiliumPods: true
routingMode: native
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

  machines = {
    node44 = {
      type    = "controlplane"
      install = { disk = "/dev/sda" }
      interfaces = [{
        hardwareAddr = "ac:1f:6b:2d:ba:1e"
        addresses    = ["192.168.10.218/24"]
      }]
    }
  }

  unifi = {
    address       = "https://192.168.1.1"
    site          = "default"
    api_key_store = "/homelab/infrastructure/accounts/unifi/api-key"
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

run "provision" {
  variables {
    talos_version = "v1.10.0"
  }
}

run "provision_test" {
  module {
    source = "../talos-info"
  }

  variables {
    talos_config_path = "~/.talos/testing/integration.yaml"
    node              = "node44"
  }

  assert {
    condition     = output.talos_version == "v1.10.0"
    error_message = "output.talos_version is not as expected"
  }
}

run "upgrade" {
  variables {
    talos_version = "v1.10.1"
  }
}

run "upgrade_test" {
  module {
    source = "../talos-info"
  }

  variables {
    talos_config_path = "~/.talos/testing/integration.yaml"
    node              = "node44"
  }

  assert {
    condition     = output.talos_version == "v1.10.1"
    error_message = "output.talos_version is not as expected"
  }
}

run "scale" {
  variables {
    talos_version = "v1.10.1"
    machines = {
      node44 = {
        type    = "controlplane"
        install = { disk = "/dev/sda" }
        interfaces = [{
          hardwareAddr = "ac:1f:6b:2d:ba:1e"
          addresses    = ["192.168.10.218/24"]
        }]
      }
      node45 = {
        type    = "worker"
        install = { disk = "/dev/sda" }
        interfaces = [{
          hardwareAddr = "ac:1f:6b:2d:bf:ce"
          addresses    = ["192.168.10.222/24"]
        }]
      }
    }
  }
}
