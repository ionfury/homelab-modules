<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_unifi"></a> [unifi](#requirement\_unifi) | 0.41.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_unifi"></a> [unifi](#provider\_unifi) | 0.41.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [unifi_dns_record.record](https://registry.terraform.io/providers/ubiquiti-community/unifi/0.41.2/docs/resources/dns_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_unifi_address"></a> [unifi\_address](#input\_unifi\_address) | The address of the Unifi controller. | `string` | n/a | yes |
| <a name="input_unifi_dns_records"></a> [unifi\_dns\_records](#input\_unifi\_dns\_records) | List of DNS records to add to the Unifi controller. | <pre>map(object({<br/>    name        = optional(string, null)<br/>    value       = string<br/>    enabled     = optional(bool, true)<br/>    port        = optional(number, 0)<br/>    priority    = optional(number, 0)<br/>    record_type = optional(string, "A")<br/>    ttl         = optional(number, 0)<br/>  }))</pre> | n/a | yes |
| <a name="input_unifi_password"></a> [unifi\_password](#input\_unifi\_password) | The password to use for the Unifi controller. | `string` | `null` | no |
| <a name="input_unifi_site"></a> [unifi\_site](#input\_unifi\_site) | The site to use for the Unifi controller. | `string` | `"default"` | no |
| <a name="input_unifi_username"></a> [unifi\_username](#input\_unifi\_username) | The username to use for the Unifi controller. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->