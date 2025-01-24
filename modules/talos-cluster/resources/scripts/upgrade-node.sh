#!/bin/sh

# Expects the following environment variables set:
#   DESIRED_TALOS_TAG
#   DESIRED_TALOS_SCHEMATIC
#   TALOS_CONFIG_PATH
#   TALOS_NODE
#   STAGE
#   TIMEOUT

if [ -z "$DESIRED_TALOS_TAG" ] || [ -z "$DESIRED_TALOS_SCHEMATIC" ] || [ -z "$TALOS_CONFIG_PATH" ] || [ -z "$TALOS_NODE" ] || [ -z "$STAGE" ] || [ -z "$TIMEOUT" ]; then
  echo "Missing required environment variables."
  exit 1
fi

CURRENT_TALOS_SCHEMATIC=$(talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$TALOS_NODE" get extensions -o json 2>/dev/null | jq -s '.[] | select(.spec.metadata.name == "schematic") | .spec.metadata.version' | tr -d '"')
CURRENT_TALOS_TAG=$(talosctl --talosconfig "$TALOS_CONFIG_PATH" --nodes "$TALOS_NODE" version --short 2>/dev/null | grep 'Tag:' | awk '{print $2}')

echo Current Schematic: $CURRENT_TALOS_SCHEMATIC Desired Schematic: $DESIRED_TALOS_SCHEMATIC
echo Current Tag: $CURRENT_TALOS_TAG Desired Tag: $DESIRED_TALOS_TAG

if [ "$DESIRED_TALOS_TAG" = "$CURRENT_TALOS_TAG" ] && [ "$DESIRED_TALOS_SCHEMATIC" = "$CURRENT_TALOS_SCHEMATIC" ]; then
  echo "No Upgrade required."
else
  echo "Upgrade required."
  talosctl --talosconfig $TALOS_CONFIG_PATH --nodes "$TALOS_NODE" upgrade --image="factory.talos.dev/installer/$DESIRED_TALOS_SCHEMATIC:$DESIRED_TALOS_TAG" --timeout=$TIMEOUT --preserve
fi
