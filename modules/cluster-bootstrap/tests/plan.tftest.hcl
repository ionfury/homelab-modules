
run "plan" {
  command = plan
  variables {
    cluster_name = "plan"
    flux_version = "v2.4.0"
    tld          = "tomnowak.work"
    cluster_env_vars = {
      hello = "world"
    }
    kubeconfig = {
      host                   = "host"
      client_certificate     = "client"
      client_key             = "key"
      cluster_ca_certificate = "ca"
    }
    aws = {
      region = "us-east-2"
    }

    github = {
      org             = "ionfury"
      repository      = "homelab"
      repository_path = "kubernetes/clusters"
      token_store     = "/homelab/integration/accounts/github/token"
    }

    cloudflare = {
      account         = "homelab"
      email           = "ionfury@gmail.com"
      api_token_store = "/homelab/integration/accounts/cloudflare/token"
    }

    external_secrets = {
      id_store     = "/homelab/integration/accounts/external-secrets/id"
      secret_store = "/homelab/integration/accounts/external-secrets/secret"
    }

    healthchecksio = {
      api_key_store = "/homelab/integration/accounts/healthchecksio/api-key"
    }
  }
}
