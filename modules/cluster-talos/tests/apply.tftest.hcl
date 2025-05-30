run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }

  variables {
    name                    = "cluster-talos-apply"
    vm_count                = 3
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }
}

run "apply" {
  variables {
    talos_version        = "v1.10.0"
    kubernetes_version   = "1.32.0"
    talos_cluster_config = <<EOT
clusterName: cluster-talos-apply
allowSchedulingOnControlPlanes: true
network:
  cni:
    name: none
proxy:
  disabled: true
coreDNS:
  disabled: false
controlPlane:
  endpoint: https://${run.provision.lb.dns}:6443
EOT

    machines = [
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-1
  interfaces:
    - deviceSelector:
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["cluster-talos-apply-talos-vm-1"].ip}
EOT
      },
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-2
  interfaces:
    - deviceSelector:
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["cluster-talos-apply-talos-vm-2"].ip}
EOT
      },
      {
        talos_config = <<EOT
type: controlplane
network:
  hostname: cluster-talos-apply-talos-vm-3
  interfaces:
    - deviceSelector:
        physical: true
      dhcp: true
      addresses:
        - ${run.provision.vms["cluster-talos-apply-talos-vm-3"].ip}
EOT        
      }
    ]

    bootstrap_charts = [
      {
        repository = "https://helm.cilium.io/"
        chart      = "cilium"
        name       = "cilium"
        version    = "1.16.5"
        namespace  = "kube-system"
        values     = <<EOT

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
      }
    ]

    on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
    }
  }
}
