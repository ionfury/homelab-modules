# Cluster Module

This is a highly opinionated implementation of the other modules in this repository.  It's primary purpose is to template deploying kubernetes clusters into my homelab environment, and expose only the levers and knobs which I need access to.  This allows me to make the other modules more generic.

## Overview

In brief, the `cluster` module does the following:

1. Pulls secrets from AWS parameter store via the `params-get` module.
1. Creates Unifi dns entries for all machines
1. Creates Unifi user records (DHCP Reservations) for all machines
1. Creates a talos cluster from the machines via the `talos-cluster`.
1. Bootstraps the talos cluster into my [homelab gitops repository](https://github.com/ionfury/homelab/tree/main/kubernetes/clusters) for further management via flux via the `bootstrap` module.
1. Stores the cluster `kubeconfig` and `talosconfig` secrets in my AWS parameter store.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.80.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.80.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_talos_cluster"></a> [talos\_cluster](#module\_talos\_cluster) | ./resources/modules/talos-cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.params_put](https://registry.terraform.io/providers/hashicorp/aws/5.80.0/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cilium_helm_values"></a> [cilium\_helm\_values](#input\_cilium\_helm\_values) | The Helm values to use for Cilium. | `string` | n/a | yes |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | The version of Cilium to use. | `string` | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The endpoint for the cluster. | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | A name to provide for the cluster. | `string` | n/a | yes |
| <a name="input_cluster_node_subnet"></a> [cluster\_node\_subnet](#input\_cluster\_node\_subnet) | The subnet to use for the Talos cluster nodes. | `string` | n/a | yes |
| <a name="input_cluster_on_destroy"></a> [cluster\_on\_destroy](#input\_cluster\_on\_destroy) | How to preform node destruction | <pre>object({<br/>    graceful = string<br/>    reboot   = string<br/>    reset    = string<br/>  })</pre> | <pre>{<br/>  "graceful": false,<br/>  "reboot": true,<br/>  "reset": true<br/>}</pre> | no |
| <a name="input_cluster_pod_subnet"></a> [cluster\_pod\_subnet](#input\_cluster\_pod\_subnet) | The pod subnet to use for pods on the Talos cluster. | `string` | n/a | yes |
| <a name="input_cluster_service_subnet"></a> [cluster\_service\_subnet](#input\_cluster\_service\_subnet) | The pod subnet to use for services on the Talos cluster. | `string` | n/a | yes |
| <a name="input_cluster_vip"></a> [cluster\_vip](#input\_cluster\_vip) | The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | The path to output the Kubernetes configuration file. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use. | `string` | n/a | yes |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create the talos cluster from. | <pre>map(object({<br/>    type = string<br/>    install = object({<br/>      disk              = string<br/>      extensions        = optional(list(string), [])<br/>      extra_kernel_args = optional(list(string), [])<br/>      secureboot        = optional(bool, false)<br/>      architecture      = optional(string, "amd64")<br/>      platform          = optional(string, "metal")<br/>      sbc               = optional(string, "")<br/>      wipe              = optional(bool, true)<br/>    })<br/>    labels = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    annotations = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    files = optional(list(object({<br/>      path        = string<br/>      op          = string<br/>      permissions = string<br/>      content     = string<br/>    })), [])<br/>    interfaces = list(object({<br/>      addresses        = list(string)<br/>      dhcp_routeMetric = optional(number, 100)<br/>      vlans = optional(list(object({<br/>        vlanId           = number<br/>        addresses        = list(string)<br/>        dhcp_routeMetric = optional(number, 100)<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | The nameservers to use for the cluster. | `list(string)` | n/a | yes |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | The version of Prometheus to use. | `string` | n/a | yes |
| <a name="input_ssm_output_path"></a> [ssm\_output\_path](#input\_ssm\_output\_path) | The aws ssm parameter path to store config in. | `string` | `"/homelab/infrastructure/clusters"` | no |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | n/a | yes |
| <a name="input_timeservers"></a> [timeservers](#input\_timeservers) | The timeservers to use for the cluster. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_machineconf_filenames"></a> [machineconf\_filenames](#output\_machineconf\_filenames) | n/a |
| <a name="output_talosconfig_filename"></a> [talosconfig\_filename](#output\_talosconfig\_filename) | n/a |
<!-- END_TF_DOCS -->