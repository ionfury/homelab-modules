run "random" {
  module {
    source = "./tests/harness/random"
  }
}
/*
run "test" {
  command = plan

  variables {
    cluster_name           = "cluster_name"
    flux_version           = "flux_version"
    kubernetes_config_path = "kubernetes_config_path"
    github_org             = "org"
    github_repository      = "repository"
    github_token           = "token"
  }
}
*/
