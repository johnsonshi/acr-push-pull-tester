# ACR Push Pull Tester

This is a set of scripts to test repeatedly pushing and pulling images from an [Azure Container Registry (ACR)](https://azure.microsoft.com/en-us/products/container-registry).

# Usage

## Creating an ACR Registry for Testing

Create a resource group and ACR registry with a uniquely generated name in the region of your choice. The created resource group and registry will have the same uniquely generated name.

```
./create-acr.sh <region>
```

## Test Pushing and Pulling Images N Times

Test building and pushing pushing N new images (from randomly generated Dockerfiles) to the registry, with each image being pushed N times repeatedly.

```
./test-push.sh <registry-name-without-azurecr.io> <num-images> <num-times-per-image>
```

Test pulling all images from a registry, with each image being pulled N times repeatedly.

```
./test-pull.sh registry-name-without-azurecr.io> <num-times-per-image>
```

## Deleting the ACR Registry

This will delete the resource group and ACR registry created by `create-acr.sh`.

```
./delete-acr.sh <registry-name-without-azurecr.io>
```
