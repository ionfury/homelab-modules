run "random" {
  module {
    source = "./tests/harness/random"
  }
}

variables {
  kubernetes_version = "1.32.0"

  talos_config_path      = "~/.talos/testing"
  kubernetes_config_path = "~/.kube/testing"

  talos_cluster_config = <<EOT
clusterName: ${run.random.resource_name}
allowSchedulingOnControlPlanes: true
apiServer:
  disablePodSecurityPolicy: true
controlPlane:
  endpoint: https://192.168.10.218:6443
network:
  cni:
    name: none
  podSubnets:
    - 172.16.0.0/16
  serviceSubnets:
    - 172.17.0.0/16
proxy:
  disabled: true
EOT

  machines = [
    {
      talos_config = <<EOT
type: controlplane
network:
  hostname: node44
  nameservers:
    - 192.168.10.1
  interfaces:
    - deviceSelector:
        physical: true
      addresses:
        - 192.168.10.218/24
      mtu: 1500
      dhcp: true
install:
  disk: /dev/sda
  wipe: true
time:
  servers:
    - 0.pool.ntp.org
EOT
    }
  ]

  bootstrap_charts = [{
    repository = "https://helm.cilium.io/"
    chart      = "cilium"
    name       = "cilium"
    version    = "1.16.5"
    namespace  = "kube-system"
    values     = <<EOT
ipam:
  mode: kubernetes
kubeProxyReplacement: true
operator:
  replicas: 1
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
  }]
}

run "provision" {
  variables {
    talos_version = "v1.10.0"
  }
}

run "upgrade" {
  variables {
    talos_version = "v1.10.1"
  }
}

run "upgrade_test" {
  module {
    source = "./tests/harness/talos"
  }

  variables {
    talos_config_path = "~/.talos/testing/${run.random.resource_name}.yaml"
    node              = "node44"
  }

  assert {
    condition     = data.external.talos_info.result["talos_version"] == "v1.10.1"
    error_message = "Incorrect talos version: ${data.external.talos_info.result["talos_version"]}"
  }
}

run "scale_up" {
  variables {
    talos_version = "v1.10.1"
    machines = [
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: node44
  nameservers:
    - 192.168.10.1
  interfaces:
    - deviceSelector:
        physical: true
      addresses:
        - 192.168.10.218/24
      mtu: 1500
      dhcp: true
install:
  disk: /dev/sda
  wipe: true
time:
  servers:
    - 0.pool.ntp.org
EOT
      },
      {
        talos_config = <<EOT
type: worker
network:
  hostname: node45
  nameservers:
    - 192.168.10.1
  interfaces:
    - deviceSelector:
        physical: true
      addresses:
        - 192.168.10.222/24
      mtu: 1500
      dhcp: true
install:
  disk: /dev/sda
  wipe: true
time:
  servers:
    - 0.pool.ntp.org
EOT
      }
    ]
  }

  assert {
    condition     = length(talos_machine_configuration_apply.machines) == 2
    error_message = "Incorrect length of talos machine configuration apply: ${length(talos_machine_configuration_apply.machines)}"
  }
}

