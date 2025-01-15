run "test" {
  command = plan

  variables {
    cluster_name                               = "cluster-name"
    cluster_id                                 = 2
    cluster_endpoint                           = "cluster_endpoint"
    cluster_vip                                = "cluster_vip"
    cluster_node_subnet                        = "cluster_node_subnet"
    cluster_pod_subnet                         = "cluster_pod_subnet"
    cluster_service_subnet                     = "cluster_service_subnet"
    cluster_allowSchedulingOnControlPlanes     = true
    cluster_apiServer_disablePodSecurityPolicy = true
    cluster_coreDNS_disabled                   = true
    cluster_proxy_disabled                     = true
    cluster_extraManifests                     = ["extra_manifests1", "extra_manifests2"]
    cluster_inlineManifests = [{
      name     = "cluster_inlineManifests_name"
      contents = "cluster_inlineManifests_contents"
    }]

    machine_network_nameservers = ["nameservers1", "nameservers2"]
    machine_time_servers        = ["cluster_machine_time_servers1", "cluster_machine_time_servers2"]
    machine_files = [{
      content     = "machine_files_content",
      permissions = "machine_files_permissions",
      path        = "machine_files_path"
      op          = "create"
    }]
    machine_kubelet_extraMounts = [{
      destination = "machine_kubelet_extraMounts_destination",
      type        = "machine_kubelet_extraMounts_type",
      source      = "machine_kubelet_extraMounts_source",
      options     = ["machine_kubelet_extraMounts_options1", "machine_kubelet_extraMounts_options2"]
    }]

    talos_config_path  = "talos_config_path"
    kube_config_path   = "kube_config_path"
    kubernetes_version = "1.30.0"
    talos_version      = "v1.8.1"
    cilium_version     = "1.16.5"
    #cilium_values use default values for valid cilium config
    gracefully_destroy_nodes = true
    timeout                  = "69m"
    machines = {
      machine1 = {
        type = "controlplane"
        install = {
          diskSelectors   = ["machine1_diskSelectors1", "machine1_diskSelectors2"]
          extraKernelArgs = ["machine1_extraKernelArgs1", "machine1_extraKernelArgs2"]
          extensions      = ["machine1_extensions1", "machine1_extensions2"]
          secureboot      = true
          wipe            = true
          architecture    = "machine1_architecture"
          platform        = "machine1_platform"
        }
        files = [{
          content     = "machine1_files_content"
          permissions = "machine1_files_permissions"
          path        = "machine1_files_path"
          op          = "create"
        }]
        interfaces = [
          {
            hardwareAddr     = "machine1_interfaces1_hardwareAddr"
            addresses        = ["machine1_interfaces1_address1", "machine1_interfaces1_address2"]
            dhcp_routemetric = 3
            vlans = [
              {
                vlanId           = 4
                addresses        = ["machine1_interfaces1_vlan1_address1", "machine1_interfaces1_vlan1_address2"]
                dhcp_routemetric = 5
              }
            ]
          },
          {
            hardwareAddr     = "machine1_interfaces2_hardwareAddr"
            addresses        = ["machine1_interfaces2_address1", "machine1_interfaces2_address2"]
            dhcp_routemetric = 6
            vlans = [
              {
                vlanId           = 7
                addresses        = ["machine1_interfaces2_vlan1_address1", "machine1_interfaces2_vlan1_address2"]
                dhcp_routemetric = 8
              }
            ]
          }
        ]
      }
      machine2 = {
        type = "worker"
        install = {
          diskSelectors   = ["machine2_diskSelectors1", "machine2_diskSelectors2"]
          extraKernelArgs = ["machine2_extraKernelArgs1", "machine2_extraKernelArgs2"]
          extensions      = ["machine2_extensions1", "machine2_extensions2"]
          secureboot      = true
          wipe            = true
          architecture    = "machine2_architecture"
          platform        = "machine2_platform"
        }
        files = [{
          content     = "machine2_files_content"
          permissions = "machine2_files_permissions"
          path        = "machine2_files_path"
          op          = "create"
        }]
        interfaces = [
          {
            hardwareAddr     = "machine2_interfaces1_hardwareAddr"
            addresses        = ["machine2_interfaces1_address1", "machine2_interfaces1_address2"]
            dhcp_routemetric = 9
            vlans = [
              {
                vlanId           = 10
                addresses        = ["machine2_interfaces1_vlan1_address1", "machine2_interfaces1_vlan1_address2"]
                dhcp_routemetric = 11
              }
            ]
          },
          {
            hardwareAddr     = "machine2_interfaces2_hardwareAddr"
            addresses        = ["machine2_interfaces2_address1", "machine2_interfaces2_address2"]
            dhcp_routemetric = 12
            vlans = [
              {
                vlanId           = 13
                addresses        = ["machine2_interfaces2_vlan1_address1", "machine2_interfaces2_vlan1_address2"]
                dhcp_routemetric = 14
              }
            ]
          }
        ]
      }
    }
    run_talos_upgrade = true
  }

  # talos_machine_secrets.this
  assert {
    condition     = talos_machine_secrets.this.talos_version == "v1.8.1"
    error_message = "data.talos_machine_secrets.this talos_version is not as expected"
  }

  # data.talos_machine_configuration.this
  assert {
    condition     = alltrue([for k, v in data.talos_machine_configuration.this : v.cluster_name == "cluster-name"])
    error_message = "data.talos_machine_configuration.this cluster_name is not as expected"
  }

  assert {
    condition     = alltrue([for k, v in data.talos_machine_configuration.this : v.cluster_endpoint == "https://cluster_endpoint:6443"])
    error_message = "data.talos_machine_configuration.this cluster_endpoint is not as expected"
  }

  assert {
    condition     = data.talos_machine_configuration.this["machine1"].machine_type == "controlplane"
    error_message = "data.talos_machine_configuration.this machine_type is not as expected"
  }

  assert {
    condition     = data.talos_machine_configuration.this["machine2"].machine_type == "worker"
    error_message = "data.talos_machine_configuration.this machine_type is not as expected"
  }

  assert {
    condition     = alltrue([for k, v in data.talos_machine_configuration.this : v.kubernetes_version == "1.30.0"])
    error_message = "data.talos_machine_configuration.this kubernetes_version is not as expected"
  }

  assert {
    condition     = alltrue([for k, v in data.talos_machine_configuration.this : v.talos_version == "v1.8.1"])
    error_message = "data.talos_machine_configuration.this talos_version is not as expected"
  }

  assert {
    condition     = alltrue([for k, v in data.talos_machine_configuration.this : contains(["machine1", "machine2"], k)])
    error_message = "data.talos_machine_configuration.this keys are not as expected"
  }

  # talos_client_configuration.this
  assert {
    condition     = data.talos_client_configuration.this.cluster_name == "cluster-name"
    error_message = "data.talos_client_configuration.this cluster_name is not as expected"
  }

  assert {
    condition     = length(data.talos_client_configuration.this.endpoints) == 1
    error_message = "length of data.talos_client_configuration.this endpoints is not as expected"
  }

  assert {
    condition     = data.talos_client_configuration.this.endpoints[0] == "machine1_interfaces1_address1"
    error_message = "data.talos_client_configuration.this endpoints is not as expected"
  }

  assert {
    condition     = length(data.talos_client_configuration.this.nodes) == 2
    error_message = "length of data.talos_client_configuration.this nodes is not as expected"
  }

  assert {
    condition     = contains(data.talos_client_configuration.this.nodes, "machine1") && contains(data.talos_client_configuration.this.nodes, "machine2")
    error_message = "data.talos_client_configuration.this nodes are not as expected"
  }

  # talos_machine_configuration_apply.machines
  assert {
    condition     = length(talos_machine_configuration_apply.machines) == 2
    error_message = "length of talos_machine_configuration_apply.machines is not as expected"
  }

  assert {
    condition     = length(talos_machine_configuration_apply.machines) == 2
    error_message = "length of data.talos_machine_configuration_apply.this nodes is not as expected"
  }

  assert {
    condition     = talos_machine_configuration_apply.machines["machine1"].node == "machine1" && talos_machine_configuration_apply.machines["machine2"].node == "machine2"
    error_message = "talos_machine_configuration_apply.machines node is not as expected"
  }

  assert {
    condition     = talos_machine_configuration_apply.machines["machine1"].endpoint == "machine1_interfaces1_address1" && talos_machine_configuration_apply.machines["machine2"].endpoint == "machine2_interfaces1_address1"
    error_message = "talos_machine_configuration_apply.machines endpoint is not as expected"
  }

  assert {
    condition     = talos_machine_configuration_apply.machines["machine1"].on_destroy.graceful == true && talos_machine_configuration_apply.machines["machine2"].on_destroy.graceful == true
    error_message = "talos_machine_configuration_apply.machines on_destroy.graceful is not as expected"
  }

  # talos_machine_bootstrap.this
  assert {
    condition     = talos_machine_bootstrap.this.node == "machine1"
    error_message = "talos_machine_bootstrap.this node is not as expected"
  }

  assert {
    condition     = talos_machine_bootstrap.this.endpoint == "machine1_interfaces1_address1"
    error_message = "talos_machine_bootstrap.this endpoint is not as expected"
  }

  # talos_cluster_kubeconfig.this
  assert {
    condition     = talos_cluster_kubeconfig.this.node == "machine1"
    error_message = "talos_cluster_kubeconfig.this node is not as expected"
  }

  assert {
    condition     = talos_cluster_kubeconfig.this.endpoint == "machine1_interfaces1_address1"
    error_message = "talos_cluster_kubeconfig.this endpoint is not as expected"
  }

  # talos_image_factory_extensions_versions.machine_version
  assert {
    condition     = length(data.talos_image_factory_extensions_versions.machine_version) == 2
    error_message = "length of data.talos_image_factory_extensions_versions.machine_version is not as expected"
  }

  assert {
    condition     = alltrue([for k, v in data.talos_image_factory_extensions_versions.machine_version : v.talos_version == "v1.8.1"])
    error_message = "data.talos_image_factory_extensions_versions.machine_version talos_version is not as expected"
  }

  ##assert {
  #  condition     = alltrue([for k, v in data.talos_image_factory_extensions_versions.machine_version : contains([for ext in v.extensions_info : ext.name], "iscsi-tools") && contains([for ext in v.extensions_info : ext.name], "util-linux-tools")])
  #  error_message = "data.talos_image_factory_extensions_versions.machine_version extensions_info names do not contain expected values"
  #}

  # assert {
  #   condition     = alltrue([for k, v in data.talos_image_factory_extensions_versions.filters : contains(["machine1_extensions1", "machine1_extensions2"], v.names[0])])
  #   error_message = "data.talos_image_factory_extensions_versions.filters names is not as expected"
  # }

  # talos_image_factory_schematic.machine_schematic
  assert {
    condition     = length(talos_image_factory_schematic.machine_schematic) == 2
    error_message = "length of talos_image_factory_schematic.machine_schematic is not as expected"
  }

  # assert {
  #   condition     = talos_image_factory_schematic.machine_schematic["machine1"].schematic.customization.systemExtensions.officialExtensions[0] == "machine1_extensions1"
  #    error_message = "talos_image_factory_schematic.machine_schematic officialExtensions is not as expected"
  # }

}
