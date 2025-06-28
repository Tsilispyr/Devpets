#!/bin/bash

echo "=== Comprehensive System Cleanup ==="

# Make this script executable
chmod +x "$0"

echo "Step 1: Stopping all port forwarding processes..."
pkill -f "kubectl port-forward" 2>/dev/null || true

echo "Step 2: Stopping all Jenkins containers..."
docker stop $(docker ps -q --filter "ancestor=jenkins/jenkins:lts") 2>/dev/null || true
docker rm $(docker ps -aq --filter "ancestor=jenkins/jenkins:lts") 2>/dev/null || true

echo "Step 3: Stopping all containers in devops-pets namespace..."
kubectl delete pods --all -n devops-pets 2>/dev/null || true

echo "Step 4: Deleting all deployments in devops-pets namespace..."
kubectl delete deployment --all -n devops-pets 2>/dev/null || true

echo "Step 5: Deleting all services in devops-pets namespace..."
kubectl delete service --all -n devops-pets 2>/dev/null || true

echo "Step 6: Deleting all PVCs in devops-pets namespace..."
kubectl delete pvc --all -n devops-pets 2>/dev/null || true

echo "Step 7: Deleting all secrets in devops-pets namespace..."
kubectl delete secret --all -n devops-pets 2>/dev/null || true

echo "Step 8: Deleting devops-pets namespace..."
kubectl delete namespace devops-pets 2>/dev/null || true

echo "Step 9: Deleting Kind cluster..."
kind delete cluster --name devops-pets 2>/dev/null || true

echo "Step 10: Cleaning Jenkins home..."
sudo rm -rf jenkins_home 2>/dev/null || true
mkdir -p jenkins_home
sudo chown -R 1000:1000 jenkins_home
sudo chmod -R 755 jenkins_home

echo "Step 11: Cleaning port forwarding logs..."
sudo rm -f /tmp/*-port-forward*.log 2>/dev/null || true

echo "Step 12: Killing any processes using our ports..."
sudo lsof -ti:8025 | xargs kill -9 2>/dev/null || true
sudo lsof -ti:8080 | xargs kill -9 2>/dev/null || true
sudo lsof -ti:8081 | xargs kill -9 2>/dev/null || true
sudo lsof -ti:8082 | xargs kill -9 2>/dev/null || true

echo "Step 13: Cleaning Docker images..."
docker rmi devops-pets-backend:latest --force 2>/dev/null || true
docker rmi devops-pets-frontend:latest --force 2>/dev/null || true
docker image prune -f 2>/dev/null || true

echo "Step 14: Cleaning Docker containers..."
docker container prune -f 2>/dev/null || true

echo ""
echo "✅ Comprehensive cleanup completed!"
echo ""
echo "System is now completely clean. Ready for fresh deployment."
echo "Run: ansible-playbook ansible/deploy-all.yml --become"
echo ""
echo "=== Cleanup Summary ==="
echo "✓ Port forwarding stopped"
echo "✓ Jenkins containers stopped"
echo "✓ All pods deleted"
echo "✓ All deployments deleted"
echo "✓ All services deleted"
echo "✓ All PVCs deleted"
echo "✓ All secrets deleted"
echo "✓ Namespace deleted"
echo "✓ Kind cluster deleted"
echo "✓ Jenkins home cleaned"
echo "✓ Port forwarding logs cleaned"
echo "✓ Port processes killed"
echo "✓ Docker images cleaned"
echo "✓ Docker containers cleaned" 