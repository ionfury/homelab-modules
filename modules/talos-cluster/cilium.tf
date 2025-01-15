data "helm_template" "cilium" {
  repository   = "https://helm.cilium.io/"
  chart        = "cilium"
  name         = "cilium"
  version      = var.cilium_version
  namespace    = "kube-system"
  kube_version = var.kubernetes_version
  values = [
    templatestring(var.cilium_helm_values, {
      cluster_name                           = var.cluster_name
      cluster_vip                            = var.cluster_vip
      cluster_pod_subnet                     = var.cluster_pod_subnet
      cluster_service_subnet                 = var.cluster_service_subnet
      cluster_node_subnet                    = var.cluster_node_subnet
      cluster_proxy_disabled                 = var.cluster_proxy_disabled
      cluster_allowSchedulingOnControlPlanes = var.cluster_allowSchedulingOnControlPlanes
      cluster_coreDNS_disabled               = var.cluster_coreDNS_disabled

      machine_network_nameservers = var.machine_network_nameservers
      machine_time_servers        = var.machine_time_servers
      machine_kubelet_extraMounts = var.machine_kubelet_extraMounts
      machine_files               = var.machine_files
      machines                    = var.machines

      kubernetes_version       = var.kubernetes_version
      talos_version            = var.talos_version
      cilium_version           = var.cilium_version
      gracefully_destroy_nodes = var.gracefully_destroy_nodes
      timeout                  = var.timeout
      run_talos_upgrade        = var.run_talos_upgrade
    })
  ]
}
