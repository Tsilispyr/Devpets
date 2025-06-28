#!/bin/bash

# One-liner auto-deploy script for pets-devops
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/pets-devops/main/auto-deploy-remote.sh | bash

set -e

echo "🚀 Auto-deploying pets-devops project..."

# Configuration - UPDATE THESE WITH YOUR ACTUAL GITHUB USERNAME
GITHUB_USER="YOUR_USERNAME"
REPO_NAME="pets-devops"
BRANCH="main"

# Create temporary directory
TEMP_DIR="/tmp/pets-devops-auto-deploy"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download and extract
echo "📥 Downloading project..."
curl -L -o project.zip "https://github.com/$GITHUB_USER/$REPO_NAME/archive/refs/heads/$BRANCH.zip"
unzip -q project.zip
cd "$REPO_NAME-$BRANCH"

# Check tools
echo "🔍 Checking required tools..."
for tool in docker kind kubectl ansible; do
    if ! command -v "$tool" &> /dev/null; then
        echo "❌ $tool is not installed. Please install it first."
        exit 1
    fi
done

# Deploy infrastructure
echo "🏗️ Deploying infrastructure..."
ansible-playbook -i localhost, -c local ansible/deploy-all.yml

# Deploy applications if they exist
if [ -d "frontend" ] && [ -d "Ask" ]; then
    echo "📱 Deploying applications..."
    ansible-playbook -i localhost, -c local ansible/deploy-applications.yml
fi

# Show status
echo "📊 Deployment Status:"
echo "====================="
sleep 5
kubectl get pods -n pets-devops 2>/dev/null || echo "No pods found in pets-devops namespace"

echo ""
echo "🌐 Access URLs:"
echo "Jenkins: http://localhost:8080"
echo "MailHog: http://localhost:8025"
echo "PostgreSQL: localhost:5432"

if kubectl get pods -n pets-devops | grep -q "frontend\|backend" 2>/dev/null; then
    echo "Frontend: http://localhost:3000"
    echo "Backend: http://localhost:8081"
fi

echo ""
echo "🎉 Deployment completed successfully!"
echo "Cleanup: rm -rf $TEMP_DIR" 