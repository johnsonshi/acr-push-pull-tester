#!/bin/bash

# Do not exit on error.
set -uo pipefail

# This script tests pulling all images from an
# Azure Container Registry N times for each image.
# This script will run until at least the specified
# number of minutes has elapsed.
# This script invokes test-pull.sh with the specified arguments.
# This script is guaranteed to run test-pull.sh to completion at least once,
# even if the specified number of minutes has elapsed.
# This script accepts 3 arguments, and an optional 4th argument
# to prune the local Docker cache, which removes all containers,
# images, volumes, and networks.
#   - $1: The name of the Azure Container Registry to pull from.
#   - $2: The number of times to pull each image from the registry.
#   - $3: The number of minutes to run the script.
#   - $4: (Optional) The string "prune" to prune the local Docker cache.

# Check for required arguments.
if [ $# -lt 3 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io> <num-times-per-image> <num-minutes> [prune]"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
num_times_per_image=$2
num_minutes=$3

# Set a prune flag to true if the optional 4th argument is "prune".
prune=false
if [ $# -eq 4 ] && [ $4 == "prune" ]; then
    prune=true
fi

# Get the current date and time in Unix epoch format.
start_time=$(date +%s)

# Convert the start time to a human-readable format.
start_time_human=$(date -d @$start_time)

# Print the start time.
echo "Starting test at $start_time_human."

# Get the end time in Unix epoch format.
end_time=$((start_time + (num_minutes * 60)))

# Convert the end time to a human-readable format.
end_time_human=$(date -d @$end_time)

# Print the end time.
echo "Ending test at $end_time_human."

# If prune was specified, then the command should be run with the prune argument.
if [ $prune == true ]; then
    cmd="./test-pull.sh $registry_name $num_times_per_image prune"
else
    cmd="./test-pull.sh $registry_name $num_times_per_image"
fi

# Run test-pull.sh at least once.
eval $cmd

# Create a while loop that runs test-pull.sh until the end time has been reached.
while [ $(date +%s) -lt $end_time ]; do
    # Run test-pull.sh.
    eval $cmd
done
