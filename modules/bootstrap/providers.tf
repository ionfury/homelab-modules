provider "aws" {
  region  = var.aws.region
  profile = var.aws.profile
}

data "aws_ssm_parameter" "github_token" {
  name = var.github.token_store
}

provider "flux" {
  kubernetes = {
    config_path = var.kubernetes_config_file_path
  }
  git = {
    url = "https://github.com/${var.github.org}/${var.github.repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = data.aws_ssm_parameter.github_token.value
    }
  }
}

provider "github" {
  owner = var.github.org
  token = data.aws_ssm_parameter.github_token.value
}
