#!/bin/bash

set -e

# https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external#processing-json-in-shell-scripts

eval "$(jq -r '@sh "POD_NAME=\(.pod_name) NAMESPACE=\(.namespace) PATH_TO_DATA=\(.path_to_data)"')"

EXTRACTED_DATA=$(kubectl exec -n "$NAMESPACE" "$POD_NAME" -- cat $PATH_TO_DATA)

jq -n --arg extracted_data "$EXTRACTED_DATA" '{"extracted_data":$extracted_data}'
