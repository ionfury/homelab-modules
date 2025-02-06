variables {
  cluster_name            = "cluster_name"
  cloudflare_account_name = "homelab"
  cloudflare_email        = "ionfury@gmail.com"
  tld                     = "tomnowak.work"

  github_org                         = "ionfury"
  github_repository                  = "homelab"
  github_repository_path             = ".archive"
  github_token                       = "github_token"
  external_secrets_access_key_id     = "external_secrets_access_key_id"
  external_secrets_access_key_secret = "external_secrets_access_key_secret"
  healthchecksio_api_key             = "healthchecksio_api_key"
}

run "get_secret" {
  module {
    source = "../params-get"
  }

  variables {
    aws = {
      region  = "us-east-2"
      profile = "terragrunt"
    }
    parameters = ["/homelab/cloudflare/api-key", "/homelab/github/ionfury/homelab-flux-dev-token"]
  }
}

run "test" {
  command = plan
  variables {
    cloudflare_api_key = run.get_secret.values["/homelab/cloudflare/api-key"]
    github_token       = run.get_secret.values["/homelab/github/ionfury/homelab-flux-dev-token"]
  }

  assert {
    condition     = cloudflare_record.this.name == "cluster_name.tomnowak.work"
    error_message = "Expected cluster_name.tomnowak.work, got ${cloudflare_record.this.name}"
  }
}
