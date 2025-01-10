provider "helm" {
  kubernetes {
    config_path = local_sensitive_file.kubeconfig.filename
  }
}
