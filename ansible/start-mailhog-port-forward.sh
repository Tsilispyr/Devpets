#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
NC='\033[0m' # No Color

# Make this script executable
chmod +x "$0"

echo "Starting MailHog port forwarding..."

# Check if MailHog port forwarding is already running
if pgrep -f "kubectl port-forward.*mailhog.*8025" >/dev/null; then
    echo -e "${BOLD_GREEN}OK! MailHog port forwarding is already running${NC}"
    echo -e "MailHog is accessible at: http://localhost:8025"
    exit 0
fi

# Kill any existing port forwarding processes
pkill -f "kubectl port-forward.*mailhog" 2>/dev/null || true

# Wait a moment for processes to be killed
sleep 2

# Start MailHog port forwarding
echo -e "${YELLOW}Starting MailHog port forwarding...${NC}"

# Start port forwarding in background
nohup kubectl port-forward svc/mailhog 8025:8025 -n devops-pets > /tmp/mailhog-port-forward.log 2>&1 &
MAILHOG_PF_PID=$!

# Wait for port forwarding to start
sleep 3

# Check if port forwarding is working
if curl -s http://localhost:8025 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! MailHog port forwarding started successfully (PID: $MAILHOG_PF_PID)${NC}"
    echo -e "MailHog is now accessible at: http://localhost:8025"
else
    echo -e "${BOLD_RED}ERR! Failed to start MailHog port forwarding${NC}"
    exit 1
fi

# Show current port forwarding processes
echo "=== Current MailHog port forwarding processes ==="
ps aux | grep "kubectl port-forward.*mailhog" | grep -v grep || echo "No MailHog port forwarding found" 