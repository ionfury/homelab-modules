<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_bootstrap"></a> [cluster\_bootstrap](#module\_cluster\_bootstrap) | ../cluster-bootstrap | n/a |
| <a name="module_cluster_talos"></a> [cluster\_talos](#module\_cluster\_talos) | ../cluster-talos | n/a |
| <a name="module_cluster_unifi_dns"></a> [cluster\_unifi\_dns](#module\_cluster\_unifi\_dns) | ../cluster-unifi-dns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.params_put](https://registry.terraform.io/providers/hashicorp/aws/6.1.0/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.params_get](https://registry.terraform.io/providers/hashicorp/aws/6.1.0/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cilium_helm_values"></a> [cilium\_helm\_values](#input\_cilium\_helm\_values) | The Helm values to use for Cilium. | `string` | n/a | yes |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | The version of Cilium to use. | `string` | n/a | yes |
| <a name="input_cloudflare"></a> [cloudflare](#input\_cloudflare) | The Cloudflare account to use. | <pre>object({<br/>    account         = string<br/>    email           = string<br/>    api_token_store = string<br/>    zone_id         = optional(string, "799905ff93d585a9a0633949275cbf98")<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_controllerManager_extraArgs"></a> [cluster\_controllerManager\_extraArgs](#input\_cluster\_controllerManager\_extraArgs) | List of key value pairs to pass to the controller manager service. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_env_vars"></a> [cluster\_env\_vars](#input\_cluster\_env\_vars) | List of key value pairs to pass to cluster via the generated-cluster-vars.env. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_etcd_extraArgs"></a> [cluster\_etcd\_extraArgs](#input\_cluster\_etcd\_extraArgs) | List of key value pairs to pass to the etcd service. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | A name to provide for the cluster. | `string` | n/a | yes |
| <a name="input_cluster_node_subnet"></a> [cluster\_node\_subnet](#input\_cluster\_node\_subnet) | The subnet to use for the Talos cluster nodes. Format: 10.10.10.10/16 | `string` | n/a | yes |
| <a name="input_cluster_on_destroy"></a> [cluster\_on\_destroy](#input\_cluster\_on\_destroy) | How to preform node destruction | <pre>object({<br/>    graceful = string<br/>    reboot   = string<br/>    reset    = string<br/>  })</pre> | <pre>{<br/>  "graceful": false,<br/>  "reboot": true,<br/>  "reset": true<br/>}</pre> | no |
| <a name="input_cluster_pod_subnet"></a> [cluster\_pod\_subnet](#input\_cluster\_pod\_subnet) | The pod subnet to use for pods on the Talos cluster. Format: 10.10.10.10/16 | `string` | n/a | yes |
| <a name="input_cluster_scheduler_extraArgs"></a> [cluster\_scheduler\_extraArgs](#input\_cluster\_scheduler\_extraArgs) | List of key value pairs to pass to the scheduler service. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_service_subnet"></a> [cluster\_service\_subnet](#input\_cluster\_service\_subnet) | The pod subnet to use for services on the Talos cluster. Format: 10.10.10.10/16 | `string` | n/a | yes |
| <a name="input_cluster_tld"></a> [cluster\_tld](#input\_cluster\_tld) | A tld for the cluster. Format: asdf.com | `string` | n/a | yes |
| <a name="input_cluster_vip"></a> [cluster\_vip](#input\_cluster\_vip) | The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. Format: 10.10.10.10 | `string` | n/a | yes |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | The external secret store. | <pre>object({<br/>    id_store     = string<br/>    secret_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | The version of Flux to use. | `string` | n/a | yes |
| <a name="input_github"></a> [github](#input\_github) | The GitHub repository to use. | <pre>object({<br/>    org             = string<br/>    repository      = string<br/>    repository_path = string<br/>    token_store     = string<br/>  })</pre> | n/a | yes |
| <a name="input_healthchecksio"></a> [healthchecksio](#input\_healthchecksio) | The healthchecks.io account to use. | <pre>object({<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | The path to output the Kubernetes configuration file. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use. | `string` | n/a | yes |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create the talos cluster from. | <pre>map(object({<br/>    type = string<br/>    install = object({<br/>      disk_filters      = map(string)<br/>      extensions        = optional(list(string), [])<br/>      extra_kernel_args = optional(list(string), [])<br/>      secureboot        = optional(bool, false)<br/>      architecture      = optional(string, "amd64")<br/>      platform          = optional(string, "metal")<br/>      sbc               = optional(string, "")<br/>      wipe              = optional(bool, true)<br/>    })<br/>    labels = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    annotations = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    disks = optional(list(object({<br/>      device     = string<br/>      mountpoint = string<br/>    })), [])<br/>    files = optional(list(object({<br/>      path        = string<br/>      op          = string<br/>      permissions = string<br/>      content     = string<br/>    })), [])<br/>    kubelet_extraMounts = optional(list(object({<br/>      destination = string<br/>      type        = string<br/>      source      = string<br/>      options     = list(string)<br/>    })), [])<br/>    interfaces = list(object({<br/>      addresses = list(object({<br/>        ip   = string<br/>        cidr = optional(string, "24")<br/>      }))<br/>      hardwareAddr     = string<br/>      dhcp_routeMetric = optional(number, 100)<br/>      vlans = optional(list(object({<br/>        vlanId = number<br/>        addresses = list(object({<br/>          ip   = string<br/>          cidr = optional(string, "24")<br/>        }))<br/>        dhcp_routeMetric = optional(number, 100)<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | The nameservers to use for the cluster. | `list(string)` | n/a | yes |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | The version of Prometheus to use. | `string` | n/a | yes |
| <a name="input_ssm_output_path"></a> [ssm\_output\_path](#input\_ssm\_output\_path) | The aws ssm parameter path to store config in. | `string` | `"/homelab/infrastructure/clusters"` | no |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | n/a | yes |
| <a name="input_timeservers"></a> [timeservers](#input\_timeservers) | The timeservers to use for the cluster. | `list(string)` | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | The Unifi controller to use. | <pre>object({<br/>    address       = string<br/>    site          = string<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_machineconf_filenames"></a> [machineconf\_filenames](#output\_machineconf\_filenames) | n/a |
| <a name="output_talosconfig_filename"></a> [talosconfig\_filename](#output\_talosconfig\_filename) | n/a |
<!-- END_TF_DOCS -->