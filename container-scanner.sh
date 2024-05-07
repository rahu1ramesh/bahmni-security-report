#!/bin/bash

# Container scanning is the process of analyzing components within containers to uncover 
# potential security threats. It is integral to ensuring that the software remains secure 
# as it progresses through the application life cycle. Container scanning takes its cues 
# from practices like vulnerability scanning and penetration testing.

# This script uses Trivy, a simple and comprehensive vulnerability scanner
# for containers and other artifacts. Trivy can find vulnerabilities, 
# IaC misconfigurations, secrets, SBOM discovery, Cloud scanning, Kubernetes security risks, 
# and more. More information about Trivy can be found at https://trivy.dev/.

# This script scans for the current running container images on docker, so it should be run only when 
# there is a workload running. Otherwise, it will not find any images to scan.

# Get Docker Organization Name
ORG="bahmni"

# Check if trivy is installed and install it if not
if ! command -v trivy &> /dev/null; then
    echo "Trivy is not installed. Installing..."
    wget https://github.com/aquasecurity/trivy/releases/download/v0.51.1/trivy_0.51.1_Linux-64bit.deb
    sudo dpkg -i trivy_0.51.1_Linux-64bit.deb
else
    echo "Found trivy, using trivy v$(trivy -v | cut -d ' ' -f 2)"
fi

echo "Retrieving repository list ..."
REPO_LIST=$(curl -s "https://hub.docker.com/v2/repositories/${ORG}/?page_size=100" | jq -r '.results|.[]|.name')

# Get today's date in the desired format for folder naming
TODAY_DATE=$(date +'%d-%m-%Y')
# Define the root and sub directory name
ROOT_DIR="container-scanner-reports"
DIR="bahmni-${TODAY_DATE}"

# Check if the root directory exists and create it if not
if [ ! -d "$ROOT_DIR" ]; then
    echo "Creating directory $ROOT_DIR"
    mkdir "$ROOT_DIR"
else
    echo "Root Directory $ROOT_DIR already exists, proceeding"
fi

# Check if the root directory exists and create it if not
if [ ! -d "$ROOT_DIR/$DIR" ]; then
    echo "Creating directory $ROOT_DIR/$DIR"
    mkdir "$ROOT_DIR/$DIR"
else
    echo "Directory $ROOT_DIR/$DIR already exists, proceeding"
fi

echo "Generating scan report...."

# Iterate through each image and run Trivy scan
for image in $REPO_LIST; do
    # Extract image name and tag
    image_name=$(echo "$image" | cut -d ':' -f 1)
    tag="$(echo "$image" | cut -d ':' -f 2)"

    # Replace '/' with '-' in the image name
    image_name=$(echo "$image_name" | tr '/' '-')

    # Define the Output File
    output_file_txt="$ROOT_DIR/${DIR}/${image}-${TODAY_DATE}.html"

    # Run Trivy scan on the image
    echo "Scanning image: $image"
    trivy image --severity HIGH,CRITICAL --format template --template "@html.tpl" --output "$output_file_txt" "${ORG}/$image_name"
    echo "" >> "$output_file_txt"

    # Check if Trivy scan was successful
    if [ $? -eq 0 ]; then
        echo "Trivy scan completed for $image."
    else
        echo "Error: Trivy scan failed for $image."
    fi
done