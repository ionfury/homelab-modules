
resource "helm_release" "cilium" {
  # depends_on = [time_sleep.wait]
  depends_on = [data.talos_cluster_health.k8s_api_available]

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  name       = "cilium"
  version    = var.cilium_version
  namespace  = "kube-system"
  values = [
    templatefile("${path.module}/resources/helm-values/cilium.yaml.tftpl", {
      cluster_name       = var.cluster_name
      cluster_id         = var.cluster_id
      cluster_pod_subnet = var.cluster_pod_subnet
    })
  ]
}

resource "helm_release" "spegel" {
  depends_on = [helm_release.cilium]

  chart     = "oci://ghcr.io/spegel-org/helm-charts/spegel"
  name      = "spegal"
  version   = var.spegal_version
  namespace = "kube-system"
  values = [
    file("${path.module}/resources/helm-values/spegal.yaml"),
  ]
}
