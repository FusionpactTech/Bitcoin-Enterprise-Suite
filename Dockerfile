# Multi-stage Dockerfile for Bitcoin Enterprise Suite

# Build stage
FROM rust:1.82-slim AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy workspace configuration files first
COPY Cargo.toml Cargo.lock ./
COPY deny.toml ./

# Copy library manifests
COPY libs/biscol/Cargo.toml ./libs/biscol/
COPY libs/cci-sat/Cargo.toml ./libs/cci-sat/
COPY libs/aicrm-sdk/Cargo.toml ./libs/aicrm-sdk/
COPY libs/imo-eo/Cargo.toml ./libs/imo-eo/

# Create dummy source files for dependency caching
RUN mkdir -p libs/biscol/src && echo "fn main() {}" > libs/biscol/src/lib.rs
RUN mkdir -p libs/cci-sat/src && echo "fn main() {}" > libs/cci-sat/src/lib.rs
RUN mkdir -p libs/aicrm-sdk/src && echo "fn main() {}" > libs/aicrm-sdk/src/lib.rs
RUN mkdir -p libs/imo-eo/src && echo "fn main() {}" > libs/imo-eo/src/lib.rs

# Build dependencies only
RUN cargo build --release --workspace

# Remove dummy source files
RUN rm -rf libs/*/src

# Copy actual source code
COPY libs/ ./libs/
COPY examples/ ./examples/

# Touch the source files to ensure rebuild
RUN find libs -name "*.rs" -exec touch {} \;

# Build the actual project
RUN cargo build --release --workspace

# Runtime stage
FROM debian:bookworm-slim AS runtime

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -u 1000 -s /bin/bash appuser

# Copy built artifacts from builder
COPY --from=builder /app/target/release/*.rlib /usr/local/lib/
COPY --from=builder /app/target/release/*.d /usr/local/lib/

# Set ownership and permissions
RUN chown -R appuser:appuser /usr/local/lib/

# Switch to non-root user
USER appuser

# Set library path
ENV LD_LIBRARY_PATH=/usr/local/lib

# Default command
CMD ["/bin/bash"]

# Security scanning stage (for CI/CD)
FROM rust:1.82-slim AS security-scanner

# Install security tools
RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install older versions of security tools that work with Rust 1.82
RUN cargo install --version 0.18.3 cargo-audit || true
RUN cargo install --version 0.13.1 cargo-deny || true
RUN cargo install --version 0.6.0 cargo-license || true

WORKDIR /app
COPY . .

# Run security checks
CMD ["cargo", "audit"]