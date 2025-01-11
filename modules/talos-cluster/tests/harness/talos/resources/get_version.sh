#!/bin/bash

set -e

# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external#processing-json-in-shell-scripts
eval "$(jq -r '@sh "TALOS_CONFIG_PATH=\(.talos_config_path) NODE=\(.node)"')"

VERSION=$(talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$NODE" version --short | grep "Tag:" | awk '{print $2}')

jq -n --arg talos_version "$VERSION" '{"talos_version":$talos_version}'
