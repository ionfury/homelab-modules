locals {
  nodes            = [for machine_key, machine in var.machines : machine_key]
  controlplane_ips = [for machine_key, machine in var.machines : machine.interfaces[0].addresses[0] if machine.type == "controlplane"]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "this" {
  for_each = var.machines

  cluster_name       = var.cluster_name
  cluster_endpoint   = "https://${var.cluster_endpoint}:6443"
  machine_type       = each.value.type
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version

  config_patches = [for patch in fileset("${path.module}/resources/talos-patches", "**") :
    templatefile("${path.module}/resources/talos-patches/${patch}", {
      type = each.value.type

      machine_network_hostname    = each.key
      machine_network_interfaces  = each.value.interfaces
      machine_install             = each.value.install
      machine_install_disk_image  = each.value.install.secureboot ? data.talos_image_factory_urls.machine_image_url[each.key].urls.installer_secureboot : data.talos_image_factory_urls.machine_image_url[each.key].urls.installer
      machine_install_files       = concat(each.value.files, var.machine_files)
      machine_disks               = each.value.disks
      machine_network_nameservers = var.machine_network_nameservers
      machine_time_servers        = var.machine_time_servers
      machine_kubelet_extraMounts = var.machine_kubelet_extraMounts
      machine_extra_kernel_args   = var.machine_extra_kernel_args
      machine_extensions          = var.machine_extensions
      machine_annotations         = each.value.annotations
      machine_labels              = each.value.labels

      cluster_name                           = var.cluster_name
      cluster_vip                            = var.cluster_vip
      cluster_pod_subnet                     = var.cluster_pod_subnet
      cluster_service_subnet                 = var.cluster_service_subnet
      cluster_node_subnet                    = var.cluster_node_subnet
      cluster_proxy_disabled                 = var.cluster_proxy_disabled
      cluster_allowSchedulingOnControlPlanes = var.cluster_allowSchedulingOnControlPlanes
      cluster_coreDNS_disabled               = var.cluster_coreDNS_disabled
      cluster_extraManifests                 = var.cluster_extraManifests
      cluster_inlineManifests                = var.cluster_inlineManifests
      cluster_etcd_extraArgs                 = var.cluster_etcd_extraArgs

      cilium_manifest = data.helm_template.cilium.manifest
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.controlplane_ips
  nodes                = local.nodes
}
