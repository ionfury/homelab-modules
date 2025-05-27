output "vms" {
  description = "Map of Talos services -> { ip, dns }"
  value = {
    for svc_name, svc in kubernetes_service.this : svc_name => {
      ip  = svc.spec[0].cluster_ip
      dns = "${svc.metadata[0].name}.${svc.metadata[0].namespace}.svc.cluster.local"
    }
  }
}

output "lb" {
  description = "Loadbalancer service for VMs -> { ip, dns}"
  value = {
    ip  = kubernetes_service.lb.spec[0].cluster_ip
    dns = "${kubernetes_service.lb.metadata[0].name}.${kubernetes_service.lb.metadata[0].namespace}.svc.cluster.local"
  }
}
