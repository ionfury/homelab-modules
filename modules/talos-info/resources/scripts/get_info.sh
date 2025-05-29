#!/bin/bash

set -e

# Parse input parameters
eval "$(jq -r '@sh "TALOS_CONFIG_PATH=\(.talos_config_path) NODE=\(.node)"')"

# Helper function to safely execute talosctl commands
safe_talosctl() {
  local cmd="$1"
  local default_value="$2"
  
  # Execute the command, return default_value if it fails
  output=$(eval "$cmd" 2>/dev/null || echo "$default_value")
  echo "$output"
}

# Execute talosctl commands with error handling
VERSION=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" version --short | grep 'Tag:' | awk '{print \$2}'" "")
SCHEMATIC_VERSION=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get extensions -o json | jq -s '.[] | select(.spec.metadata.name == \"schematic\") | .spec.metadata.version'" "") 
INTERFACES=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get deviceconfigspec -o json | jq -r '.spec.device.addresses'" "")
NAMESERVERS=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get dnsupstreams -o json | jq -sc '[.[] | .spec.addr]'" "[]")
TIMESERVERS=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get timeservers -o json | jq -r '.spec.timeServers'" "[]")
CONTROLPLANE_SCHEDULABLE=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get nodestatus -o json | jq -r '.spec.unschedulable | not'" "false")
MACHINE_TYPE=$(safe_talosctl "talosctl --talosconfig \"$TALOS_CONFIG_PATH\" --nodes \"$NODE\" get machinetype -o json | jq -r '.spec'" "")

# Trim double quotes from the SCHEMATIC_VERSION
SCHEMATIC_VERSION="$(echo "$SCHEMATIC_VERSION" | tr -d '"')"

jq -n \
  --arg talos_version "$VERSION" \
  --arg schematic_version "$SCHEMATIC_VERSION" \
  --arg interfaces "$(echo "$INTERFACES" | jq -c -r tostring)" \
  --arg nameservers "$(echo "$NAMESERVERS" | jq -c -r tostring)" \
  --arg timeservers "$(echo "$TIMESERVERS" | jq -c -r tostring)" \
  --arg controlplane_schedulable "$CONTROLPLANE_SCHEDULABLE" \
  --arg machine_type "$MACHINE_TYPE" \
  '{
    "talos_version": $talos_version,
    "schematic_version": $schematic_version,
    "interfaces": $interfaces,
    "nameservers": $nameservers,
    "timeservers": $timeservers,
    "controlplane_schedulable": $controlplane_schedulable,
    "machine_type": $machine_type
  }'