# Cluster Module

This is a highly opinionated implementation of the other modules in this repository.  It's primary purpose is to template deploying kubernetes clusters into my homelab environment, and expose only the levers and knobs which I need access to.  This allows me to make the other modules more generic.

## Overview

In brief, the `cluster` module does the following:

1. Pulls secrets from AWS parameter store via the `params-get` module.
1. ~~Creates Unifi dns entries for all machines~~
1. ~~Creates Unifi user records (DHCP Reservations) for all machines~~
1. Creates a talos cluster from the machines via the `talos-cluster`.
1. Bootstraps the talos cluster into my [homelab gitops repository](https://github.com/ionfury/homelab/tree/main/kubernetes/clusters) for further management via flux via the `bootstrap` module.
1. Stores the cluster `kubeconfig` and `talosconfig` secrets in my AWS parameter store.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.8 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ../bootstrap | n/a |
| <a name="module_params_get"></a> [params\_get](#module\_params\_get) | ../params-get | n/a |
| <a name="module_params_put"></a> [params\_put](#module\_params\_put) | ../params-put | n/a |
| <a name="module_talos_cluster"></a> [talos\_cluster](#module\_talos\_cluster) | ../talos-cluster | n/a |
| <a name="module_unifi_dns"></a> [unifi\_dns](#module\_unifi\_dns) | ../unifi-dns | n/a |
| <a name="module_unifi_users"></a> [unifi\_users](#module\_unifi\_users) | ../unifi-users | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws"></a> [aws](#input\_aws) | The AWS account to use. | <pre>object({<br/>    region  = string<br/>    profile = string<br/>  })</pre> | n/a | yes |
| <a name="input_cilium_helm_values"></a> [cilium\_helm\_values](#input\_cilium\_helm\_values) | The Helm values to use for Cilium. | `string` | n/a | yes |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | The version of Cilium to use. | `string` | n/a | yes |
| <a name="input_cloudflare"></a> [cloudflare](#input\_cloudflare) | The Cloudflare account to use. | <pre>object({<br/>    account       = string<br/>    email         = string<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_cluster_endpoint"></a> [cluster\_endpoint](#input\_cluster\_endpoint) | The endpoint for the cluster. | `string` | n/a | yes |
| <a name="input_cluster_env_vars"></a> [cluster\_env\_vars](#input\_cluster\_env\_vars) | Arbitrary map of values to pass to cluster via the generated-cluster-vars.env. | `map(string)` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | A name to provide for the cluster. | `string` | n/a | yes |
| <a name="input_cluster_node_subnet"></a> [cluster\_node\_subnet](#input\_cluster\_node\_subnet) | The subnet to use for the Talos cluster nodes. | `string` | n/a | yes |
| <a name="input_cluster_pod_subnet"></a> [cluster\_pod\_subnet](#input\_cluster\_pod\_subnet) | The pod subnet to use for pods on the Talos cluster. | `string` | n/a | yes |
| <a name="input_cluster_service_subnet"></a> [cluster\_service\_subnet](#input\_cluster\_service\_subnet) | The pod subnet to use for services on the Talos cluster. | `string` | n/a | yes |
| <a name="input_cluster_vip"></a> [cluster\_vip](#input\_cluster\_vip) | The VIP to use for the Talos cluster. Applied to the first interface of control plane machines. | `string` | n/a | yes |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | The external secret store. | <pre>object({<br/>    id_store     = string<br/>    secret_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_flux_version"></a> [flux\_version](#input\_flux\_version) | The version of Flux to use. | `string` | n/a | yes |
| <a name="input_github"></a> [github](#input\_github) | The GitHub repository to use. | <pre>object({<br/>    org             = string<br/>    repository      = string<br/>    repository_path = string<br/>    token_store     = string<br/>  })</pre> | n/a | yes |
| <a name="input_healthchecksio"></a> [healthchecksio](#input\_healthchecksio) | The healthchecks.io account to use. | <pre>object({<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to output the Kubernetes configuration file. | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use. | `string` | n/a | yes |
| <a name="input_longhorn_mount_disk2"></a> [longhorn\_mount\_disk2](#input\_longhorn\_mount\_disk2) | Mount disk2 for Longhorn. | `bool` | `false` | no |
| <a name="input_machines"></a> [machines](#input\_machines) | A list of machines to create the talos cluster from. | <pre>map(object({<br/>    type = string<br/>    install = object({<br/>      diskSelectors   = list(string) # https://www.talos.dev/v1.9/reference/configuration/v1alpha1/config/#Config.machine.install.diskSelector<br/>      extraKernelArgs = optional(list(string), [])<br/>      extensions      = optional(list(string), [])<br/>      secureboot      = optional(bool, false)<br/>      wipe            = optional(bool, false)<br/>      architecture    = optional(string, "amd64")<br/>      platform        = optional(string, "metal")<br/>      sbc             = optional(string, "")<br/>    })<br/>    disks = optional(list(object({<br/>      device = string<br/>      partitions = list(object({<br/>        mountpoint = string<br/>        size       = optional(string, "")<br/>      }))<br/>    })), [])<br/>    labels = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    annotations = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })), [])<br/>    files = optional(list(object({<br/>      content     = string<br/>      permissions = string<br/>      path        = string<br/>      op          = string<br/>    })), [])<br/>    interfaces = list(object({<br/>      hardwareAddr     = string<br/>      addresses        = list(string)<br/>      dhcp_routeMetric = optional(number, 100)<br/>      vlans = optional(list(object({<br/>        vlanId           = number<br/>        addresses        = list(string)<br/>        dhcp_routeMetric = optional(number, 100)<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_nameservers"></a> [nameservers](#input\_nameservers) | The nameservers to use for the cluster. | `list(string)` | n/a | yes |
| <a name="input_prepare_kube_prometheus_metrics"></a> [prepare\_kube\_prometheus\_metrics](#input\_prepare\_kube\_prometheus\_metrics) | Prepare the cluster for kube-prometheus-metrics. | `bool` | `false` | no |
| <a name="input_prepare_longhorn"></a> [prepare\_longhorn](#input\_prepare\_longhorn) | Prepare the cluster for Longhorn. | `bool` | `false` | no |
| <a name="input_prepare_spegel"></a> [prepare\_spegel](#input\_prepare\_spegel) | Prepare the cluster for Spegel. | `bool` | `false` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | The version of Prometheus to use. | `string` | n/a | yes |
| <a name="input_speedy_kernel_args"></a> [speedy\_kernel\_args](#input\_speedy\_kernel\_args) | Use speedy kernel args. | `bool` | `false` | no |
| <a name="input_talos_config_path"></a> [talos\_config\_path](#input\_talos\_config\_path) | The path to output the Talos configuration file. | `string` | n/a | yes |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | The version of Talos to use. | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The timeout to use for the cluster. | `string` | n/a | yes |
| <a name="input_timeservers"></a> [timeservers](#input\_timeservers) | The timeservers to use for the cluster. | `list(string)` | n/a | yes |
| <a name="input_tld"></a> [tld](#input\_tld) | The top-level domain to use. | `string` | n/a | yes |
| <a name="input_unifi"></a> [unifi](#input\_unifi) | The Unifi controller to use. | <pre>object({<br/>    address       = string<br/>    site          = string<br/>    api_key_store = string<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_machineconf_filenames"></a> [machineconf\_filenames](#output\_machineconf\_filenames) | n/a |
| <a name="output_talosconfig_filename"></a> [talosconfig\_filename](#output\_talosconfig\_filename) | n/a |
<!-- END_TF_DOCS -->