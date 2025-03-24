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
| [unifi_dns_record.record](https://registry.terraform.io/providers/filipowm/unifi/1.0.0/docs/resources/dns_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_unifi_address"></a> [unifi\_address](#input\_unifi\_address) | The address of the Unifi controller. | `string` | n/a | yes |
| <a name="input_unifi_api_key"></a> [unifi\_api\_key](#input\_unifi\_api\_key) | The API key to use for the Unifi controller. | `string` | n/a | yes |
| <a name="input_unifi_dns_records"></a> [unifi\_dns\_records](#input\_unifi\_dns\_records) | List of DNS records to add to the Unifi controller. | <pre>map(object({<br/>    name     = optional(string, null)<br/>    record   = string<br/>    enabled  = optional(bool, true)<br/>    port     = optional(number, null)<br/>    priority = optional(number, null)<br/>    type     = optional(string, "A")<br/>    ttl      = optional(number, 0)<br/>    weight   = optional(number, null)<br/>  }))</pre> | n/a | yes |
| <a name="input_unifi_site"></a> [unifi\_site](#input\_unifi\_site) | The site to use for the Unifi controller. | `string` | `"default"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->