#!/bin/bash

set -euo pipefail

# This script tests pushing N new images to
# an Azure Container Registry N times for each image.
# This script accepts 2 arguments:
#   - $1: The name of the Azure Container Registry to push to.
#   - $2: The number of images to push to the registry.
#   - $3: The number of times to push each image to the registry.

# Check for required arguments.
if [ $# -ne 3 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io> <num-images> <num-times-per-image>"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
num_images=$2
num_times_per_image=$3

# Login to the registry.
az acr login --name $registry_name

# Create a for loop that generates N unique Dockerfiles.
# Each Dockerfile will be built FROM alpine and will
# echo a unique UUID string.
# Push each image to the registry N times.
for i in $(seq 1 $num_images); do
    # Generate a unique Dockerfile.
    uuid=$(uuidgen)
    echo "FROM alpine" > Dockerfile-$uuid
    echo "RUN echo $uuid" >> Dockerfile-$uuid

    # Build the Dockerfile into an image.
    docker build -t $registry_name.azurecr.io/$uuid -f Dockerfile-$uuid .

    # Push the image to the registry N times.
    for j in $(seq 1 $num_times_per_image); do
        docker push $registry_name.azurecr.io/$uuid
    done

    # Remove the Dockerfile.
    rm Dockerfile-$uuid
done
