data "github_repository" "this" {
  full_name = "${var.github_org}/${var.github_repository}"
}

resource "flux_bootstrap_git" "this" {
  depends_on = [data.github_repository.this]

  version                = var.flux_version
  path                   = "${var.github_repository_path}/${var.cluster_name}"
  kustomization_override = file("${path.module}/resources/kustomization.yaml")
}
