<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.talos_cluster_health](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.talos_cluster_health_upgrade](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.talos_upgrade_trigger](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_machine_schematic_id"></a> [machine\_schematic\_id](#input\_machine\_schematic\_id) | n/a | `map(string)` | n/a | yes |
| <a name="input_machine_talos_version"></a> [machine\_talos\_version](#input\_machine\_talos\_version) | n/a | `map(string)` | n/a | yes |
| <a name="input_machines"></a> [machines](#input\_machines) | n/a | `map(any)` | n/a | yes |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | n/a | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->