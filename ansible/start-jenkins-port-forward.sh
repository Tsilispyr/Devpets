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

echo "Starting Jenkins port forwarding..."

# Check if Jenkins port forwarding is already running
if pgrep -f "kubectl port-forward.*jenkins.*8082" >/dev/null; then
    echo -e "${BOLD_GREEN}OK! Jenkins port forwarding is already running${NC}"
    echo -e "Jenkins is accessible at: http://localhost:8082"
    exit 0
fi

# Kill any existing port forwarding processes
pkill -f "kubectl port-forward.*jenkins" 2>/dev/null || true

# Wait a moment for processes to be killed
sleep 2

# Start Jenkins port forwarding
echo -e "${YELLOW}Starting Jenkins port forwarding...${NC}"

# Start port forwarding in background
nohup kubectl port-forward svc/jenkins 8082:8080 -n devops-pets > /tmp/jenkins-port-forward.log 2>&1 &
JENKINS_PF_PID=$!

# Wait for port forwarding to start
sleep 3

# Check if port forwarding is working
if curl -s http://localhost:8082 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! Jenkins port forwarding started successfully (PID: $JENKINS_PF_PID)${NC}"
    echo -e "Jenkins is now accessible at: http://localhost:8082"
else
    echo -e "${BOLD_RED}ERR! Failed to start Jenkins port forwarding${NC}"
    exit 1
fi

# Show current port forwarding processes
echo "=== Current Jenkins port forwarding processes ==="
ps aux | grep "kubectl port-forward.*jenkins" | grep -v grep || echo "No Jenkins port forwarding found" 