# talos-cluster

This is a generic terraform module for deploying and managing a talos cluster via terraform.  It takes a number of opinionated stances to streamline the lifecycle over using the terraform resources directly.  

* **Explicit [machine](https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.machine) vs [cluster](https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.cluster) config**: The talos config manifest separates the spec into these primary attributes; this module takes in a `talos_cluster_config` of the `cluster` properties, along with a `machines` variable of (primary) type `list(object(talos_config = string))`, along with a number of other properties specifying the installation.
* **Assumed Interfaces**: The module assumes that the primary ip interface for all nodes is at `machines[*].talos_config.network.interfaces[0].addresses[0]`.  Additionally, the same interface on `machines[0]`, where `type == controlplane` will be used for the bootstrap node.
* **Inline helm chart functionality**:  The `inline_manifests` functionality is overridden and populated via `var.bootstrap_charts`.
* **Talos Imagefactory**: `machine.install.image` is automatically populated via the arguments provided in each `machine` variable via integration with [talos image factory](https://factory.talos.dev/).
* **Opinionated Upgrades**: The native terraform module does not yet implement `talos upgrade` functionality.  This is implemented in this module via a `null_resource` provider to execute a script to upgrade each node in order.  This introduces a number of external dependencies on this provider, namely:
  * [flock](https://www.man7.org/linux/man-pages/man2/flock.2.html)
  * [talosctl]()
  * [yq]()

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.17.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.3 |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | 0.7.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.12.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.machineconf](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.talosconfig](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [null_resource.talos_cluster_health](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.talos_cluster_health_upgrade](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [null_resource.talos_upgrade_trigger](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [talos_cluster_kubeconfig.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/cluster_kubeconfig) | resource |
| [talos_image_factory_schematic.machine_schematic](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/image_factory_schematic) | resource |
| [talos_machine_bootstrap.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_bootstrap) | resource |
| [talos_machine_configuration_apply.machines](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_secrets.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_secrets) | resource |
| [helm_template.bootstrap_charts](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/data-sources/template) | data source |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/client_configuration) | data source |
| [talos_image_factory_extensions_versions.machine_version](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_extensions_versions) | data source |
| [talos_image_factory_urls.machine_image_url_metal](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_urls) | data source |
| [talos_image_factory_urls.machine_image_url_sbc](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_urls) | data source |
| [talos_machine_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_charts"></a> [bootstrap\_charts](#input\_bootstrap\_charts) | A list of helm charts to bootstrap into talos via inline\_manifests. | <pre>list(object({<br/>    repository = string<br/>    chart      = string<br/>    name       = string<br/>    version    = string<br/>    namespace  = string<br/>    values     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | The path to output the Kubernetes configuration file. | `string` | `"~/.kube"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of kubernetes to deploy. | `string` | n/a | yes |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create the talos cluster from. | <pre>list(object({<br/>    talos_config      = string # https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.machine<br/>    extensions        = optional(list(string), [])<br/>    extra_kernel_args = optional(list(string), [])<br/>    secureboot        = optional(bool, false)<br/>    architecture      = optional(string, "amd64")<br/>    platform          = optional(string, "metal")<br/>    sbc               = optional(string, "")<br/>  }))</pre> | n/a | yes |
| <a name="input_on_destroy"></a> [on\_destroy](#input\_on\_destroy) | How to preform node destruction | <pre>object({<br/>    graceful = string<br/>    reboot   = string<br/>    reset    = string<br/>  })</pre> | <pre>{<br/>  "graceful": false,<br/>  "reboot": true,<br/>  "reset": true<br/>}</pre> | no |
| <a name="input_talos_cluster_config"></a> [talos\_cluster\_config](#input\_talos\_cluster\_config) | The config for the talos cluster.  This will be applied to each controlplane node. See: https://www.talos.dev/v1.10/reference/configuration/v1alpha1/config/#Config.cluster | `string` | n/a | yes |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | `"~/.talos"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The timeout to use for the Talos cluster. | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_client_certificate"></a> [kubeconfig\_client\_certificate](#output\_kubeconfig\_client\_certificate) | n/a |
| <a name="output_kubeconfig_client_key"></a> [kubeconfig\_client\_key](#output\_kubeconfig\_client\_key) | n/a |
| <a name="output_kubeconfig_cluster_ca_certificate"></a> [kubeconfig\_cluster\_ca\_certificate](#output\_kubeconfig\_cluster\_ca\_certificate) | n/a |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_kubeconfig_host"></a> [kubeconfig\_host](#output\_kubeconfig\_host) | n/a |
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | n/a |
| <a name="output_machineconf_filenames"></a> [machineconf\_filenames](#output\_machineconf\_filenames) | n/a |
| <a name="output_talosconfig_filename"></a> [talosconfig\_filename](#output\_talosconfig\_filename) | n/a |
| <a name="output_talosconfig_raw"></a> [talosconfig\_raw](#output\_talosconfig\_raw) | n/a |
<!-- END_TF_DOCS -->