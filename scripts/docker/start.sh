#!/bin/bash
set -euo pipefail

# Bitcoin Enterprise Suite - Container Startup Script
# Security-focused initialization for production deployment

# Configuration
readonly APP_DIR="/app"
readonly CONFIG_DIR="${APP_DIR}/config"
readonly DATA_DIR="${APP_DIR}/data"
readonly LOG_DIR="${APP_DIR}/logs"

# Logging function
log() {
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] [STARTUP] $*" >&2
}

# Security validation
validate_environment() {
    log "Validating security environment..."
    
    # Check if running as non-root user
    if [[ $(id -u) -eq 0 ]]; then
        log "ERROR: Container is running as root user. This is a security risk."
        exit 1
    fi
    
    # Validate directory permissions
    if [[ ! -w "$DATA_DIR" ]] || [[ ! -w "$LOG_DIR" ]]; then
        log "ERROR: Insufficient permissions for data/log directories."
        exit 1
    fi
    
    # Check for required environment variables
    if [[ -z "${BITCOIN_NETWORK:-}" ]]; then
        log "WARNING: BITCOIN_NETWORK not set, defaulting to mainnet"
        export BITCOIN_NETWORK="mainnet"
    fi
    
    log "Security validation completed."
}

# Initialize application
initialize_app() {
    log "Initializing Bitcoin Enterprise Suite..."
    
    # Create runtime directories if they don't exist
    mkdir -p "$CONFIG_DIR" "$DATA_DIR" "$LOG_DIR"
    
    # Set proper permissions
    chmod 750 "$CONFIG_DIR" "$DATA_DIR" "$LOG_DIR"
    
    # Initialize configuration if not present
    if [[ ! -f "$CONFIG_DIR/config.toml" ]]; then
        log "Creating default configuration..."
        cat > "$CONFIG_DIR/config.toml" << EOF
[bitcoin]
network = "${BITCOIN_NETWORK}"
data_dir = "${DATA_DIR}"

[logging]
level = "info"
file = "${LOG_DIR}/bitcoin-enterprise-suite.log"

[security]
audit_enabled = true
tls_enabled = true
EOF
    fi
    
    log "Application initialization completed."
}

# Start health monitoring
start_health_monitor() {
    log "Starting health monitoring..."
    # This will be monitored by Docker's HEALTHCHECK
    touch "$APP_DIR/.health"
}

# Signal handlers for graceful shutdown
shutdown_handler() {
    log "Received shutdown signal, performing graceful shutdown..."
    rm -f "$APP_DIR/.health"
    # Add any cleanup logic here
    exit 0
}

# Set up signal handlers
trap shutdown_handler SIGTERM SIGINT

# Main execution
main() {
    log "Starting Bitcoin Enterprise Suite container..."
    
    validate_environment
    initialize_app
    start_health_monitor
    
    log "Container startup completed successfully."
    log "Bitcoin Enterprise Suite is ready to serve requests."
    
    # Keep the container running and wait for signals
    while [[ -f "$APP_DIR/.health" ]]; do
        sleep 30
    done
}

# Execute main function
main "$@"