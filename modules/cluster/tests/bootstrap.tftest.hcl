run "plan" {
  command = plan

  module = "./resources/modules/bootstrap"

  variables {
    cluster_name                       = ""
    flux_version                       = ""
    github_org                         = ""
    github_repository                  = ""
    github_repository_path             = ""
    external_secrets_access_key_id     = ""
    external_secrets_access_key_secret = ""
  }
}
