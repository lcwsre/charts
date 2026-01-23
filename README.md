# HQ GitOps - LCW SRE Helm Charts Repository

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Public Helm Charts repository maintained by LC Waikiki SRE Team.

## 🚀 Quick Start

Add this Helm repository:

```bash
helm repo add lcwsre https://lcwsre.github.io/hq-gitops
helm repo update
```

## 📦 Available Charts

### gateway-api-crds

Kubernetes Gateway API Custom Resource Definitions (CRDs) installer.

**Install:**
```bash
helm install gateway-api-crds lcwsre/gateway-api-crds
```

**Features:**
- Gateway API v1.2.0
- Standard CRDs: GatewayClass, Gateway, HTTPRoute, GRPCRoute, ReferenceGrant
- Configurable CRD installation (enable/disable individual CRDs)
- Compatible with Cilium, Istio, Envoy Gateway, and other Gateway API implementations

**Documentation:** [charts/gateway-api-crds/README.md](charts/gateway-api-crds/README.md)

## 🔍 Search Charts

```bash
helm search repo lcwsre
```

## 📖 Usage Examples

### Install Gateway API CRDs
```bash
helm install gateway-api-crds lcwsre/gateway-api-crds
```

### Install with custom configuration
```bash
helm install gateway-api-crds lcwsre/gateway-api-crds \
  --set crds.grpcRoute.enabled=false \
  --set commonLabels.team=platform
```

### Upgrade chart
```bash
helm upgrade gateway-api-crds lcwsre/gateway-api-crds
```

## 🏗️ Repository Structure

```
.
├── charts/
│   └── gateway-api-crds/      # Gateway API CRDs Helm Chart
├── docs/                       # GitHub Pages (Helm repo index)
│   ├── index.html             # Repository landing page
│   ├── index.yaml             # Helm repository index
│   └── *.tgz                  # Packaged charts
└── README.md                  # This file
```

## 🛠️ Development

### Prerequisites
- Helm 3.0+
- Git

### Adding/Updating Charts

1. Make changes to charts in `charts/` directory
2. Update chart version in `Chart.yaml`
3. Package the chart:
   ```bash
   tar -czf docs/<chart-name>-<version>.tgz -C charts <chart-name>
   ```
4. Update repository index:
   ```bash
   helm repo index docs/ --url https://lcwsre.github.io/hq-gitops/
   ```
5. Commit and push changes

### Testing Charts Locally

```bash
# Lint chart
helm lint charts/gateway-api-crds

# Test installation
helm install test-release charts/gateway-api-crds --dry-run --debug

# Template rendering
helm template test-release charts/gateway-api-crds
```

## 📋 Requirements

- **Kubernetes**: 1.24+
- **Helm**: 3.0+

## 🔗 Links

- [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/)
- [Helm Documentation](https://helm.sh/docs/)
- [LC Waikiki](https://www.lcwaikiki.com/)

## 📝 License

Apache License 2.0

## 👥 Maintainers

**LCW SRE Team**
- Email: lcwsre@lcwaikiki.com

## 🤝 Contributing

This is a public repository. Contributions, issues, and feature requests are welcome!

## 📊 GitHub Pages Setup

This repository uses GitHub Pages to host the Helm repository:

1. Go to repository Settings → Pages
2. Set Source to: **Deploy from a branch**
3. Select branch: **main** (or **master**)
4. Select folder: **/docs**
5. Save

The Helm repository will be available at: `https://lcwsre.github.io/hq-gitops/`

---

Made with ❤️ by LCW SRE Team
