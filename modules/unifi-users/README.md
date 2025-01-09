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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | 0.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 0.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_user.user](https://registry.terraform.io/providers/paultyng/unifi/0.41.0/docs/resources/user) | resource |
| [aws_ssm_parameter.unifi_password](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.unifi_username](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS account information. | <pre>object({<br/>    region  = string<br/>    profile = string<br/>  })</pre> | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | Unifi controller information | <pre>object({<br/>    address        = string<br/>    username_store = string<br/>    password_store = string<br/>    site           = string<br/>  })</pre> | n/a | yes |
| <a name="input_unifi_users"></a> [unifi\_users](#input\_unifi\_users) | List of users to add to the Unifi controller. | <pre>map(object({<br/>    ip  = string<br/>    mac = string<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->