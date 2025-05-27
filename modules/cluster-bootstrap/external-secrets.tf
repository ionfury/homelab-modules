resource "kubernetes_secret" "external_secrets_access_key" {
  metadata {
    name      = "external-secrets-access-key"
    namespace = "kube-system"
  }

  data = {
    access_key        = data.aws_ssm_parameter.params_get[var.external_secrets.id_store].value
    secret_access_key = data.aws_ssm_parameter.params_get[var.external_secrets.secret_store].value
  }
}
