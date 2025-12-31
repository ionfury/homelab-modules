# networking

This module manages DNS records and DHCP reservations in Unifi for the cluster.

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
| [unifi_user.user](https://registry.terraform.io/providers/filipowm/unifi/1.0.0/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | DNS endpoint for the Kubernetes control plane. | `string` | n/a | yes |
| <a name="input_dhcp_reservations"></a> [dhcp\_reservations](#input\_dhcp\_reservations) | Static DHCP reservations. | <pre>map(object({<br/>    mac = string<br/>    ip  = string<br/>  }))</pre> | n/a | yes |
| <a name="input_dns_records"></a> [dns\_records](#input\_dns\_records) | DNS records to create in Unifi. | <pre>map(object({<br/>    name   = string<br/>    record = string<br/>  }))</pre> | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | The Unifi controller to use. | <pre>object({<br/>    address = string<br/>    site    = string<br/>    api_key = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_plane_url"></a> [control\_plane\_url](#output\_control\_plane\_url) | Full HTTPS URL for the Kubernetes Control Plane |
<!-- END_TF_DOCS -->

