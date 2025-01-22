<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.4.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.35.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.4.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.4.0/docs/resources/bootstrap_git) | resource |
| [kubernetes_secret.external_secrets_access_key](https://registry.terraform.io/providers/hashicorp/kubernetes/2.35.1/docs/resources/secret) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/data-sources/repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_external_secrets_access_key_id"></a> [external\_secrets\_access\_key\_id](#input\_external\_secrets\_access\_key\_id) | AWS access key ID for external-secrets. | `string` | n/a | yes |
| <a name="input_external_secrets_access_key_secret"></a> [external\_secrets\_access\_key\_secret](#input\_external\_secrets\_access\_key\_secret) | AWS secret access key for external-secrets. | `string` | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | Version of Flux to install | `string` | `"v2.4.0"` | no |
| <a name="input_github_org"></a> [github\_org](#input\_github\_org) | Github organization | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | Github repository | `string` | n/a | yes |
| <a name="input_github_repository_path"></a> [github\_repository\_path](#input\_github\_repository\_path) | Path in the Github repository to the cluster configuration | `string` | `"clusters"` | no |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Github token | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | Path to the kubeconfig file | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->