#!/bin/bash

# Do not exit on error.
set -uo pipefail

# This script tests pushing N new images to
# an Azure Container Registry N times for each image.
# This script will run until at least the specified
# number of minutes has elapsed.
# This script invokes test-push.sh with the specified arguments.
# This script is guaranteed to run test-push.sh to completion at least once,
# even if the specified number of minutes has elapsed.
# This script accepts 4 arguments:
#   - $1: The name of the Azure Container Registry to push to.
#   - $2: The number of images to push to the registry.
#   - $3: The number of times to push each image to the registry.
#   - $4: The number of minutes to run the script.

# Check for required arguments.
if [ $# -ne 4 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io> <num-images> <num-times-per-image> <num-minutes>"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
num_images=$2
num_times_per_image=$3
num_minutes=$4

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

# Run test-push.sh at least once.
cmd="./test-push.sh $registry_name $num_images $num_times_per_image"
eval $cmd

# Create a while loop that runs test-push.sh until the end time has been reached.
while [ $(date +%s) -lt $end_time ]; do
    # Run test-push.sh.
    eval $cmd
done
