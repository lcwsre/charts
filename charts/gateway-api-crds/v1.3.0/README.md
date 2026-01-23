# Gateway API CRDs Helm Chart

This Helm chart installs the Kubernetes Gateway API Custom Resource Definitions (CRDs) from the official [kubernetes-sigs/gateway-api](https://github.com/kubernetes-sigs/gateway-api) repository.

## Description

Gateway API is an official Kubernetes project focused on L4 and L7 routing in Kubernetes. This chart installs the standard channel CRDs required to use Gateway API with any conformant implementation (Cilium, Istio, Envoy Gateway, etc.).

## Gateway API Version

- **Gateway API Version**: 1.3.0
- **Bundle Version**: v1.3.1
- **Channel**: Standard

## Prerequisites

- Kubernetes 1.24+
- Helm 3.0+

## Installation

### Add the Helm repository

```bash
helm repo add lcwsre https://lcwsre.github.io/charts
helm repo update
```

### Install the chart

```bash
helm install gateway-api-crds lcwsre/gateway-api-crds
```

### Install with custom values

```bash
helm install gateway-api-crds lcwsre/gateway-api-crds \
  --set crds.grpcRoute.enabled=false
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gatewayAPIVersion` | Gateway API version | `"1.2.0"` |
| `crds.gatewayClass.enabled` | Install GatewayClass CRD | `true` |
| `crds.gateway.enabled` | Install Gateway CRD | `true` |
| `crds.httpRoute.enabled` | Install HTTPRoute CRD | `true` |
| `crds.grpcRoute.enabled` | Install GRPCRoute CRD | `true` |
| `crds.referenceGrant.enabled` | Install ReferenceGrant CRD | `true` |
| `commonLabels` | Labels to add to all CRDs | `{}` |
| `commonAnnotations` | Annotations to add to all CRDs | `{}` |

## Installed CRDs

This chart installs the following CRDs:

| CRD | Description | Scope |
|-----|-------------|-------|
| `GatewayClass` | Defines a class of Gateways | Cluster |
| `Gateway` | Represents an instance of a service-traffic handling infrastructure | Namespaced |
| `HTTPRoute` | Provides a way to route HTTP requests | Namespaced |
| `GRPCRoute` | Provides a way to route gRPC requests | Namespaced |
| `ReferenceGrant` | Allows cross-namespace references | Namespaced |

## Upgrading

### To upgrade the chart

```bash
helm upgrade gateway-api-crds lcwsre/gateway-api-crds
```

### Important Notes

- CRDs are cluster-scoped resources. Upgrading CRDs may affect all Gateway API resources in the cluster.
- Always review the Gateway API release notes before upgrading.
- Consider backing up existing Gateway API resources before upgrading.

## Uninstallation

```bash
helm uninstall gateway-api-crds
```

**Warning**: Uninstalling the chart will remove all Gateway API CRDs and **all Gateway API resources** (Gateways, HTTPRoutes, etc.) from your cluster.

## Compatibility

This chart is compatible with any Gateway API implementation that supports Gateway API v1.2.0, including:

- [Cilium](https://cilium.io/)
- [Istio](https://istio.io/)
- [Envoy Gateway](https://gateway.envoyproxy.io/)
- [Kong](https://konghq.com/)
- [NGINX Gateway Fabric](https://github.com/nginxinc/nginx-gateway-fabric)
- [Traefik](https://traefik.io/)

For a complete list of implementations, see [Gateway API Implementations](https://gateway-api.sigs.k8s.io/implementations/).

## Resources

- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Gateway API GitHub Repository](https://github.com/kubernetes-sigs/gateway-api)
- [Gateway API Release Notes](https://github.com/kubernetes-sigs/gateway-api/releases)

## License

This chart is provided under the Apache 2.0 License. Gateway API CRDs are maintained by the Kubernetes SIG-Network community.

## Maintainers

| Name | Email |
|------|-------|
| LCW SRE Team | lcwsre@lcwaikiki.com |
