/*resource "kubernetes_secret" "external_secrets_access_key" {
  depends_on = [kubernetes_namespace.flux_system]
  metadata {
    name      = "external-secrets-access-key"
    namespace = "kube-system"
  }

  data = {
    access_key        = var.external_secrets_access_key_id
    secret_access_key = var.external_secrets_access_key_secret
  }
}
*/
