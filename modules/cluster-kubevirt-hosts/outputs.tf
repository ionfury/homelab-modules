output "vmi" {
  description = "KubeVirt VirtualMachineInstances -> { ip, dns }"
  value = {
    for vmi_name, vmi in data.kubernetes_resource.talos_vmi : vmi_name => {
      ip  = vmi.object.status[0].interfaces[0].ip_address
      dns = "${vmi.metadata[0].name}.${vmi.metadata[0].namespace}.svc.cluster.local"
      mac = vmi.object.status[0].interfaces[0].mac
    }
  }
}

output "svc" {
  description = "Kubernetes services -> { ip, dns }"
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
