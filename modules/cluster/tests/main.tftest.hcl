/*
variables {
  cluster_name           = "plan"
  cluster_endpoint       = "cluster_endpoint"
  cluster_vip            = "10.10.10.10"
  cluster_node_subnet    = "10.10.10.10"
  cluster_pod_subnet     = "10.10.10.10"
  cluster_service_subnet = "10.10.10.10"
  cluster_env_vars = {
    "key" = "val"
  }
  cilium_helm_values     = ""
  cilium_version         = "1.16.5"
  kubernetes_version     = "1.32.0"
  talos_version          = "v1.10.0"
  flux_version           = "v2.4.0"
  prometheus_version     = "20.0.0"
  nameservers            = ["10.10.10.10"]
  timeservers            = ["10.10.10.10"]
  talos_config_path      = "~/.talos/testing"
  kubernetes_config_path = "~/.kube/testing"
  tld                    = "tld"
  machines = {
    node44 = {
      type    = "controlplane"
      install = { disk = "/dev/sda" }
      interfaces = [{
        hardwareAddr = "aa:bb:cc:dd:ee:ff"
        addresses    = ["10.10.10.10/24"]
      }]
      labels = [{
        key   = "hello"
        value = "world"
      }]
      annotations = [{
        key   = "hello"
        value = "world"
      }]
      files = [{
        path        = "/var/hello"
        op          = "create"
        permissions = "0o666"
        content     = "hello world"
      }]
    }
  }
  aws = {
    region  = "region"
    profile = "profile"
  }
  unifi = {
    address       = "address"
    site          = "site"
    api_key_store = "api_key_store"
  }
  github = {
    org             = "org"
    repository      = "repository"
    repository_path = "repository_path"
    token_store     = "token_store"
  }
  cloudflare = {
    account       = "account"
    email         = "email"
    api_key_store = "api_key_store"
  }
  external_secrets = {
    id_store     = "id_store"
    secret_store = "secret_store"
  }
  healthchecksio = {
    api_key_store = "api_key_store"
  }
}

mock_provider "aws" {
  alias = "mock"
}

mock_provider "healthchecksio" {
  alias = "mock"
}

mock_provider "github" {
  alias = "mock"
}

mock_provider "cloudflare" {
  alias = "mock"

  mock_data "cloudflare_accounts" {
    defaults = {
      accounts = [{ id = 1 }]
    }
  }
}

mock_provider "unifi" {
  alias = "mock"
}

run "plan" {

  providers = {
    aws            = aws.mock
    healthchecksio = healthchecksio.mock
    github         = github.mock
    cloudflare     = cloudflare.mock
    unifi          = unifi.mock
  }
}
*/
