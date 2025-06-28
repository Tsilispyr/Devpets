#!/bin/bash

# Make this script executable
chmod +x "$0"

echo "Starting MailHog port forwarding..."

# Check if port forwarding is already running
if ps aux | grep -q "kubectl port-forward.*mailhog.*8025"; then
  echo "✅ MailHog port forwarding is already running"
  echo "📧 MailHog is accessible at: http://localhost:8025"
  exit 0
fi

# Kill any existing port-forward processes for MailHog
pkill -f "kubectl port-forward.*mailhog" 2>/dev/null || true

# Check if port 8025 is already in use
if netstat -tuln | grep -q ":8025 "; then
  echo "Port 8025 is already in use, killing existing process..."
  sudo lsof -ti:8025 | xargs kill -9 2>/dev/null || true
fi

# Start port forwarding for MailHog HTTP interface
echo "Starting kubectl port-forward for MailHog..."
nohup kubectl port-forward svc/mailhog 8025:8025 -n devops-pets > /tmp/mailhog-port-forward.log 2>&1 &
MAILHOG_PF_PID=$!

# Wait for port forwarding to be actually working
echo "Waiting for MailHog port forwarding to be ready..."
timeout 30 bash -c 'until curl -s http://localhost:8025 >/dev/null 2>&1; do echo "Waiting for MailHog port forwarding..."; done'

if [ $? -eq 0 ]; then
  echo "✅ MailHog port forwarding started successfully (PID: $MAILHOG_PF_PID)"
  echo "📧 MailHog is now accessible at: http://localhost:8025"
else
  echo "❌ Failed to start MailHog port forwarding"
  echo "Check logs: cat /tmp/mailhog-port-forward.log"
  exit 1
fi

# Show current port forwarding processes
echo "=== Current MailHog port forwarding processes ==="
ps aux | grep "kubectl port-forward.*mailhog" | grep -v grep || echo "No MailHog port forwarding found" 