#!/bin/bash
set -euo pipefail

# Bitcoin Enterprise Suite - Health Check Script
# Used by Docker HEALTHCHECK to monitor container health

# Configuration
readonly APP_DIR="/app"
readonly HEALTH_FILE="${APP_DIR}/.health"
readonly LOG_DIR="${APP_DIR}/logs"
readonly MAX_LOG_AGE=300  # 5 minutes in seconds

# Check if health file exists (created by start script)
if [[ ! -f "$HEALTH_FILE" ]]; then
    echo "UNHEALTHY: Health file missing - application may not be running"
    exit 1
fi

# Check if health file is recent (updated by application)
if [[ -n "$(find "$HEALTH_FILE" -type f -mtime +0.1 2>/dev/null)" ]]; then
    echo "UNHEALTHY: Health file is stale - application may be unresponsive"
    exit 1
fi

# Check if log directory is writable
if [[ ! -w "$LOG_DIR" ]]; then
    echo "UNHEALTHY: Log directory not writable"
    exit 1
fi

# Check for recent log activity (if logs exist)
if [[ -f "$LOG_DIR/bitcoin-enterprise-suite.log" ]]; then
    log_age=$(( $(date +%s) - $(stat -c %Y "$LOG_DIR/bitcoin-enterprise-suite.log" 2>/dev/null || echo 0) ))
    if [[ $log_age -gt $MAX_LOG_AGE ]]; then
        echo "UNHEALTHY: No recent log activity (${log_age}s ago)"
        exit 1
    fi
fi

# Check if any critical processes have crashed
if pgrep -f "bitcoin-enterprise" > /dev/null 2>&1; then
    echo "HEALTHY: Bitcoin Enterprise Suite is running"
    exit 0
else
    echo "UNHEALTHY: Bitcoin Enterprise Suite process not found"
    exit 1
fi