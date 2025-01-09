<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | 0.41.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 0.41.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_dns_record.record](https://registry.terraform.io/providers/ubiquiti-community/unifi/0.41.2/docs/resources/dns_record) | resource |
| [aws_ssm_parameter.unifi_password](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.unifi_username](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | AWS account information. | <pre>object({<br/>    region  = string<br/>    profile = string<br/>  })</pre> | <pre>{<br/>  "profile": "terragrunt",<br/>  "region": "us-east-2"<br/>}</pre> | no |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | Unifi controller information | <pre>object({<br/>    address        = string<br/>    username_store = string<br/>    password_store = string<br/>    site           = string<br/>  })</pre> | <pre>{<br/>  "address": "https://192.168.1.1",<br/>  "password_store": "/homelab/unifi/terraform/password",<br/>  "site": "default",<br/>  "username_store": "/homelab/unifi/terraform/username"<br/>}</pre> | no |
| <a name="input_unifi_dns_records"></a> [unifi\_dns\_records](#input\_unifi\_dns\_records) | List of DNS records to add to the Unifi controller. | <pre>map(object({<br/>    name        = optional(string, null)<br/>    value       = string<br/>    enabled     = optional(bool, true)<br/>    port        = optional(number, 0)<br/>    priority    = optional(number, 0)<br/>    record_type = optional(string, "A")<br/>    ttl         = optional(number, 0)<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->