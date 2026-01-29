# Installation Instructions

Due to Helm's 1MB Secret size limit, the compressed CRDs must be installed separately before the chart.

## Step 1: Create CRD ConfigMap

```bash
kubectl create configmap rancher-monitoring-crd-crds \
  --from-file=crds.gz=crds.gz.b64 \
  --namespace kube-system \
  --dry-run=client -o yaml | kubectl apply -f -
```

Or using the pre-created manifest:

```bash
kubectl apply -f pre-install-configmap.yaml
```

## Step 2: Install Chart

```bash
helm install rancher-monitoring-crd ./rancher-monitoring-crd-108.0.2+up77.9.1-rancher.11 \
  --namespace kube-system \
  --set embeddedCRDs=false
```

## Why This Approach?

Helm stores the entire chart content in a Secret (`sh.helm.release.v1.*`), which has a 1MB size limit.
Our compressed CRDs (~539KB) + chart templates (~20KB) exceed this limit when Helm compresses everything together.

By creating the ConfigMap separately, it doesn't count towards the Helm release Secret size.
