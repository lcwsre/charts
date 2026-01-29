# rancher-monitoring-crd
A Rancher chart that installs the CRDs used by rancher-monitoring.

## Installation

```bash
helm repo add lcwsre-repo https://eyupguner.github.io/charts/
helm install rancher-monitoring-crd lcwsre-repo/rancher-monitoring-crd \
  --version 108.0.0+up77.9.1-rancher.6 \
  --namespace cattle-monitoring-system \
  --create-namespace
```

## Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.cattle.systemDefaultRegistry` | Private registry prefix | `""` |
| `image.repository` | kubectl image repository | `rancher/kuberlr-kubectl` |
| `image.tag` | kubectl image tag | `v6.0.0` |
| `nodeSelector` | Node selector for job pods | `{}` |
| `tolerations` | Tolerations for job pods | `[]` |

## Architecture

- CRDs are compressed with bzip2 and stored in `monitoring-crd/crds.bz2`
- ConfigMap embeds the compressed CRDs as base64
- Jobs decompress and apply CRDs using kubectl
- Supports hostNetwork for bootstrap scenarios (before CNI)

## How does this chart work?

This chart marshalls all of the CRD files placed in the `crd-manifest` directory into a ConfigMap that is installed onto a cluster alongside relevant RBAC (ServiceAccount, ClusterRoleBinding, ClusterRole, and PodSecurityPolicy).

Once the relevant dependent resourcees are installed / upgraded / rolled back, this chart executes a post-install / post-upgrade / post-rollback Job that:
- Patches any existing versions of the CRDs contained within the `crd-manifest` on the cluster to set `spec.preserveUnknownFields=false`; this step is required since, based on [Kubernetes docs](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#field-pruning) and a [known workaround](https://github.com/kubernetes-sigs/controller-tools/issues/476#issuecomment-691519936), such CRDs cannot be upgraded normally from `apiextensions.k8s.io/v1beta1` to `apiextensions.k8s.io/v1`.
- Runs a `kubectl apply` on the CRDs that are contained within the crd-manifest ConfigMap to upgrade CRDs in the cluster

On an uninstall, this chart executes a separate post-delete Job that:
- Patches any existing versions of the CRDs contained within `crd-manifest` on the cluster to set `metadata.finalizers=[]`
- Runs a `kubectl delete` on the CRDs that are contained within the crd-manifest ConfigMap to clean up the CRDs from the cluster

Note: If the relevant CRDs already existed in the cluster at the time of install, this chart will absorb ownership of the lifecycle of those CRDs; therefore, on a `helm uninstall`, those CRDs will also be removed from the cluster alongside this chart.

## Why can't we just place the CRDs in the templates/ directory of the main chart?

In Helm today, you cannot declare a CRD and declare a resource of that CRD's kind in templates/ without encountering a failure on render.

## [Helm 3] Why can't we just place the CRDs in the crds/ directory of the main chart?

The Helm 3 `crds/` directory only supports the installation of CRDs, but does not support the upgrade and removal of CRDs, unlike what this chart facilitiates.