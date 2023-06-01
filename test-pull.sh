#!/bin/bash

set -euo pipefail

# This script tests pulling all images from an
# Azure Container Registry N times for each image.
# This script accepts 2 arguments and an optional
# 3rd argument to prune the local Docker cache,
# which removes all containers, images, volumes,
# and networks.
#   - $1: The name of the Azure Container Registry to pull from.
#   - $2: The number of times to pull each image from the registry.
#   - $3: (Optional) The string "prune" to prune the local Docker cache.

# Check for required arguments.
if [ $# -lt 2 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io> <num-times-per-image> [prune]"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
num_times_per_image=$2

# Set the prune flag to true if the optional 3rd argument is "prune".
prune=false
if [ $# -eq 3 ] && [ $3 == "prune" ]; then
    prune=true
fi

# Prune the local Docker cache if the prune flag is true.
if [ $prune == true ]; then
    echo "Pruning the local Docker cache."
    docker system prune -a -f --volumes > /dev/null
fi

# Login to the registry.
az acr login --name $registry_name

# Get a list of all repositories in the registry.
repositories=$(az acr repository list --name $registry_name | jq -rM '.[]')

# Create a for loop that pulls all image digests from every repository.
# Each image will be pulled N times.
for repository in $repositories; do
    # Get a list of all image digests for the repository.
    digests=$(az acr manifest list-metadata --registry $registry_name --name $repository | jq -rM '.[].digest')

    # Create a for loop that pulls each image digest from the repository N times.
    for digest in $digests; do
        for i in $(seq 1 $num_times_per_image); do
            docker pull $registry_name.azurecr.io/$repository@$digest
        done
    done
done
