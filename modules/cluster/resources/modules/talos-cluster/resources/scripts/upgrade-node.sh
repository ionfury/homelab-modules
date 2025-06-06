#!/bin/sh

# Expects the following environment variables set:
#   DESIRED_TALOS_TAG
#   DESIRED_TALOS_SCHEMATIC
#   TALOS_CONFIG_PATH
#   TALOS_NODE
#   TIMEOUT

if [ -z "$DESIRED_TALOS_TAG" ] || [ -z "$DESIRED_TALOS_SCHEMATIC" ] || [ -z "$TALOS_CONFIG_PATH" ] || [ -z "$TALOS_NODE" ] || [ -z "$TIMEOUT" ]; then
  echo "⚠️ Missing required environment variables."
  exit 1
fi

echo "config: $TALOS_CONFIG_PATH"
echo "Upgrade check running on: $TALOS_NODE"
echo "Waiting for this node to be available..."
for i in {1..12}; do talosctl --talosconfig "$TALOS_CONFIG_PATH" get machinestatus --nodes "$TALOS_NODE" -o json 2>/dev/null | jq -e '.spec.status.ready' >/dev/null && break || sleep 10; done
echo "✅ Node is repoprting ready!"

#echo "Waiting for this cluster to be healthy..."
#for i in {1..12}; do talosctl --talosconfig $TALOS_CONFIG_PATH health --nodes "$TALOS_NODE" && break || sleep 10; done

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

echo "Waiting for node to be healthy..."
for i in {1..12}; do talosctl --talosconfig "$TALOS_CONFIG_PATH" get machinestatus --nodes "$TALOS_NODE" -o json 2>/dev/null | jq -e '.spec.status.ready' >/dev/null && break || sleep 10; done
echo "✅ Node is healthy!"

