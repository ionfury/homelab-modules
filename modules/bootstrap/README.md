## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=4.62.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.0.1 |
| <a name="requirement_healthchecksio"></a> [healthchecksio](#requirement\_healthchecksio) | >=1.10.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.25.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.0.1 |
| <a name="provider_healthchecksio"></a> [healthchecksio](#provider\_healthchecksio) | >=1.10.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.25.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.0.1/docs/resources/bootstrap_git) | resource |
| [healthchecksio_check.cluster_heartbeat](https://registry.terraform.io/providers/kristofferahl/healthchecksio/latest/docs/resources/check) | resource |
| [kubernetes_namespace.flux_system](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/namespace) | resource |
| [kubernetes_secret.access_key](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/secret) | resource |
| [kubernetes_secret.ssh_key](https://registry.terraform.io/providers/hashicorp/kubernetes/2.25.2/docs/resources/secret) | resource |
| [healthchecksio_channel.discord](https://registry.terraform.io/providers/kristofferahl/healthchecksio/latest/docs/data-sources/channel) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster. | `string` | n/a | yes |
| <a name="input_external_secrets_access_key_id"></a> [external\_secrets\_access\_key\_id](#input\_external\_secrets\_access\_key\_id) | n/a | `string` | n/a | yes |
| <a name="input_external_secrets_access_key_secret"></a> [external\_secrets\_access\_key\_secret](#input\_external\_secrets\_access\_key\_secret) | n/a | `string` | n/a | yes |
| <a name="input_github_ssh_key"></a> [github\_ssh\_key](#input\_github\_ssh\_key) | SSH key for accessing github\_url. | `string` | n/a | yes |
| <a name="input_github_ssh_pub"></a> [github\_ssh\_pub](#input\_github\_ssh\_pub) | SSH Pub for github\_ssh\_key. | `string` | n/a | yes |
| <a name="input_known_hosts"></a> [known\_hosts](#input\_known\_hosts) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_heartbeat_url"></a> [heartbeat\_url](#output\_heartbeat\_url) | n/a |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.4.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.4.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.4.0/docs/resources/bootstrap_git) | resource |
| [aws_ssm_parameter.github_token](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS account information. | <pre>object({<br/>    region  = string<br/>    profile = string<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | Version of Flux to install | `string` | `"v2.4.0"` | no |
| <a name="input_github"></a> [github](#input\_github) | Github account information. | <pre>object({<br/>    org         = string<br/>    repository  = string<br/>    token_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_kubernetes_config_file_path"></a> [kubernetes\_config\_file\_path](#input\_kubernetes\_config\_file\_path) | Path to the kubeconfig file | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->