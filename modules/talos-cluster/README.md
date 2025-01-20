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
| [helm_template.cilium](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/data-sources/template) | data source |
| [talos_client_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/client_configuration) | data source |
| [talos_cluster_health.k8s_api_available](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/cluster_health) | data source |
| [talos_cluster_health.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/cluster_health) | data source |
| [talos_cluster_health.upgrade](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/cluster_health) | data source |
| [talos_image_factory_extensions_versions.machine_version](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_extensions_versions) | data source |
| [talos_image_factory_urls.machine_image_url](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/image_factory_urls) | data source |
| [talos_machine_configuration.this](https://registry.terraform.io/providers/siderolabs/talos/0.7.0/docs/data-sources/machine_configuration) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cilium_helm_values"></a> [cilium\_helm\_values](#input\_cilium\_helm\_values) | The values to use for the Cilium Helm chart.<br/>  See: https://github.com/cilium/cilium/blob/main/install/kubernetes/cilium/values.yamln<br/>  And: https://www.talos.dev/v1.9/kubernetes-guides/network/deploying-cilium/#without-kube-proxy | `string` | `"ipam:\n  mode: kubernetes\nkubeProxyReplacement: true\ncgroup:\n  autoMount:\n    enabled: false\n  hostRoot: /sys/fs/cgroup\nk8sServiceHost: 127.0.0.1\nk8sServicePort: 7445\nsecurityContext:\n  capabilities:\n    ciliumAgent:\n      - CHOWN\n      - KILL\n      - NET_ADMIN\n      - NET_RAW\n      - IPC_LOCK\n      - SYS_ADMIN\n      - SYS_RESOURCE\n      - PERFMON\n      - BPF\n      - DAC_OVERRIDE\n      - FOWNER\n      - SETGID\n      - SETUID\n    cleanCiliumState:\n      - NET_ADMIN\n      - SYS_ADMIN\n      - SYS_RESOURCE\n"` | no |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | The version of Cilium to use. | `string` | `"1.16.5"` | no |
| <a name="input_cluster_allowSchedulingOnControlPlanes"></a> [cluster\_allowSchedulingOnControlPlanes](#input\_cluster\_allowSchedulingOnControlPlanes) | Whether to allow scheduling on control plane nodes. | `bool` | `true` | no |
| <a name="input_cluster_coreDNS_disabled"></a> [cluster\_coreDNS\_disabled](#input\_cluster\_coreDNS\_disabled) | Whether to disable CoreDNS. | `bool` | `false` | no |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The endpoint for the Talos cluster. | `string` | `"10.10.10.10"` | no |
| <a name="input_cluster_extraManifests"></a> [cluster\_extraManifests](#input\_cluster\_extraManifests) | A list of extra manifests to apply to the Talos cluster.  The following Prometheus CRDs are autoamtically included: [podmonitors, servicemonitors, probes, prometheusrules]. | `list(string)` | `[]` | no |
| <a name="input_cluster_inlineManifests"></a> [cluster\_inlineManifests](#input\_cluster\_inlineManifests) | A list of inline manifests to apply to the Talos cluster. | <pre>list(object({<br/>    name     = string<br/>    contents = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | A name to provide for the Talos cluster. | `string` | `"cluster"` | no |
| <a name="input_cluster_node_subnet"></a> [cluster\_node\_subnet](#input\_cluster\_node\_subnet) | The subnet to use for the Talos cluster nodes. | `string` | `"192.168.10.0/24"` | no |
| <a name="input_cluster_pod_subnet"></a> [cluster\_pod\_subnet](#input\_cluster\_pod\_subnet) | The pod subnet to use for pods on the Talos cluster. | `string` | `"172.16.0.0/16"` | no |
| <a name="input_cluster_proxy_disabled"></a> [cluster\_proxy\_disabled](#input\_cluster\_proxy\_disabled) | Whether to disable the kube-proxy. | `bool` | `true` | no |
| <a name="input_cluster_service_subnet"></a> [cluster\_service\_subnet](#input\_cluster\_service\_subnet) | The pod subnet to use for services on the Talos cluster. | `string` | `"172.17.0.0/16"` | no |
| <a name="input_cluster_vip"></a> [cluster\_vip](#input\_cluster\_vip) | The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. | `string` | `""` | no |
| <a name="input_gracefully_destroy_nodes"></a> [gracefully\_destroy\_nodes](#input\_gracefully\_destroy\_nodes) | Whether to gracefully destroy nodes. | `bool` | `false` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to output the Kubernetes configuration file. | `string` | `"~/.kube"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of kubernetes to deploy. | `string` | `"1.30.1"` | no |
| <a name="input_machine_extensions"></a> [machine\_extensions](#input\_machine\_extensions) | A list of extensions to add to all machines in the cluster. | `list(string)` | `[]` | no |
| <a name="input_machine_extra_kernel_args"></a> [machine\_extra\_kernel\_args](#input\_machine\_extra\_kernel\_args) | A list of extra kernel arguments to add to the machines. | `list(string)` | `[]` | no |
| <a name="input_machine_files"></a> [machine\_files](#input\_machine\_files) | A list of files to add to all machines in the cluster. See: https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.files. | <pre>list(object({<br/>    content     = string<br/>    permissions = string<br/>    path        = string<br/>    op          = string<br/>  }))</pre> | `[]` | no |
| <a name="input_machine_kubelet_extraMounts"></a> [machine\_kubelet\_extraMounts](#input\_machine\_kubelet\_extraMounts) | A list of extra mounts to add to the kubelet. | <pre>list(object({<br/>    destination = string<br/>    type        = string<br/>    source      = string<br/>    options     = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_machine_network_nameservers"></a> [machine\_network\_nameservers](#input\_machine\_network\_nameservers) | A list of nameservers to use for the Talos cluster. | `list(string)` | <pre>[<br/>  "1.1.1.1",<br/>  "1.0.0.1"<br/>]</pre> | no |
| <a name="input_machine_time_servers"></a> [machine\_time\_servers](#input\_machine\_time\_servers) | A list of NTP servers to use for the Talos cluster. | `list(string)` | <pre>[<br/>  "0.pool.ntp.org",<br/>  "1.pool.ntp.org"<br/>]</pre> | no |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create the talos cluster from. | <pre>map(object({<br/>    type           = string<br/>    first_scale_in = optional(bool, false) # Must be set to 'true' when adding a new node to an existing cluster.  Set to 'false' once the node is in the cluster. https://github.com/siderolabs/terraform-provider-talos/issues/221<br/>    install = object({<br/>      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector<br/>      extraKernelArgs = optional(list(string), [])<br/>      extensions      = optional(list(string), [])<br/>      secureboot      = optional(bool, false)<br/>      wipe            = optional(bool, false)<br/>      architecture    = optional(string, "amd64")<br/>      platform        = optional(string, "metal")<br/>    })<br/>    files = optional(list(object({<br/>      content     = string<br/>      permissions = string<br/>      path        = string<br/>      op          = string<br/>    })), [])<br/>    interfaces = list(object({<br/>      hardwareAddr     = string<br/>      addresses        = list(string)<br/>      dhcp_routeMetric = optional(number, 100)<br/>      vlans = optional(list(object({<br/>        vlanId           = number<br/>        addresses        = list(string)<br/>        dhcp_routeMetric = optional(number, 100)<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_stage_talos_upgrade"></a> [stage\_talos\_upgrade](#input\_stage\_talos\_upgrade) | Weather or not to stage talos upgrades.  If this is set to false, the upgrade will be applied immediately and node will reboot. | `bool` | `false` | no |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | `"~/.talos"` | no |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | `"v1.9.0"` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The timeout to use for the Talos cluster. | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_client_certificate"></a> [kubeconfig\_client\_certificate](#output\_kubeconfig\_client\_certificate) | n/a |
| <a name="output_kubeconfig_client_key"></a> [kubeconfig\_client\_key](#output\_kubeconfig\_client\_key) | n/a |
| <a name="output_kubeconfig_cluster_ca_certificate"></a> [kubeconfig\_cluster\_ca\_certificate](#output\_kubeconfig\_cluster\_ca\_certificate) | n/a |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_kubeconfig_host"></a> [kubeconfig\_host](#output\_kubeconfig\_host) | n/a |
| <a name="output_machineconf_filenames"></a> [machineconf\_filenames](#output\_machineconf\_filenames) | n/a |
| <a name="output_talosconfig_filename"></a> [talosconfig\_filename](#output\_talosconfig\_filename) | n/a |
<!-- END_TF_DOCS -->