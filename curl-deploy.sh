#!/bin/bash

# Auto-deploy script for pets-devops project
# Downloads, extracts, and deploys the project automatically

set -e

# Configuration
REPO_URL="https://github.com/YOUR_USERNAME/pets-devops/archive/refs/heads/main.zip"
PROJECT_DIR="pets-devops-main"
TEMP_DIR="/tmp/pets-devops-deploy"

echo "🚀 Starting automatic deployment of pets-devops project..."

# Check if required tools are installed
check_tools() {
    echo "🔍 Checking required tools..."
    
    if ! command -v curl &> /dev/null; then
        echo "❌ curl is not installed. Please install curl first."
        exit 1
    fi
    
    if ! command -v unzip &> /dev/null; then
        echo "❌ unzip is not installed. Please install unzip first."
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v kind &> /dev/null; then
        echo "❌ kind is not installed. Please install kind first."
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        echo "❌ kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    if ! command -v ansible &> /dev/null; then
        echo "❌ ansible is not installed. Please install ansible first."
        exit 1
    fi
    
    echo "✅ All required tools are installed"
}

# Download and extract project
download_project() {
    echo "📥 Downloading project from GitHub..."
    
    # Create temp directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Download the zip file
    curl -L -o pets-devops.zip "$REPO_URL"
    
    if [ ! -f "pets-devops.zip" ]; then
        echo "❌ Failed to download project"
        exit 1
    fi
    
    echo "📦 Extracting project..."
    unzip -q pets-devops.zip
    
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "❌ Failed to extract project"
        exit 1
    fi
    
    echo "✅ Project downloaded and extracted successfully"
}

# Deploy infrastructure
deploy_infrastructure() {
    echo "🏗️ Deploying infrastructure..."
    
    cd "$TEMP_DIR/$PROJECT_DIR"
    
    # Run the Ansible deployment
    ansible-playbook -i localhost, -c local ansible/deploy-all.yml
    
    echo "✅ Infrastructure deployment completed"
}

# Deploy applications (if present)
deploy_applications() {
    echo "📱 Checking for applications to deploy..."
    
    cd "$TEMP_DIR/$PROJECT_DIR"
    
    # Check if frontend and backend directories exist
    if [ -d "frontend" ] && [ -d "Ask" ]; then
        echo "📱 Deploying applications..."
        
        # Build and deploy applications
        ansible-playbook -i localhost, -c local ansible/deploy-applications.yml
        
        echo "✅ Applications deployment completed"
    else
        echo "ℹ️ No applications found, skipping application deployment"
    fi
}

# Show deployment status
show_status() {
    echo "📊 Deployment Status:"
    echo "====================="
    
    # Wait a moment for pods to be ready
    sleep 5
    
    # Check infrastructure services
    echo "🏗️ Infrastructure Services:"
    kubectl get pods -n pets-devops 2>/dev/null || echo "No pods found in pets-devops namespace"
    
    echo ""
    echo "🌐 Port Forwarding:"
    echo "Jenkins: http://localhost:8080"
    echo "MailHog: http://localhost:8025"
    echo "PostgreSQL: localhost:5432"
    
    # Check if applications are deployed
    if kubectl get pods -n pets-devops | grep -q "frontend\|backend" 2>/dev/null; then
        echo "Frontend: http://localhost:3000"
        echo "Backend: http://localhost:8081"
    fi
    
    echo ""
    echo "📋 Useful Commands:"
    echo "kubectl get pods -n pets-devops"
    echo "kubectl logs -n pets-devops <pod-name>"
    echo "kubectl describe pod -n pets-devops <pod-name>"
}

# Cleanup function
cleanup() {
    echo "🧹 Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

# Main execution
main() {
    # Set up cleanup on exit
    trap cleanup EXIT
    
    # Check tools
    check_tools
    
    # Download and extract
    download_project
    
    # Deploy infrastructure
    deploy_infrastructure
    
    # Deploy applications
    deploy_applications
    
    # Show status
    show_status
    
    echo ""
    echo "🎉 Deployment completed successfully!"
    echo "The project is now running in the pets-devops namespace."
    echo "Access Jenkins at http://localhost:8080"
    echo "Access MailHog at http://localhost:8025"
}

# Run main function
main "$@" 