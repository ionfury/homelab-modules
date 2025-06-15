<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | 5.5.0 |
| <a name="requirement_flux"></a> [flux](#requirement\_flux) | 1.6.1 |
| <a name="requirement_github"></a> [github](#requirement\_github) | 6.4.0 |
| <a name="requirement_healthchecksio"></a> [healthchecksio](#requirement\_healthchecksio) | 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.36.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 5.5.0 |
| <a name="provider_flux"></a> [flux](#provider\_flux) | 1.6.1 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.4.0 |
| <a name="provider_healthchecksio"></a> [healthchecksio](#provider\_healthchecksio) | 2.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.ingress](https://registry.terraform.io/providers/cloudflare/cloudflare/5.5.0/docs/resources/dns_record) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.5.0/docs/resources/zero_trust_tunnel_cloudflared) | resource |
| [flux_bootstrap_git.this](https://registry.terraform.io/providers/fluxcd/flux/1.6.1/docs/resources/bootstrap_git) | resource |
| [github_repository_file.this](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/resources/repository_file) | resource |
| [healthchecksio_check.this](https://registry.terraform.io/providers/kristofferahl/healthchecksio/2.0.0/docs/resources/check) | resource |
| [kubernetes_secret.cloudflare_tunnel_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret) | resource |
| [kubernetes_secret.external_secrets_access_key](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret) | resource |
| [kubernetes_secret.healthchecksio_pingurl](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/secret) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/password) | resource |
| [cloudflare_accounts.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.5.0/docs/data-sources/accounts) | data source |
| [cloudflare_zero_trust_tunnel_cloudflared_token.this](https://registry.terraform.io/providers/cloudflare/cloudflare/5.5.0/docs/data-sources/zero_trust_tunnel_cloudflared_token) | data source |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/6.4.0/docs/data-sources/repository) | data source |
| [healthchecksio_channel.this](https://registry.terraform.io/providers/kristofferahl/healthchecksio/2.0.0/docs/data-sources/channel) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflare"></a> [cloudflare](#input\_cloudflare) | The Cloudflare account to use. | <pre>object({<br/>    account   = string<br/>    email     = string<br/>    api_token = string<br/>    zone_id   = string<br/>  })</pre> | n/a | yes |
| <a name="input_cloudflare_tunnel_secret_annotations"></a> [cloudflare\_tunnel\_secret\_annotations](#input\_cloudflare\_tunnel\_secret\_annotations) | Annotations to add to the secret for the Cloudflare Tunnel. For https://github.com/mittwald/kubernetes-replicator?tab=readme-ov-file#pull-based-replication | `map(string)` | <pre>{<br/>  "replicator.v1.mittwald.de/replication-allowed": "true",<br/>  "replicator.v1.mittwald.de/replication-allowed-namespaces": "network"<br/>}</pre> | no |
| <a name="input_cluster_env_vars"></a> [cluster\_env\_vars](#input\_cluster\_env\_vars) | Environment variables to add to the cluster git repository root directory, to be consumed by flux. See: https://fluxcd.io/flux/components/kustomize/kustomizations/#post-build-variable-substitution | `map(string)` | `{}` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | The external secret store. | <pre>object({<br/>    id     = string<br/>    secret = string<br/>  })</pre> | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | Version of Flux to install | `string` | `"v2.4.0"` | no |
| <a name="input_github"></a> [github](#input\_github) | The GitHub repository to use. | <pre>object({<br/>    org             = string<br/>    repository      = string<br/>    repository_path = string<br/>    token           = string<br/>  })</pre> | n/a | yes |
| <a name="input_healthchecksio"></a> [healthchecksio](#input\_healthchecksio) | The healthchecks.io account to use. | <pre>object({<br/>    api_key = string<br/>  })</pre> | n/a | yes |
| <a name="input_healthchecksio_replication_allowed_namespaces"></a> [healthchecksio\_replication\_allowed\_namespaces](#input\_healthchecksio\_replication\_allowed\_namespaces) | Namespaces to allow replication for healthchecks.io.  See: https://github.com/mittwald/kubernetes-replicator?tab=readme-ov-file#pull-based-replication | `string` | `"monitoring"` | no |
| <a name="input_kubeconfig"></a> [kubeconfig](#input\_kubeconfig) | Credentials to access kubernetes cluster | <pre>object({<br/>    host                   = string<br/>    client_certificate     = string<br/>    client_key             = string<br/>    cluster_ca_certificate = string<br/>  })</pre> | n/a | yes |
| <a name="input_tld"></a> [tld](#input\_tld) | The top-level domain to use for the Cloudflare Tunnel | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tunnel_account_id"></a> [tunnel\_account\_id](#output\_tunnel\_account\_id) | n/a |
| <a name="output_tunnel_id"></a> [tunnel\_id](#output\_tunnel\_id) | n/a |
| <a name="output_tunnel_info_json"></a> [tunnel\_info\_json](#output\_tunnel\_info\_json) | n/a |
| <a name="output_tunnel_secret"></a> [tunnel\_secret](#output\_tunnel\_secret) | n/a |
| <a name="output_tunnel_token"></a> [tunnel\_token](#output\_tunnel\_token) | n/a |
<!-- END_TF_DOCS -->