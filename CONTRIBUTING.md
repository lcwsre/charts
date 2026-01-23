# Contributing to HQ GitOps

Thank you for your interest in contributing to the LCW SRE Helm Charts repository! 🎉

## How to Contribute

### Reporting Issues

- Use GitHub Issues to report bugs or request features
- Provide clear descriptions and steps to reproduce
- Include relevant Kubernetes and Helm versions

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Update chart version in `Chart.yaml`
   - Update `README.md` if needed
   - Follow Helm best practices

4. **Test your changes**
   ```bash
   helm lint charts/your-chart
   helm template test charts/your-chart
   ```

5. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**

## Chart Development Guidelines

### Chart Structure

```
charts/your-chart/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration
├── README.md          # Chart documentation
├── .helmignore        # Files to ignore when packaging
└── templates/         # Kubernetes manifests
    ├── _helpers.tpl   # Template helpers
    └── *.yaml         # Resource definitions
```

### Versioning

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible API changes
- **MINOR**: Add functionality (backwards compatible)
- **PATCH**: Bug fixes (backwards compatible)

### Chart.yaml Requirements

```yaml
apiVersion: v2
name: chart-name
description: Clear description
type: application
version: 1.0.0
appVersion: "1.0.0"
keywords:
  - keyword1
  - keyword2
maintainers:
  - name: LCW SRE Team
    email: lcwsre@lcwaikiki.com
```

### values.yaml Guidelines

- Provide sensible defaults
- Document all values with comments
- Use camelCase for value names
- Group related values together

### Template Best Practices

1. **Use helpers** for repeated logic
2. **Add labels** to all resources
3. **Make resources configurable** via values
4. **Include resource limits** by default
5. **Use `if` statements** for optional resources

Example:
```yaml
{{- if .Values.serviceAccount.create -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "chart.serviceAccountName" . }}
  labels:
    {{- include "chart.labels" . | nindent 4 }}
{{- end }}
```

### Testing

Before submitting:

```bash
# Lint the chart
helm lint charts/your-chart

# Dry-run installation
helm install test charts/your-chart --dry-run --debug

# Template rendering
helm template test charts/your-chart

# Test with custom values
helm install test charts/your-chart -f test-values.yaml --dry-run
```

### Documentation

- Update chart README.md
- Document all configurable values
- Provide usage examples
- Include prerequisites

## Release Process

Charts are automatically released when:
1. Changes are merged to `main` branch
2. Changes are in `charts/**` directory

The CI/CD pipeline will:
1. Package the chart
2. Update repository index
3. Deploy to GitHub Pages

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community

## Questions?

Contact the LCW SRE Team at lcwsre@lcwaikiki.com

---

Thank you for contributing! 🙏
