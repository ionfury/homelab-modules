<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.38.0 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.talos_vm](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/manifest) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/namespace) | resource |
| [kubernetes_service.lb](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/service) | resource |
| [kubernetes_service.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/resources/service) | resource |
| [talos_image_factory_schematic.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/image_factory_schematic) | resource |
| [kubernetes_resource.talos_vmi](https://registry.terraform.io/providers/hashicorp/kubernetes/2.38.0/docs/data-sources/resource) | data source |
| [talos_image_factory_urls.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_urls) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cores"></a> [cores](#input\_cores) | Number of cores to allocate to each VM. | `number` | `2` | no |
| <a name="input_data_disk_size"></a> [data\_disk\_size](#input\_data\_disk\_size) | Size of the data diskof each VM. | `string` | `"10G"` | no |
| <a name="input_data_disk_storage_class"></a> [data\_disk\_storage\_class](#input\_data\_disk\_storage\_class) | Storage class to use for the data disk of each VM. | `string` | n/a | yes |
| <a name="input_data_root_size"></a> [data\_root\_size](#input\_data\_root\_size) | Size of the root diskof each VM. | `string` | `"10G"` | no |
| <a name="input_data_root_storage_class"></a> [data\_root\_storage\_class](#input\_data\_root\_storage\_class) | Storage class to use for root diskof each VM. | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount of memory to allocate to each VM. | `string` | `"2G"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to use for the VMs and Namespace. | `string` | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Version of talos to run. | `string` | n/a | yes |
| <a name="input_vm_count"></a> [vm\_count](#input\_vm\_count) | Number of VMs to create in the namespace. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb"></a> [lb](#output\_lb) | Loadbalancer service for VMs -> { ip, dns} |
| <a name="output_svc"></a> [svc](#output\_svc) | Kubernetes services -> { ip, dns } |
| <a name="output_vmi"></a> [vmi](#output\_vmi) | KubeVirt VirtualMachineInstances -> { ip, dns } |
<!-- END_TF_DOCS -->