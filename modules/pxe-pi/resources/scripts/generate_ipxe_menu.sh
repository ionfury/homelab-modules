#!/bin/bash

# This script generates iPXE menu files for Talos clusters using the Talos Image Factory API.
# It takes a directory containing Talos schematics as input and generates iPXE menu files for each schematic.

schematics_directory="$1"
output_directory="$2"
talos_image_factory_url="$3"

if ! command -v jq &> /dev/null; then
  echo "The 'jq' command is required but not installed. Please install it and try again."
  exit 1
fi

if [[ ! -d "$schematics_directory" ]]; then
  echo "Directory $schematics_directory does not exist. Provide a valid schematics directory as the first argument"
  exit 1
fi

if [[ ! -d "$output_directory" ]]; then
  echo "Directory $output_directory does not exist. Provide a valid output directory as the second argument"
  exit 1
fi

echo "Fetching available versions from $talos_image_factory_url/versions..."
response=$(curl -s "$talos_image_factory_url/versions")
if [[ -z "$response" ]]; then
  echo "Failed to fetch versions. Exiting."
  exit 1
fi

latest_version=$(echo "$response" | jq -r '[.[] | select(test("^v[0-9]+\\.[0-9]+\\.[0-9]+$")) | ltrimstr("v")] | sort_by(. | split(".") | map(tonumber)) | last')

if [[ -z "$latest_version" ]]; then
  echo "Failed to determine the latest version. Exiting."
  exit 1
fi

echo "Latest version: $latest_version"

first_schematic_id=""

# Generate iPXE script
ipxe_script="$output_directory/config.ipxe"
echo "#!ipxe" > "$ipxe_script"
echo "set timeout 30000" >> "$ipxe_script"
echo "menu iPXE Boot Menu" >> "$ipxe_script"
echo "item --gap -- ----------------------------" >> "$ipxe_script"
for schematic_file_path in "$schematics_directory"/*; do
  if [[ -f "$schematic_file_path" ]]; then
    schematic_file_name=$(basename "$schematic_file_path" | sed 's/\.[^.]*$//').ipxe
    schematic_tag=$(basename "$schematic_file_path" .yaml)
    echo "Processing $schematic_file_name..."

    response=$(curl -s -X POST --data-binary @"$schematic_file_path" "$talos_image_factory_url/schematics")
    if [[ -z "$response" ]]; then
      echo "Failed to fetch schematic for $schematic_file_name. Skipping."
      continue
    fi

    schematic_id=$(echo "$response" | jq -r '.id')
    echo "Schematic ID: $schematic_id"

    output_file_path="$output_directory/$schematic_file_name"
    curl -s -o $output_file_path $talos_image_factory_url/pxe/$schematic_id/$latest_version/metal-amd64 
    sed -i '' '2i\
imgfree
    ' "$output_file_path"

    # Set permissions for the output file
    chown tftp:tftp "$output_file_path"
    chmod 0644 "$output_file_path"

    echo "Output written to $output_file_path"

    # Add menu item for this schematic
    echo "item $schematic_tag Boot Talos $latest_version (Schematic: $schematic_tag)" >> "$ipxe_script"
  fi
done


# Add boot commands to the iPXE script
echo "item disk Boot from local disk" >> "$ipxe_script"
echo "choose --default $schematic_tag --timeout 10000 target && goto \${target}" >> "$ipxe_script"
echo ":disk" >> "$ipxe_script"
echo "sanboot --no-describe --drive 0x80" >> "$ipxe_script"

for schematic_file_path in "$schematics_directory"/*; do
  if [[ -f "$schematic_file_path" ]]; then
    schematic_file_name=$(basename "$schematic_file_path" | sed 's/\.[^.]*$//').ipxe
    schematic_id=$(basename "$schematic_file_path" .yaml)
    echo ":$schematic_id" >> "$ipxe_script"
    echo "chain tftp://\${root-path}:69/$schematic_file_name" >> "$ipxe_script"
    echo "goto start" >> "$ipxe_script"
  fi
done

# Set permissions for the iPXE script
chown tftp:tftp "$ipxe_script"
chmod 0644 "$ipxe_script"

echo "iPXE script generated at $ipxe_script"