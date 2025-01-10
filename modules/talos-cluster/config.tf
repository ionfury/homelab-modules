locals {
  nodes            = [for host_key, host in var.hosts : host_key]
  controlplane_ips = [for host_key, host in var.hosts : host.interfaces[0].addresses[0] if host.role == "controlplane"]
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "this" {
  for_each = var.hosts

  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  machine_type       = each.value.role
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version

  config_patches = [for patch in fileset("${path.module}/resources/talos-patches", "**") :
    templatefile("${path.module}/resources/talos-patches/${patch}", {
      role = each.value.role

      hostname   = each.key
      install    = each.value.install
      interfaces = each.value.interfaces
      disk_image = each.value.install.secureboot ? data.talos_image_factory_urls.host_image_url[each.key].urls.installer_secureboot : data.talos_image_factory_urls.host_image_url[each.key].urls.installer

      cluster_name           = var.cluster_name
      cluster_vip            = var.cluster_vip
      cluster_pod_subnet     = var.cluster_pod_subnet
      cluster_service_subnet = var.cluster_service_subnet
      cluster_node_subnet    = var.cluster_node_subnet

      nameservers            = var.nameservers
      ntp_servers            = var.ntp_servers
      gateway_api_version    = var.gateway_api_version
      prometheus_crd_version = var.prometheus_crd_version
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.controlplane_ips
  nodes                = local.nodes
}
