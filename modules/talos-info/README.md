<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_external"></a> [external](#requirement\_external) | 2.3.4 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [external_external.talos_info](https://registry.terraform.io/providers/hashicorp/external/2.3.4/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node"></a> [node](#input\_node) | The node to check. | `string` | n/a | yes |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to the talos config file. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_interfaces"></a> [interfaces](#output\_interfaces) | n/a |
| <a name="output_machine_type"></a> [machine\_type](#output\_machine\_type) | n/a |
| <a name="output_schematic_version"></a> [schematic\_version](#output\_schematic\_version) | n/a |
| <a name="output_talos_info"></a> [talos\_info](#output\_talos\_info) | n/a |
| <a name="output_talos_version"></a> [talos\_version](#output\_talos\_version) | n/a |
<!-- END_TF_DOCS -->