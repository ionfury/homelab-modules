provider "flux" {
  kubernetes = {
    config_path = var.kubernetes_config_path
  }
  git = {
    url = "https://github.com/${var.github_org}/${var.github_repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = var.github_token
    }
  }
}

provider "kubernetes" {
  config_path = var.kubernetes_config_path
}

provider "github" {
  owner = var.github_org
  token = var.github_token
}
