run "provision" {
  module {
    source = "../cluster-kubevirt-hosts"
  }
  variables {
    name                    = "cluster-apply"
    vm_count                = 1
    data_root_storage_class = "fast"
    data_disk_storage_class = "fast"
    talos_version           = "1.10.0"
  }
}


run "apply" {
  variables {
    cluster_name     = "cluster-apply"
    cluster_endpoint = run.provision.lb.dns

    cluster_on_destroy = {
      graceful = false
      reboot   = false
      reset    = false
    }

    cilium_version     = "1.16.5"
    kubernetes_version = "1.32.0"
    talos_version      = "v1.10.0"
    prometheus_version = "20.0.0"

    nameservers = ["kube-dns.kube-system.svc.cluster.local"]
    timeservers = ["0.pool.ntp.org"]

    talos_config_path      = "~/.talos/testing"
    kubernetes_config_path = "~/.kube/testing"
    timeout                = "10m"

    cluster_vip            = "" # Have a loadbalancer
    cluster_node_subnet    = "172.32.0.0/17"
    cluster_pod_subnet     = "172.33.0.0/16"
    cluster_service_subnet = "172.34.0.0/16"

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

    machines = {
      cluster-apply-talos-vm-1 = {
        type    = "controlplane"
        install = { disk = "/dev/sda" }
        interfaces = [{
          addresses = ["${run.provision.vms["cluster-apply-talos-vm-1"].ip}"]
        }]
      }
    }

    ssm_output_path = "/homelab/infrastructure/clusters/integration/ephemeral"
  }
}
