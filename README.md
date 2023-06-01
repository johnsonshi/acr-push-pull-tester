# ACR Push Pull Tester

This is a set of scripts to test repeatedly pushing and pulling images from an [Azure Container Registry (ACR)](https://azure.microsoft.com/en-us/products/container-registry).

This is useful for populating a test registry with images or repositories. It is also useful for generating activity, metrics, and logs for the ACR registry.

# Usage

## Clone the Repository

```
git clone https://github.com/johnsonshi/acr-push-pull-tester.git
cd acr-push-pull-tester
```

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
./test-pull.sh <registry-name-without-azurecr.io> <num-times-per-image>
```

To ensure that testing pull always pulls images from the registry to the local Docker store, prune (delete) the local Docker cache by specifying `prune` as the last argument to `test-pull.sh`.

```
./test-pull.sh <registry-name-without-azurecr.io> <num-times-per-image> prune
```

## Test Pushing and Pulling Images Until N Minutes Elapse

Test building and pushing pushing N new images (from randomly generated Dockerfiles) to the registry until X minutes elapse, with each image being pushed N times repeatedly.

```
./test-push-repeatedly-until-n-minutes.sh <registry-name-without-azurecr.io> <num-images> <num-times-per-image> <num-minutes>
```

Test pulling all images from a registry until X minutes elapse, with each image being pulled N times repeatedly.

```
./test-pull-repeatedly-until-n-minutes.sh <registry-name-without-azurecr.io> <num-times-per-image> <num-minutes>
```

To ensure that testing pull always pulls images from the registry to the local Docker store, prune (delete) the local Docker cache by specifying `prune` as the last argument to `test-pull-repeatedly-until-n-minutes.sh`.

```
./test-pull-repeatedly-until-n-minutes.sh <registry-name-without-azurecr.io> <num-times-per-image> <num-minutes> prune
```

## Deleting the ACR Registry

This will delete the resource group and ACR registry created by `create-acr.sh`.

```
./delete-acr.sh <registry-name-without-azurecr.io>
```
