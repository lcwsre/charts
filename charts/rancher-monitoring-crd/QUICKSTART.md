# Rancher Monitoring CRD Charts - Quick Start

## Problem Solved

Helm has a 1MB Secret size limit. Our compressed CRDs (~400-540KB) + chart templates cause the total Helm release to exceed this limit, resulting in:

```
Error: Secret "sh.helm.release.v1.rancher-monitoring-crd.v1" is invalid: 
data: Too long: may not be more than 1048576 bytes
```

## Solution

CRDs are stored in a separate ConfigMap that must be created before chart installation.

## Installation Steps

### 1. Create CRD ConfigMap

```bash
kubectl apply -f https://raw.githubusercontent.com/lcwsre/charts/main/charts/rancher-monitoring-crd/[VERSION]/pre-install-configmap.yaml
```

Replace `[VERSION]` with your desired version, e.g., `108.0.2+up77.9.1-rancher.11`

Or create locally:

```bash
cd charts/rancher-monitoring-crd/[VERSION]
kubectl create configmap rancher-monitoring-crd-crds \
  --from-file=crds.gz=crds.gz.b64 \
  --namespace kube-system
```

### 2. Install Chart

```bash
helm install rancher-monitoring-crd lcwsre-repo/rancher-monitoring-crd \
  --version [VERSION] \
  --namespace kube-system
```

The chart automatically references the pre-created ConfigMap.

## Available Versions

| Version | Prometheus Operator | CRD Size (Compressed) |
|---------|-------------------|----------------------|
| 108.0.2+up77.9.1-rancher.11 | v0.85.0 | 539 KB |
| 108.0.1+up77.9.1-rancher.10 | v0.85.0 | 539 KB |
| 108.0.0+up77.9.1-rancher.6  | v0.85.0 | 539 KB |
| 107.2.2+up69.8.2-rancher.26 | v0.80.1 | 383 KB |
| 107.2.1+up69.8.2-rancher.23 | v0.80.1 | 383 KB |
| 107.2.0+up69.8.2-rancher.20 | v0.80.1 | 383 KB |
| 107.1.0+up69.8.2-rancher.15 | v0.80.1 | 383 KB |
| 107.0.0+up69.8.2-rancher.8  | v0.80.1 | 383 KB |

## Architecture

```
┌─────────────────────────────────────┐
│ Pre-Installation (Manual)           │
├─────────────────────────────────────┤
│ kubectl apply -f                    │
│   pre-install-configmap.yaml        │
│                                     │
│ Creates ConfigMap with compressed   │
│ CRDs (~400-540KB)                   │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│ Helm Install (Automated)            │
├─────────────────────────────────────┤
│ 1. ServiceAccount + RBAC (~1KB)     │
│ 2. Job (hook weight: -5) (~4KB)    │
│    - Mounts existing ConfigMap      │
│    - Decompresses CRDs              │
│    - kubectl apply --server-side    │
│                                     │
│ Total Helm Secret: ~6KB ✓           │
└─────────────────────────────────────┘
```

## Why Not Embedded?

Setting `embeddedCRDs=true` includes the compressed CRDs in the Helm chart package, which:
- Increases chart size from ~6KB to ~1.2MB
- Causes Helm release Secret to exceed 1MB limit
- Results in installation failure

## Upgrade Process

The same ConfigMap is reused during upgrades. If CRDs change between versions:

```bash
# Update ConfigMap
kubectl delete configmap rancher-monitoring-crd-crds -n kube-system
kubectl apply -f pre-install-configmap.yaml

# Upgrade chart
helm upgrade rancher-monitoring-crd lcwsre-repo/rancher-monitoring-crd \
  --version [NEW_VERSION] \
  --namespace kube-system
```

## Uninstallation

```bash
# Remove chart
helm uninstall rancher-monitoring-crd -n kube-system

# Remove ConfigMap
kubectl delete configmap rancher-monitoring-crd-crds -n kube-system

# Optional: Remove CRDs (will delete all monitoring resources!)
kubectl delete crd \
  alertmanagerconfigs.monitoring.coreos.com \
  alertmanagers.monitoring.coreos.com \
  podmonitors.monitoring.coreos.com \
  probes.monitoring.coreos.com \
  prometheusagents.monitoring.coreos.com \
  prometheuses.monitoring.coreos.com \
  prometheusrules.monitoring.coreos.com \
  scrapeconfigs.monitoring.coreos.com \
  servicemonitors.monitoring.coreos.com \
  thanosrulers.monitoring.coreos.com
```
