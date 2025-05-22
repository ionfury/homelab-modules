provider "aws" {
  region  = var.aws.region
  profile = var.aws.profile
}

provider "unifi" {
  api_url        = var.unifi.address
  api_key        = data.aws_ssm_parameter.params_get[var.unifi.api_key_store].value
  username       = ""
  password       = ""
  allow_insecure = true
  site           = var.unifi.site
}

provider "flux" {
  kubernetes = {
    host                   = module.talos_cluster.kubeconfig_host
    client_certificate     = module.talos_cluster.kubeconfig_client_certificate
    client_key             = module.talos_cluster.kubeconfig_client_key
    cluster_ca_certificate = module.talos_cluster.kubeconfig_cluster_ca_certificate
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
  host                   = module.talos_cluster.kubeconfig_host
  client_certificate     = module.talos_cluster.kubeconfig_client_certificate
  client_key             = module.talos_cluster.kubeconfig_client_key
  cluster_ca_certificate = module.talos_cluster.kubeconfig_cluster_ca_certificate
}

provider "github" {
  owner = var.github.org
  token = data.aws_ssm_parameter.params_get[var.github.token_store].value
}

provider "cloudflare" {
  email   = var.cloudflare.email
  api_key = data.aws_ssm_parameter.params_get[var.cloudflare.api_key_store].value
}

provider "healthchecksio" {
  api_key = data.aws_ssm_parameter.params_get[var.healthchecksio.api_key_store].value
}
