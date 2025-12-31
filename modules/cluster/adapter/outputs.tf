output "machines" {
  description = "Adapted machines with feature transformations applied (for testing and inspection)."
  value       = local.machines
}

output "runtime_machines" {
  description = "Machines transformed for runtime consumption (cluster-talos shape)."
  value       = local.runtime_machines
}

output "dns_records" {
  value = {
    for name, m in local.machines :
    name => {
      name   = local.dns_name
      record = m.primary_ip
    }
    if m.type == "controlplane"
  }
}

output "dhcp_reservations" {
  value = {
    for name, m in local.machines :
    name => {
      mac = m.primary_mac
      ip  = m.primary_ip
    }
  }
}

output "cluster_endpoint" {
  description = "DNS endpoint for the Kubernetes control plane."
  value       = local.dns_name
}

output "talos_cluster_config" {
  description = "Rendered Talos cluster configuration YAML."
  value = templatefile("${path.module}/../resources/templates/talos_cluster.yaml.tftpl", {
    cluster_endpoint                  = local.cluster_endpoint
    cluster_name                      = var.name
    cluster_pod_subnet               = var.networking.pod_subnet
    cluster_service_subnet            = var.networking.service_subnet
    cluster_controllerManager_extraArgs = var.controllerManager_extraArgs
    cluster_scheduler_extraArgs      = var.scheduler_extraArgs
    cluster_etcd_extraArgs           = var.etcd_extraArgs
    cluster_extraManifests            = local.extra_manifests
  })
}

output "bootstrap_charts" {
  description = "Helm charts to bootstrap during Talos cluster creation."
  value       = []
}

output "cluster_env_vars" {
  description = "Environment variables passed into cluster bootstrap."
  value       = var.env_vars
}
