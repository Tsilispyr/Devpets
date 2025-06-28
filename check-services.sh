#!/bin/bash

echo "=== DevOps Pets Services Status ==="
echo ""

# Check Jenkins
echo "🔧 Jenkins Status:"
if curl -s http://localhost:8082 >/dev/null; then
    echo "✅ Jenkins is running at http://localhost:8082"
else
    echo "❌ Jenkins is not accessible"
fi

# Check Jenkins container
echo ""
echo "🐳 Jenkins Container:"
if docker ps | grep -q jenkins; then
    docker ps | grep jenkins
else
    echo "❌ Jenkins container not running"
fi

# Check MailHog
echo ""
echo "📧 MailHog Status:"
if curl -s http://localhost:8025 >/dev/null; then
    echo "✅ MailHog is running at http://localhost:8025"
else
    echo "❌ MailHog is not accessible"
fi

# Check MailHog port forwarding
echo ""
echo "🔗 MailHog Port Forwarding:"
if ps aux | grep -q "kubectl port-forward.*mailhog"; then
    echo "✅ MailHog port forwarding is active"
    ps aux | grep "kubectl port-forward.*mailhog" | grep -v grep
else
    echo "❌ MailHog port forwarding not found"
fi

# Check Kubernetes cluster
echo ""
echo "☸️  Kubernetes Cluster:"
if kind get clusters | grep -q devops-pets; then
    echo "✅ Kind cluster 'devops-pets' exists"
else
    echo "❌ Kind cluster 'devops-pets' not found"
fi

# Check namespace and pods
echo ""
echo "📦 Kubernetes Pods in devops-pets namespace:"
if kubectl get namespace devops-pets >/dev/null 2>&1; then
    kubectl get pods -n devops-pets
else
    echo "❌ Namespace 'devops-pets' not found"
fi

# Check services
echo ""
echo "🌐 Kubernetes Services:"
if kubectl get namespace devops-pets >/dev/null 2>&1; then
    kubectl get services -n devops-pets
else
    echo "❌ Cannot check services - namespace not found"
fi

echo ""
echo "=== Quick Access Links ==="
echo "Jenkins: http://localhost:8082"
echo "MailHog: http://localhost:8025"
echo ""
echo "=== Useful Commands ==="
echo "Restart Jenkins: ./start-jenkins-with-tools.sh"
echo "View Jenkins logs: docker logs jenkins-devops-pets"
echo "Check cluster: kind get clusters"
echo "Check pods: kubectl get pods -n devops-pets" 