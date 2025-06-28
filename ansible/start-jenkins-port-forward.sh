#!/bin/bash

# Make this script executable
chmod +x "$0"

echo "Starting Jenkins port forwarding..."

# Check if Jenkins port forwarding is already running
if ps aux | grep -q "kubectl port-forward.*jenkins.*8082"; then
  echo "✅ Jenkins port forwarding is already running"
  echo "🔧 Jenkins is accessible at: http://localhost:8082"
  exit 0
fi

# Kill any existing port-forward processes for Jenkins
pkill -f "kubectl port-forward.*jenkins" 2>/dev/null || true

# Check if port 8082 is already in use
if netstat -tuln | grep -q ":8082 "; then
  echo "Port 8082 is already in use, killing existing process..."
  sudo lsof -ti:8082 | xargs kill -9 2>/dev/null || true
fi

# Start port forwarding for Jenkins HTTP interface
echo "Starting kubectl port-forward for Jenkins..."
nohup kubectl port-forward svc/jenkins 8082:8080 -n devops-pets > /tmp/jenkins-port-forward.log 2>&1 &
JENKINS_PF_PID=$!

# Wait for port forwarding to be actually working
echo "Waiting for Jenkins port forwarding to be ready..."
timeout 30 bash -c 'until curl -s http://localhost:8082 >/dev/null 2>&1; do echo "Waiting for Jenkins port forwarding..."; done'

if [ $? -eq 0 ]; then
  echo "✅ Jenkins port forwarding started successfully (PID: $JENKINS_PF_PID)"
  echo "🔧 Jenkins is now accessible at: http://localhost:8082"
else
  echo "❌ Failed to start Jenkins port forwarding"
  echo "Check logs: cat /tmp/jenkins-port-forward.log"
  exit 1
fi

# Show current port forwarding processes
echo "=== Current Jenkins port forwarding processes ==="
ps aux | grep "kubectl port-forward.*jenkins" | grep -v grep || echo "No Jenkins port forwarding found" 