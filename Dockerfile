# Bitcoin Enterprise Suite - Production Dockerfile
# Multi-stage build for security and minimal attack surface

# Build stage
FROM rust:1.88-slim-bookworm AS builder

# Install security patches and build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user for build
RUN groupadd -r bitcoin && useradd -r -g bitcoin bitcoin

# Set up working directory
WORKDIR /build

# Copy dependency manifests
COPY Cargo.toml Cargo.lock ./
COPY deny.toml ./

# Copy workspace libraries
COPY libs/ libs/

# Build dependencies (cached layer)
RUN cargo fetch

# Copy source code
COPY . .

# Run security checks during build
RUN cargo audit --json > /tmp/audit-results.json || true
RUN cargo deny check

# Build release with security optimizations
RUN cargo build --release --locked \
    && strip target/release/*/deps/* 2>/dev/null || true

# Runtime stage
FROM debian:bookworm-slim AS runtime

# Install security patches and runtime dependencies only
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    tini \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/*

# Create non-privileged user
RUN groupadd -r -g 1001 bitcoin && \
    useradd -r -g bitcoin -u 1001 -s /bin/false -M bitcoin

# Create necessary directories
RUN mkdir -p /app/data /app/logs /app/config && \
    chown -R bitcoin:bitcoin /app

# Copy binaries from builder
COPY --from=builder --chown=bitcoin:bitcoin /build/target/release/*/bitcoin-* /app/bin/
COPY --from=builder --chown=bitcoin:bitcoin /tmp/audit-results.json /app/security/

# Copy configuration templates
COPY --chown=bitcoin:bitcoin scripts/docker/ /app/scripts/
COPY --chown=bitcoin:bitcoin docs/security/ /app/docs/

# Security hardening
USER bitcoin
WORKDIR /app

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD /app/scripts/healthcheck.sh || exit 1

# Security labels
LABEL org.opencontainers.image.title="Bitcoin Enterprise Suite"
LABEL org.opencontainers.image.description="Secure Bitcoin enterprise infrastructure"
LABEL org.opencontainers.image.vendor="Fusionpact Technologies Inc."
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.security.scan="trivy"

# Use tini as PID 1 for proper signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/app/scripts/start.sh"]

# Expose ports (documentation only - bind specific ports at runtime)
EXPOSE 8080 8443