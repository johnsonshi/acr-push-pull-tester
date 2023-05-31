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
# This script accepts 3 arguments:
#   - $1: The name of the Azure Container Registry to pull from.
#   - $2: The number of times to pull each image from the registry.
#   - $3: The number of minutes to run the script.

# Check for required arguments.
if [ $# -ne 3 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io> <num-times-per-image> <num-minutes>"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
num_times_per_image=$2
num_minutes=$3

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

# Run test-pull.sh at least once.
cmd="./test-pull.sh $registry_name $num_times_per_image"
eval $cmd

# Create a while loop that runs test-pull.sh until the end time has been reached.
while [ $(date +%s) -lt $end_time ]; do
    # Run test-pull.sh.
    eval $cmd
done
