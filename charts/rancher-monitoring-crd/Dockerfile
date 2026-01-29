# Rancher Monitoring CRD Installer Image
# This image contains CRDs and kubectl for server-side apply installation
# Build this image for each chart version and push to your registry

ARG KUBECTL_VERSION=v1.30.0

FROM rancher/kubectl:${KUBECTL_VERSION}

# Install gzip for potential compression support
USER root
RUN apk add --no-cache gzip ca-certificates

# Copy CRD files
# NOTE: You must specify the version directory when building
# Example: docker build --build-arg VERSION=108.0.2+up77.9.1-rancher.11 -t registry/rancher-monitoring-crd-installer:108.0.2 .
ARG VERSION
COPY charts/rancher-monitoring-crd/${VERSION}/crds/*.yaml /crds/

# Verify CRDs are present
RUN ls -lh /crds/ && \
    echo "Total CRD count: $(ls -1 /crds/ | wc -l)" && \
    echo "Total CRD size: $(du -sh /crds/)"

# Switch to non-root user
USER 65534:65534

# Verify kubectl works
RUN kubectl version --client=true

# Default command (overridden by Job)
CMD ["/bin/sh", "-c", "ls -lh /crds/ && echo 'CRDs ready for installation'"]
