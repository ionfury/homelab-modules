#!/bin/sh

# Expects the following environment variables set:
#   DESIRED_TALOS_TAG
#   DESIRED_TALOS_SCHEMATIC
#   TALOS_CONFIG_PATH
#   TALOS_NODE
#   TIMEOUT

MAX_RETRIES=12
SLEEP_INTERVAL=10

wait_for_node_ready() {
  local config_path=$1
  local node=$2

  echo "Waiting for node '$node' to report ready (max $MAX_RETRIES tries)..."
  for i in $(seq 1 "$MAX_RETRIES"); do
    if talosctl --talosconfig "$config_path" \
         get machinestatus --nodes "$node" -o json 2>/dev/null \
       | jq -e '.spec.status.ready' >/dev/null 2>&1
    then
      echo "✅ Node '$node' is reporting ready!"
      return 0
    fi

    echo "Attempt $i/$MAX_RETRIES: not ready yet, sleeping $SLEEP_INTERVAL s..."
    if [ "$i" -eq "$MAX_RETRIES" ]; then
      echo "⚠️ Timeout waiting for node readiness—giving up."
      return 1
    fi
    sleep "$SLEEP_INTERVAL"
  done
}

if [ -z "$DESIRED_TALOS_TAG" ] || [ -z "$DESIRED_TALOS_SCHEMATIC" ] || [ -z "$TALOS_CONFIG_PATH" ] || [ -z "$TALOS_NODE" ] || [ -z "$TIMEOUT" ]; then
  echo "⚠️ Missing required environment variables."
  exit 1
fi

echo "config: $TALOS_CONFIG_PATH"
echo "Upgrade check running on: $TALOS_NODE"

if ! wait_for_node_ready "$TALOS_CONFIG_PATH" "$TALOS_NODE"; then
  exit 1
fi

CURRENT_TALOS_SCHEMATIC=$(talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$TALOS_NODE" get extensions -o json 2>/dev/null | jq -s '.[] | select(.spec.metadata.name == "schematic") | .spec.metadata.version' | tr -d '"')
CURRENT_TALOS_TAG=$(talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$TALOS_NODE" read /etc/os-release 2>/dev/null | awk -F= '/^VERSION_ID=/ {print $2}')

echo Current Schematic: $CURRENT_TALOS_SCHEMATIC Desired Schematic: $DESIRED_TALOS_SCHEMATIC
echo Current Tag: $CURRENT_TALOS_TAG Desired Tag: $DESIRED_TALOS_TAG

if [ "$DESIRED_TALOS_TAG" = "$CURRENT_TALOS_TAG" ] && [ "$DESIRED_TALOS_SCHEMATIC" = "$CURRENT_TALOS_SCHEMATIC" ]; then
  echo "No Upgrade required."
else
  echo "Upgrade required."
  if ! talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$TALOS_NODE" upgrade --image="factory.talos.dev/installer/$DESIRED_TALOS_SCHEMATIC:$DESIRED_TALOS_TAG" --timeout=$TIMEOUT; then
    echo "⚠️ Upgrade RPC errored out (EOF / GOAWAY is expected during reboot), continuing…"
  else
    echo "✅ Upgrade RPC completed without errors."
  fi
fi

if ! wait_for_node_ready "$TALOS_CONFIG_PATH" "$TALOS_NODE"; then
  exit 1
fi
