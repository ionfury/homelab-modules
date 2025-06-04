run "plan" {
  command = plan
  variables {
    cluster_name           = "cluster_name"
    cluster_tld            = "cluster_tld"
    cluster_vip            = "1.2.3.4"
    cluster_node_subnet    = "1.2.3.4/24"
    cluster_pod_subnet     = "1.2.3.4/24"
    cluster_service_subnet = "1.2.3.4/24"
    cluster_on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
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
    kubernetes_version = "1.32.0"
    talos_version      = "v1.10.0"
    prometheus_version = "20.0.0"
    flux_version       = "v2.4.0"

    nameservers = ["1.1.1.1"]
    timeservers = ["2.2.2.2"]

    talos_config_path      = "~/.talos"
    kubernetes_config_path = "~/.kube"

    machines = {
      node44 = {
        type    = "controlplane"
        install = { disk = "/dev/sda" }
        interfaces = [{
          hardwareAddr = "aa:bb:cc:dd:ee:ff"
          addresses    = ["1.2.3.4"]
        }]
      }
    }

    ssm_output_path = "/homelab/integration/accounts/cluster/plan"

    unifi = {
      address       = "https://192.168.1.1"
      site          = "default"
      api_key_store = "/homelab/integration/accounts/unifi/api-key"
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
      zone_id         = "zone_id"
    }

    external_secrets = {
      id_store     = "/homelab/integration/accounts/external-secrets/id"
      secret_store = "/homelab/integration/accounts/external-secrets/secret"
    }

    healthchecksio = {
      api_key_store = "/homelab/integration/accounts/healthchecksio/api-key"
    }
  }

  assert {
    condition     = local.cluster_endpoint == "cluster_name.cluster_tld"
    error_message = "local cluster_endpoint error"
  }

  assert {
    condition     = local.cluster_endpoint_address == "https://cluster_name.cluster_tld:6443"
    error_message = "local cluster_endpoint_address error"
  }

  assert {
    condition     = local.talos_cluster_config == <<EOT
controlPlane:
  endpoint: https://cluster_name.cluster_tld:6443
allowSchedulingOnControlPlanes: true
clusterName: cluster_name
network:
  cni:
    name: none
  podSubnets:
    - 1.2.3.4/24
  serviceSubnets:
    - 1.2.3.4/24
apiServer:
  disablePodSecurityPolicy: true
proxy:
  disabled: true
coreDNS:
  disabled: false
extraManifests:
  - https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-20.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-podmonitors.yaml
  - https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-20.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-servicemonitors.yaml
  - https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-20.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-probes.yaml
  - https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/tags/prometheus-operator-crds-20.0.0/charts/kube-prometheus-stack/charts/crds/crds/crd-prometheusrules.yaml
EOT
    error_message = "local talos_cluster_config error"
  }

  assert {
    condition     = local.machines[0].talos_config == <<EOT
type: controlplane
kubelet:
  nodeIP:
    validSubnets:
      - 1.2.3.4/24
network:
  hostname: node44
  interfaces:
    - deviceSelector:
        physical: true
      addresses:
        - 1.2.3.4
      mtu: 1500
      dhcp: true
      dhcpOptions:
        routeMetric: 100
      vip:
        ip: 1.2.3.4
      vlans:
  nameservers:
    - 1.1.1.1
time:
  servers:
    - 2.2.2.2
install:
  disk: /dev/sda
  extraKernelArgs:
  wipe: true
features:
  hostDNS:
    enabled: true
    forwardKubeDNSToHost: true
    resolveMemberNames: true
nodeLabels:
nodeAnnotations:
files:
EOT
    error_message = "local machines[0].talos_config error"
  }
}
