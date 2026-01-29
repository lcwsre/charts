# Building CRD Installer Images

## Overview

The rancher-monitoring-crd chart uses a Job-based installation approach with server-side apply to handle large CRD payloads (~11MB) and support bootstrap scenarios where CNI is not yet available.

## Prerequisites

- Docker or compatible container runtime
- Access to a container registry
- Helm 3.x

## Building CRD Installer Images

### 1. Build the Image

Build for each chart version:

```bash
# Example for version 108.0.2
VERSION="108.0.2+up77.9.1-rancher.11"
IMAGE_TAG="108.0.2"
REGISTRY="your-registry.example.com"
IMAGE_NAME="rancher-monitoring-crd-installer"

docker build \
  --build-arg VERSION="${VERSION}" \
  --build-arg KUBECTL_VERSION=v1.30.0 \
  -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} \
  -f charts/rancher-monitoring-crd/Dockerfile \
  .
```

### 2. Push to Registry

```bash
docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
```

### 3. Build All Versions

Automated script to build all versions:

```bash
#!/bin/bash
REGISTRY="your-registry.example.com"
IMAGE_NAME="rancher-monitoring-crd-installer"

# 108.x series
for VERSION in "108.0.2+up77.9.1-rancher.11" "108.0.1+up77.9.1-rancher.10" "108.0.0+up77.9.1-rancher.6"; do
  IMAGE_TAG=$(echo $VERSION | cut -d'+' -f1)
  docker build --build-arg VERSION="${VERSION}" -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -f charts/rancher-monitoring-crd/Dockerfile .
  docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
done

# 107.x series
for VERSION in "107.2.2+up69.8.2-rancher.26" "107.2.1+up69.8.2-rancher.23" "107.2.0+up69.8.2-rancher.20" "107.1.0+up69.8.2-rancher.15" "107.0.0+up69.8.2-rancher.8"; do
  IMAGE_TAG=$(echo $VERSION | cut -d'+' -f1)
  docker build --build-arg VERSION="${VERSION}" -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} -f charts/rancher-monitoring-crd/Dockerfile .
  docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
done
```

## Update values.yaml

Update the `installer.image.repository` in values.yaml for each chart version:

```yaml
installer:
  image:
    repository: your-registry.example.com/rancher-monitoring-crd-installer
    tag: "108.0.2"  # Matches chart version
    pullPolicy: IfNotPresent
```

## Installation

### Standard Installation

```bash
helm install rancher-monitoring-crd \
  ./charts/rancher-monitoring-crd/108.0.2+up77.9.1-rancher.11 \
  --set installer.image.repository=your-registry.example.com/rancher-monitoring-crd-installer
```

### Bootstrap Installation (Before CNI)

The chart automatically uses host network and server-side apply:

```bash
helm install rancher-monitoring-crd \
  ./charts/rancher-monitoring-crd/108.0.2+up77.9.1-rancher.11 \
  --set installer.image.repository=your-registry.example.com/rancher-monitoring-crd-installer \
  --set rbac.create=true
```

### With Private Registry

```bash
kubectl create secret docker-registry my-registry-secret \
  --docker-server=your-registry.example.com \
  --docker-username=your-username \
  --docker-password=your-password

helm install rancher-monitoring-crd \
  ./charts/rancher-monitoring-crd/108.0.2+up77.9.1-rancher.11 \
  --set installer.image.repository=your-registry.example.com/rancher-monitoring-crd-installer \
  --set imagePullSecrets[0].name=my-registry-secret
```

## Cleanup

To enable CRD cleanup on uninstall (WARNING: deletes all CRDs and their resources):

```bash
helm install rancher-monitoring-crd \
  ./charts/rancher-monitoring-crd/108.0.2+up77.9.1-rancher.11 \
  --set installer.image.repository=your-registry.example.com/rancher-monitoring-crd-installer \
  --set cleanup.enabled=true
```

## Troubleshooting

### Check Job Status

```bash
kubectl get jobs -l app.kubernetes.io/name=rancher-monitoring-crd
kubectl logs -l app.kubernetes.io/name=rancher-monitoring-crd -c install-crds
```

### Check CRD Installation

```bash
kubectl get crds | grep monitoring.coreos.com
```

### Verify Image

```bash
docker run --rm your-registry.example.com/rancher-monitoring-crd-installer:108.0.2
```

## Architecture

- **Host Network**: Job runs with `hostNetwork: true` to work before CNI installation
- **Server-Side Apply**: Uses `kubectl apply --server-side=true --force-conflicts` for large CRD payloads
- **Helm Hooks**: RBAC created at weight -10, CRD installation at weight -5
- **Security**: Runs as non-root user (65534) with minimal privileges
