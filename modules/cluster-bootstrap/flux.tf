locals {
  github_repository_cluster_directory = "${var.github.repository_path}/${var.cluster_name}"
}

data "github_repository" "this" {
  full_name = "${var.github.org}/${var.github.repository}"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [data.github_repository.this]

  version                = var.flux_version
  path                   = local.github_repository_cluster_directory
  kustomization_override = file("${path.module}/resources/kustomization.yaml")
}

resource "github_repository_file" "this" {
  depends_on = [flux_bootstrap_git.this] # https://github.com/fluxcd/terraform-provider-flux/issues/662
  repository = data.github_repository.this.name
  file       = "${local.github_repository_cluster_directory}/generated-cluster-vars.env"
  content = templatefile("${path.module}/resources/generated-cluster-vars.env.tftpl", {
    cluster_vars = var.cluster_env_vars
  })
  overwrite_on_create = true
}
