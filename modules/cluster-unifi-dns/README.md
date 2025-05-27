<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_dns_record.record](https://registry.terraform.io/providers/filipowm/unifi/1.0.0/docs/resources/dns_record) | resource |
| [unifi_user.user](https://registry.terraform.io/providers/filipowm/unifi/1.0.0/docs/resources/user) | resource |
| [aws_ssm_parameter.params_get](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | DNS name to create for the cluster control plane endpoints. | `string` | n/a | yes |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create Unifi records for. | <pre>map(object({<br/>    type = string<br/>    interfaces = list(object({<br/>      hardwareAddr = string<br/>      addresses    = list(string)<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | The Unifi controller to use. | <pre>object({<br/>    address       = string<br/>    site          = string<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->