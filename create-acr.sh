#!/bin/bash

set -euo pipefail

DEFAULT_SKU="Premium"

# This script logs the user into Azure and creates an Azure resource group
# with a unique name based on the current date and time (without dashes).
# The unique resource group is prefixed with "test" and suffixed with
# the current date and time (without dashes).
# It also creates an Azure Container Registry (with Premium SKU) with
# the same name as the resource group.
# This script accepts 1 argument:
#   - $1: The region in which to create the resource group and registry.

# Check for required arguments.
if [ $# -ne 1 ]; then
    echo "Usage: $0 <region>"
    exit 1
fi

# Set variables from arguments.
region=$1

# Log into Azure.
az login > /dev/null

# Get the current Azure subscription ID and name.
subscription_id=$(az account show --query id --output tsv)
subscription_name=$(az account show --query name --output tsv)

# Prompt the user to confirm creating resources within the current subscription.
echo "Creating resources in subscription name: '$subscription_name' (subscription ID: $subscription_id)"
read -p "Continue? (y/n) " -n 1 -r

# Print a blank line after the user's response.
echo

# If the user does not confirm, exit the script.
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting."
    exit 1
fi

# Get the current date and time without dashes.
date_time=$(date +%Y%m%d%H%M%S)

# Create a unique resource group name and registry name based on the current date and time.
resource_group_name="test$date_time"
registry_name=$resource_group_name

# Print message indicating that the script is creating a resource group.
echo "Creating resource group with name: '$resource_group_name'"

# Create a resource group with the unique name.
az group create --name $resource_group_name --location $region > /dev/null

# Print message indicating that the script is creating a registry.
echo "Creating registry with name: '$registry_name'"

# Create a registry with the same name as the resource group.
az acr create --name $registry_name --resource-group $resource_group_name --sku $DEFAULT_SKU --location $region > /dev/null

# Print the details of the registry.
echo "[*] Registry created with the following details:"
echo "[*] Subscription ID: $subscription_id"
echo "[*] Subscription Name: $subscription_name"
echo "[*] Resource Group Name: $resource_group_name"
echo "[*] ACR Registry Name: $resource_group_name"
echo "[*] Region: $region"
echo "[*] ACR Registry SKU: $DEFAULT_SKU"
