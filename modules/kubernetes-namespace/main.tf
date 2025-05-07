resource "kubernetes_namespace" "this" {
  metadata {
    generate_name = "${var.name}-"
  }

  wait_for_default_service_account = true
}

resource "null_resource" "wait_2_seconds" {
  depends_on = [kubernetes_namespace.this]

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

data "kubernetes_namespace" "this" {
  metadata {
    name = kubernetes_namespace.this.metadata[0].name
  }
}
