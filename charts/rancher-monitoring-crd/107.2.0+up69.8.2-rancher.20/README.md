# rancher-monitoring-crd

Prometheus Operator CRDs (Custom Resource Definitions) for Rancher Monitoring - Version 108.0.2

## Overview

This Helm chart installs Prometheus Operator v0.85.0 CRDs using a **ConfigMap-based Job with server-side apply**, specifically designed to:

- ✅ Support **bootstrap scenarios** (works before CNI is available with `hostNetwork: true`)
- ✅ Handle **large CRD payloads** (~4MB compressed to ~539KB) efficiently
- ✅ Use **kubectl server-side apply** for robust conflict resolution
- ✅ Enable **declarative updates** via Helm hooks
- ✅ **No custom Docker images required** - uses ready-made kubectl image

## How does this chart work?

This chart uses a ConfigMap-based approach for CRD installation:

### Architecture

1. **CRDs compressed in ConfigMap** (gzip + base64, ~539KB) created via Helm hook
2. **Helm hook Job** (pre-install/pre-upgrade) decompresses and applies CRDs
3. **Ready-made kubectl image** (`rancher/kuberlr-kubectl:v6.0.0`) - no custom builds needed
4. **Host network mode** ensures compatibility with bootstrap scenarios (before CNI)
5. **RBAC resources** (ServiceAccount, ClusterRole, ClusterRoleBinding) created via hooks
6. **Optional cleanup Job** (post-delete) removes CRDs on uninstall

### Why this approach?

**Problem**: Direct CRD templates in Helm create two issues:
- **Helm Secret limit**: 11MB of CRDs exceed Helm's 1MB Secret storage limit
- **Bootstrap chicken-egg**: Standard pods require CNI, but CRDs are often needed before CNI installation

**Solution**: ConfigMap + Job installer:
- CRDs compressed in ConfigMap (~87% reduction) → Within ConfigMap limits
- Job decompresses and splits CRDs → No Helm Secret bloat
- `hostNetwork: true` → Works before CNI available
- Server-side apply → Handles large payloads efficiently
- Ready-made kubectl image → No custom image builds required

## Prerequisites

**No prerequisites!** This chart uses ready-made `rancher/kuberlr-kubectl:v6.0.0` image.

### 2. Registry Access

Ensure your cluster can pull from your container registry. For private registries, create an image pull secret.

## Installation

## Installation

### Standard Installation

```bash
helm install rancher-monitoring-crd . \
  --namespace cattle-monitoring-system \
  --create-namespace
```

### Bootstrap (Before CNI)

The chart automatically uses `hostNetwork: true`:

```bash
helm install rancher-monitoring-crd . \
  --namespace cattle-monitoring-system \
  --create-namespace
```

### Private Registry (Rancher)

For air-gapped Rancher deployments:

```bash
helm install rancher-monitoring-crd . \
  --set global.cattle.systemDefaultRegistry=your-registry.example.com \
  --namespace cattle-monitoring-system \
  --create-namespace
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | kubectl image repository | `rancher/kuberlr-kubectl` |
| `image.tag` | Image tag | `v6.0.0` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `256Mi` |
| `installer.resources.requests.cpu` | CPU request | `100m` |
| `installer.resources.requests.memory` | Memory request | `128Mi` |
| `rbac.create` | Create RBAC resources | `true` |
| `rbac.serviceAccountName` | Service account (if rbac.create=false) | `""` |
| `cleanup.enabled` | Enable CRD cleanup on uninstall ⚠️ | `false` |
| `imagePullSecrets` | Image pull secrets | `[]` |
| `nodeSelector` | Node selector | `{}` |
| `tolerations` | Tolerations | `[]` |
| `affinity` | Affinity | `{}` |

## CRDs Included (10 total)

- `alertmanagerconfigs.monitoring.coreos.com`
- `alertmanagers.monitoring.coreos.com`
- `podmonitors.monitoring.coreos.com`
- `probes.monitoring.coreos.com`
- `prometheusagents.monitoring.coreos.com`
- `prometheuses.monitoring.coreos.com`
- `prometheusrules.monitoring.coreos.com`
- `scrapeconfigs.monitoring.coreos.com`
- `servicemonitors.monitoring.coreos.com`
- `thanosrulers.monitoring.coreos.com`

## Verification

```bash
# Check Job status
kubectl get jobs -l app.kubernetes.io/name=rancher-monitoring-crd

# Check Job logs
kubectl logs -l app.kubernetes.io/name=rancher-monitoring-crd -c install-crds

# Verify CRDs installed
kubectl get crds | grep monitoring.coreos.com
```

## Cleanup

### Uninstall (Keep CRDs - Default)

```bash
helm uninstall rancher-monitoring-crd
```

CRDs persist after uninstall.

### Uninstall (Remove CRDs)

⚠️ **WARNING**: This DELETES all CRDs and their custom resources!

```bash
# Enable cleanup on install
helm install rancher-monitoring-crd . \
  --set installer.image.repository=your-registry/rancher-monitoring-crd-installer \
  --set cleanup.enabled=true

# CRDs will be deleted on uninstall
helm uninstall rancher-monitoring-crd
```

## Why can't we just place the CRDs in templates/?

**Helm's limitation**: In Helm, you cannot declare a CRD and a resource of that CRD's kind in the same render cycle without encountering failures.

## [Helm 3] Why can't we use the crds/ directory?

**Two issues**:
1. **Size limit**: Helm 3's `crds/` directory still faces the 1MB Secret limit for large CRD sets
2. **No updates**: The `crds/` directory only supports installation, not upgrades or removal

## Troubleshooting

### Image Pull Failures

```bash
kubectl get events --sort-by='.lastTimestamp'
kubectl describe pod -l app.kubernetes.io/name=rancher-monitoring-crd
```

### RBAC Errors

```bash
helm upgrade rancher-monitoring-crd . --set rbac.create=true
```

### CRD Application Failures

```bash
kubectl logs -l app.kubernetes.io/name=rancher-monitoring-crd -c install-crds
```

## Next Steps

Install Prometheus Operator:

```bash
helm install rancher-monitoring rancher-monitoring/rancher-monitoring \
  --namespace cattle-monitoring-system
```

## Resources

- [Prometheus Operator](https://prometheus-operator.dev/)
- [BUILD.md](../../BUILD.md) - Image build instructions
- [Helm Documentation](https://helm.sh/docs/)
