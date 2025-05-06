output "name" {
  value = kubernetes_namespace.this.metadata[0].name
}
