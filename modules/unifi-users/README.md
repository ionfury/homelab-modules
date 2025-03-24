## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.80.0 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | ~>0.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>5.80.0 |
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | ~>0.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_user.user](https://registry.terraform.io/providers/paultyng/unifi/latest/docs/resources/user) | resource |
| [aws_ssm_parameter.unifi_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.unifi_username](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS account information. | <pre>object({<br>    region  = string<br>    profile = string<br>  })</pre> | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | Unifi controller information | <pre>object({<br>    address        = string<br>    username_store = string<br>    password_store = string<br>    site           = string<br>  })</pre> | n/a | yes |
| <a name="input_unifi_users"></a> [unifi\_users](#input\_unifi\_users) | List of users to add to the Unifi controller. | <pre>map(object({<br>    ip  = string<br>    mac = string<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_user.user](https://registry.terraform.io/providers/filipowm/unifi/1.0.0/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_unifi_address"></a> [unifi\_address](#input\_unifi\_address) | The address of the Unifi controller. | `string` | n/a | yes |
| <a name="input_unifi_api_key"></a> [unifi\_api\_key](#input\_unifi\_api\_key) | The API key to use for the Unifi controller. | `string` | n/a | yes |
| <a name="input_unifi_site"></a> [unifi\_site](#input\_unifi\_site) | The site to use for the Unifi controller. | `string` | `"default"` | no |
| <a name="input_unifi_users"></a> [unifi\_users](#input\_unifi\_users) | List of users to add to the Unifi controller. | <pre>map(object({<br/>    mac = string<br/>    ip  = string<br/><br/>    allow_existing         = optional(bool, true)<br/>    blocked                = optional(bool, null)<br/>    local_dns_record       = optional(bool, null)<br/>    network_id             = optional(string, null)<br/>    skip_forget_on_destroy = optional(bool, false)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->