resource "helm_release" "prometheus_crds" {
  depends_on = [data.talos_cluster_health.available]

  chart   = "oci://ghcr.io/prometheus-community/charts/prometheus-operator-crds"
  name    = "kube-prometheus-stack-crds"
  version = var.prometheus_crd_version
}

resource "helm_release" "cilium" {
  depends_on = [helm_release.prometheus_crds]

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  name       = "cilium"
  version    = var.cilium_version
  namespace  = "kube-system"
  values = [
    templatefile("${path.module}/resources/templates/cilium.yaml.tmpl", {
      cluster_name           = var.cluster_name
      cluster_id             = var.cluster_id
      cluster_pod_subnet     = var.cluster_pod_subnet
      cluster_service_subnet = var.cluster_service_subnet
    })
  ]
}

resource "helm_release" "spegel" {
  depends_on = [helm_release.prometheus_crds, helm_release.cilium]

  chart     = "oci://ghcr.io/spegel-org/helm-charts/spegel"
  name      = "spegal"
  version   = var.spegal_version
  namespace = "kube-system"
  values = [
    file("${path.module}/resources/files/spegal.yaml"),
  ]
}

