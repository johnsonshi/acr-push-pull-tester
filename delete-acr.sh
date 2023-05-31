#!/bin/bash

set -euo pipefail

# This script logs the user into Azure and deletes
# the registry and resource group created by create-acr.sh.
# The registry and resource group share the same name.
# This script accepts 1 argument:
#   - $1: The name of the Azure Container Registry to delete.

# Check for required arguments.
if [ $# -ne 1 ]; then
    echo "Usage: $0 <registry-name-without-azurecr.io>"
    exit 1
fi

# Set variables from arguments.
registry_name=$1
resource_group_name=$registry_name

# Log into Azure.
az login > /dev/null

# Get the current Azure subscription ID and name.
subscription_id=$(az account show --query id --output tsv)
subscription_name=$(az account show --query name --output tsv)

# Prompt the user to confirm deleting the registry and resource group within the current subscription.
echo "Deleting the following resources in subscription name: '$subscription_name' (subscription ID: $subscription_id)"
echo "  - Resource group name: '$registry_name'"
echo "  - Registry name: '$registry_name'"

read -p "Continue? (y/n) " -n 1 -r

# Print a blank line after the user's response.
echo

# If the user does not confirm, exit the script.
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting."
    exit 1
fi

# Delete the registry.
az acr delete --name $registry_name --yes

# Delete the resource group.
az group delete --name $resource_group_name --yes
