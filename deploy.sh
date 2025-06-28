#!/bin/bash

# DevOps Pets - Simple One-Line Deployment
# Run with: curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash

set -e

echo "🚀 DevOps Pets - Simple Deployment"
echo "=================================="
    
    # Check if we're in the right directory
    if [ ! -f "ansible/deploy-all.yml" ]; then
    echo "❌ Error: ansible/deploy-all.yml not found"
    echo "Please run this script from the project root directory"
        exit 1
    fi
    
# Run the Ansible deployment
echo "📦 Running Ansible deployment..."
ansible-playbook ansible/deploy-all.yml
    
echo ""
echo "🎉 Deployment completed!"
echo "📧 MailHog: http://localhost:8025"
echo "🔧 Jenkins: http://localhost:8082"
echo ""
echo "📋 To get Jenkins admin password:"
echo "kubectl exec -n devops-pets deployment/jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "🛑 To stop port forwarding:"
echo "pkill -f 'kubectl port-forward'" 