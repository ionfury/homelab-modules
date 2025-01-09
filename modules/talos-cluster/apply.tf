locals {
  bootstrap_node     = [for host_key, host in var.hosts : host_key if host.role == "controlplane"][0]
  bootstrap_endpoint = [for host_key, host in var.hosts : host.interfaces[0].addresses[0] if host.role == "controlplane"][0]
}

resource "talos_machine_configuration_apply" "hosts" {
  for_each = var.hosts

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.key
  endpoint                    = each.value.interfaces[0].addresses[0]

  config_patches = [
    each.value.role == "controlplane" ? templatefile("${path.module}/resources/templates/cluster_allowSchedulingOnControlPlanes.yaml.tmpl", {
      allow_scheduling_on_controlplane = var.allow_scheduling_on_controlplane
    }) : null,

    templatefile("${path.module}/resources/templates/machine_network_hostname.yaml.tmpl", {
      hostname = each.key
    }),

    templatefile("${path.module}/resources/templates/machine_install.yaml.tmpl", {
      disk_selectors    = each.value.install.diskSelector
      extra_kernel_args = each.value.install.extraKernelArgs
      disk_image        = each.value.install.secureboot ? data.talos_image_factory_urls.host_image_url[each.key].urls.installer_secureboot : data.talos_image_factory_urls.host_image_url[each.key].urls.installer
      wipe              = each.value.install.wipe
    }),

    templatefile("${path.module}/resources/templates/machine_network_namerservers.yaml.tmpl", {
      nameservers = var.nameservers
    }),

    templatefile("${path.module}/resources/templates/machine_time_servers.yaml.tmpl", {
      ntp_servers = var.ntp_servers
    }),

    templatefile("${path.module}/resources/templates/machine_features_hostDNS.yaml.tmpl", {
      host_dns_enabled         = var.host_dns_enabled
      resolve_member_names     = var.host_dns_resolveMemberNames
      forward_kube_dns_to_host = var.host_dns_forwardKubeDNSToHost
    }),

    templatefile("${path.module}/resources/templates/machine_network_interfaces.yaml.tmpl", {
      cluster_vip = var.cluster_vip
      interfaces  = each.value.interfaces
    }),

    templatefile("${path.module}/resources/templates/cluster_network.yaml.tmpl", {
      cluster_pod_subnet     = var.cluster_pod_subnet
      cluster_service_subnet = var.cluster_service_subnet
    }),

    templatefile("${path.module}/resources/templates/machine_kubelet_nodeip_validSubnets.yaml.tmpl", {
      cluster_node_subnet = var.cluster_node_subnet
    }),

    file("${path.module}/resources/files/cluster_coreDNS.yaml"),
    file("${path.module}/resources/files/cluster_proxy.yaml"),
    file("${path.module}/resources/files/longhorn.yaml"),
    file("${path.module}/resources/files/cluster_apiServer_disablePodSecurityPolicy.yaml"),
    file("${path.module}/resources/files/machine_files.yaml"),
  ]

  on_destroy = {
    graceful = var.gracefully_destroy_nodes
    reboot   = true
    reset    = true
  }
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.hosts]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_node
  endpoint             = local.bootstrap_endpoint
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_node
  endpoint             = local.bootstrap_endpoint
}
