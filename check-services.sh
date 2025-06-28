#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
NC='\033[0m' # No Color

echo "=== DevOps Pets Complete Status ==="

# Check Jenkins
echo "Jenkins Status:"
if curl -s http://localhost:8082 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! Jenkins is running at http://localhost:8082${NC}"
else
    echo -e "${BOLD_RED}ERR! Jenkins is not accessible${NC}"
fi

# Check Jenkins port forwarding
echo ""
echo "Jenkins Port Forwarding:"
if pgrep -f "kubectl port-forward.*jenkins" >/dev/null; then
    echo -e "${BOLD_GREEN}OK! Jenkins port forwarding is active${NC}"
    pgrep -f "kubectl port-forward.*jenkins"
else
    echo -e "${BOLD_RED}ERR! Jenkins port forwarding not found${NC}"
fi

# Check MailHog
echo ""
echo "MailHog Status:"
if curl -s http://localhost:8025 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! MailHog is running at http://localhost:8025${NC}"
else
    echo -e "${BOLD_RED}ERR! MailHog is not accessible${NC}"
fi

# Check MailHog port forwarding
echo ""
echo "MailHog Port Forwarding:"
if pgrep -f "kubectl port-forward.*mailhog" >/dev/null; then
    echo -e "${BOLD_GREEN}OK! MailHog port forwarding is active${NC}"
    pgrep -f "kubectl port-forward.*mailhog"
else
    echo -e "${BOLD_RED}ERR! MailHog port forwarding not found${NC}"
fi

# Check Frontend (if deployed)
echo ""
echo "Frontend Status:"
if curl -s http://localhost:8081 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! Frontend is running at http://localhost:8081${NC}"
else
    echo -e "${YELLOW}Frontend is not accessible (may not be deployed)${NC}"
fi

# Check Backend (if deployed)
echo ""
echo "Backend Status:"
if curl -s http://localhost:8080 >/dev/null 2>&1; then
    echo -e "${BOLD_GREEN}OK! Backend is running at http://localhost:8080${NC}"
else
    echo -e "${YELLOW}Backend is not accessible (may not be deployed)${NC}"
fi

# Check Kubernetes cluster
echo ""
echo "Kubernetes Cluster:"
if kind get clusters | grep -q devops-pets; then
    echo -e "${BOLD_GREEN}OK! Kind cluster 'devops-pets' exists${NC}"
else
    echo -e "${BOLD_RED}ERR! Kind cluster 'devops-pets' not found${NC}"
fi

# Check Kubernetes pods
echo ""
echo "Kubernetes Pods in devops-pets namespace:"
if kubectl get namespace devops-pets >/dev/null 2>&1; then
    kubectl get pods -n devops-pets
    echo ""
    echo "Kubernetes Services:"
    kubectl get svc -n devops-pets
    echo ""
    echo "Kubernetes Deployments:"
    kubectl get deployments -n devops-pets
else
    echo -e "${BOLD_RED}ERR! Namespace 'devops-pets' not found${NC}"
fi

echo ""
echo "Useful commands:"
echo "Check cluster: kind get clusters"
echo "Check pods: kubectl get pods -n devops-pets"
echo "View logs: kubectl logs <pod-name> -n devops-pets"
echo "Stop port forwarding: pkill -f 'kubectl port-forward'"
echo ""
echo "Port Forwarding Processes:"
if pgrep -f "kubectl port-forward" >/dev/null; then
    pgrep -f "kubectl port-forward" -l
else
    echo -e "${YELLOW}No port forwarding processes found${NC}"
fi 