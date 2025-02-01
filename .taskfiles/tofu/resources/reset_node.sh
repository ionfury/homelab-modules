#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <config-directory> <node-name>"
    exit 1
fi

CONFIG_DIR="$1"
NODE_NAME="$2"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: Directory $CONFIG_DIR does not exist."
    exit 1
fi

shopt -s nullglob

FOUND_CONFIG=0
SUCCESS=0

echo "Attempting to reset node $NODE_NAME using configs from $CONFIG_DIR"

for CONFIG_FILE in "$CONFIG_DIR"/*; do
    if [ -f "$CONFIG_FILE" ]; then
        FOUND_CONFIG=1
        echo "Trying config: $CONFIG_FILE"
        if talosctl --talosconfig "$CONFIG_FILE" -n "$NODE_NAME" reset --graceful=false --wait=false --reboot; then
            echo "Successfully initiated reset using $CONFIG_FILE"
            SUCCESS=1
            break
        else
            echo "Failed to reset using $CONFIG_FILE"
        fi
    fi
done

shopt -u nullglob

if [ $FOUND_CONFIG -eq 0 ]; then
    echo "Error: No configuration files found in $CONFIG_DIR"
    exit 1
fi

if [ $SUCCESS -eq 0 ]; then
    echo "Error: All configuration attempts failed for node $NODE_NAME"
    exit 1
fi

exit 0