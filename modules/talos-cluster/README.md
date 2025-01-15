# talos-cluster

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
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.machineconf](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.talosconfig](https://registry.terraform.io/providers/hashicorp/local/2.5/docs/resources/sensitive_file) | resource |
| [null_resource.talos_upgrade_trigger](https://registry.terraform.io/providers/hashicorp/null/3.2.3/docs/resources/resource) | resource |
| [talos_cluster_kubeconfig.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/cluster_kubeconfig) | resource |
| [talos_image_factory_schematic.machine_schematic](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/image_factory_schematic) | resource |
| [talos_machine_bootstrap.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_bootstrap) | resource |
| [talos_machine_configuration_apply.machines](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_configuration_apply) | resource |
| [talos_machine_secrets.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/resources/machine_secrets) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/0.12.1/docs/resources/sleep) | resource |
| [helm_template.cilium](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/data-sources/template) | data source |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/client_configuration) | data source |
| [talos_cluster_health.k8s_api_available](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/cluster_health) | data source |
| [talos_cluster_health.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/cluster_health) | data source |
| [talos_image_factory_extensions_versions.machine_version](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_extensions_versions) | data source |
| [talos_image_factory_urls.machine_image_url](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_urls) | data source |
| [talos_machine_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cilium_helm_values"></a> [cilium\_helm\_values](#input\_cilium\_helm\_values) | The values to use for the Cilium Helm chart.<br/>  See: https://github.com/cilium/cilium/blob/main/install/kubernetes/cilium/values.yamln<br/>  And: https://www.talos.dev/v1.9/kubernetes-guides/network/deploying-cilium/#without-kube-proxy | `string` | `""` | no |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | The version of Cilium to use. | `string` | `"1.16.5"` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The endpoint for the Talos cluster. | `string` | `"10.10.10.10"` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | An ID to provide for the Talos cluster. | `number` | `1` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | A name to provide for the Talos cluster. | `string` | `"cluster"` | no |
| <a name="input_cluster_node_subnet"></a> [cluster\_node\_subnet](#input\_cluster\_node\_subnet) | The subnet to use for the Talos cluster nodes. | `string` | `"192.168.10.0/24"` | no |
| <a name="input_cluster_pod_subnet"></a> [cluster\_pod\_subnet](#input\_cluster\_pod\_subnet) | The pod subnet to use for pods on the Talos cluster. | `string` | `"172.16.0.0/16"` | no |
| <a name="input_cluster_service_subnet"></a> [cluster\_service\_subnet](#input\_cluster\_service\_subnet) | The pod subnet to use for services on the Talos cluster. | `string` | `"172.17.0.0/16"` | no |
| <a name="input_cluster_vip"></a> [cluster\_vip](#input\_cluster\_vip) | The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. | `string` | `""` | no |
| <a name="input_extra_manifests"></a> [extra\_manifests](#input\_extra\_manifests) | A list of extra manifests to apply to the Talos cluster.  The following Prometheus CRDs are autoamtically included: [podmonitors, servicemonitors, probes, prometheusrules]. | `list(string)` | `[]` | no |
| <a name="input_gracefully_destroy_nodes"></a> [gracefully\_destroy\_nodes](#input\_gracefully\_destroy\_nodes) | Whether to gracefully destroy nodes. | `bool` | `false` | no |
| <a name="input_machines"></a> [machines](#input\_machines) | A map of current machines from which to build the Talos cluster. | <pre>map(object({<br/>    role = string<br/>    install = object({<br/>      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector<br/>      extraKernelArgs = optional(list(string), [])<br/>      extensions      = optional(list(string), ["iscsi-tools", "util-linux-tools"])<br/>      secureboot      = optional(bool, false)<br/>      wipe            = optional(bool, false)<br/>      architecture    = optional(string, "amd64")<br/>      platform        = optional(string, "metal")<br/>    })<br/>    interfaces = list(object({<br/>      hardwareAddr     = string<br/>      addresses        = list(string)<br/>      dhcp_routeMetric = optional(number, 100)<br/>      vlans = optional(list(object({<br/>        vlanId           = number<br/>        addresses        = list(string)<br/>        dhcp_routeMetric = optional(number, 100)<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_inline_manifests"></a> [inline\_manifests](#input\_inline\_manifests) | A list of inline manifests to apply to the Talos cluster. | <pre>list(object({<br/>    name     = string<br/>    contents = string<br/>  }))</pre> | `[]` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to output the Kubernetes configuration file. | `string` | `"~/.kube"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of kubernetes to deploy. | `string` | `"1.30.1"` | no |
| <a name="input_nameservers"></a> [machine_network_nameservers](#input\_nameservers) | A list of machine_network_nameservers to use for the Talos cluster. | `list(string)` | <pre>[<br/>  "1.1.1.1",<br/>  "1.0.0.1"<br/>]</pre> | no |
| <a name="input_cluster_machine_time_servers"></a> [ntp\_servers](#input\_ntp\_servers) | A list of NTP servers to use for the Talos cluster. | `list(string)` | <pre>[<br/>  "0.pool.ntp.org",<br/>  "1.pool.ntp.org"<br/>]</pre> | no |
| <a name="input_run_talos_upgrade"></a> [run\_talos\_upgrade](#input\_run\_talos\_upgrade) | Weather or not to run `talosctl upgrade`.  This should be set to true only after the cluster has been created. | `bool` | `false` | no |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | `"~/.talos"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | `"v1.8.3"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The timeout to use for the Talos cluster. | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_client_certificate"></a> [kubeconfig\_client\_certificate](#output\_kubeconfig\_client\_certificate) | n/a |
| <a name="output_kubeconfig_client_key"></a> [kubeconfig\_client\_key](#output\_kubeconfig\_client\_key) | n/a |
| <a name="output_kubeconfig_cluster_ca_certificate"></a> [kubeconfig\_cluster\_ca\_certificate](#output\_kubeconfig\_cluster\_ca\_certificate) | n/a |
| <a name="output_kubeconfig_machine"></a> [kubeconfig\_machine](#output\_kubeconfig\_machine) | n/a |
<!-- END_TF_DOCS -->