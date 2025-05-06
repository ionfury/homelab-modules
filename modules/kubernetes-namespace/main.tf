resource "kubernetes_namespace" "this" {
  metadata {
    generate_name = "${var.name}-"
  }

  wait_for_default_service_account = true
}
