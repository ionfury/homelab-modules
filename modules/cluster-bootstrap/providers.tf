provider "aws" {
  region = var.aws.region
  #profile = var.aws.profile
}

provider "flux" {
  kubernetes = {
    host                   = var.kubeconfig.host
    client_certificate     = var.kubeconfig.client_certificate
    client_key             = var.kubeconfig.client_key
    cluster_ca_certificate = var.kubeconfig.cluster_ca_certificate
  }
  git = {
    url = "https://github.com/${var.github.org}/${var.github.repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = data.aws_ssm_parameter.params_get[var.github.token_store].value
    }
  }
}

provider "kubernetes" {
  host                   = var.kubeconfig.host
  client_certificate     = var.kubeconfig.client_certificate
  client_key             = var.kubeconfig.client_key
  cluster_ca_certificate = var.kubeconfig.cluster_ca_certificate
}

provider "github" {
  owner = var.github.org
  token = data.aws_ssm_parameter.params_get[var.github.token_store].value
}

provider "cloudflare" {
  email     = var.cloudflare.email
  api_token = data.aws_ssm_parameter.params_get[var.cloudflare.api_token_store].value
}

provider "healthchecksio" {
  api_key = data.aws_ssm_parameter.params_get[var.healthchecksio.api_key_store].value
}
