#!/bin/bash

# Auto-deploy script for Devpets project
# Downloads, extracts, and deploys the project automatically

set -e

# Configuration
REPO_URL="https://github.com/Tsilispyr/Devpets/archive/refs/heads/main.zip"
PROJECT_DIR="Devpets-main"
TEMP_DIR="/tmp/devpets-deploy"

echo "Starting automatic deployment of Devpets project..."

# Check if required tools are installed
check_tools() {
    echo "Checking required tools..."
    
    if ! command -v curl &> /dev/null; then
        echo "ERROR: curl is not installed. Please install curl first."
        exit 1
    fi
    
    if ! command -v unzip &> /dev/null; then
        echo "ERROR: unzip is not installed. Please install unzip first."
        exit 1
    fi
    
    if ! command -v docker &> /dev/null; then
        echo "ERROR: Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v kind &> /dev/null; then
        echo "ERROR: kind is not installed. Please install kind first."
        exit 1
    fi
    
    if ! command -v kubectl &> /dev/null; then
        echo "ERROR: kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    # Check for Ansible and install if missing
    if ! command -v ansible &> /dev/null; then
        echo "Ansible not found. Installing Ansible..."
        install_ansible
    fi
    
    echo "SUCCESS: All required tools are installed"
}

# Install Ansible
install_ansible() {
    echo "Installing Ansible..."
    
    # Detect OS and install Ansible
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt-get &> /dev/null; then
            # Ubuntu/Debian
            sudo apt-get update
            sudo apt-get install -y software-properties-common
            sudo apt-add-repository --yes --update ppa:ansible/ansible
            sudo apt-get install -y ansible
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y epel-release
            sudo yum install -y ansible
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y ansible
        else
            echo "ERROR: Unsupported Linux distribution. Please install Ansible manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install ansible
        else
            echo "ERROR: Homebrew not found. Please install Homebrew first or install Ansible manually."
            exit 1
        fi
    else
        echo "ERROR: Unsupported operating system. Please install Ansible manually."
        exit 1
    fi
    
    # Verify installation
    if command -v ansible &> /dev/null; then
        echo "SUCCESS: Ansible installed successfully"
        echo "Ansible version: $(ansible --version | head -1)"
    else
        echo "ERROR: Failed to install Ansible"
        exit 1
    fi
}

# Download and extract project
download_project() {
    echo "Downloading project from GitHub..."
    
    # Create temp directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Download the zip file
    curl -L -o devpets.zip "$REPO_URL"
    
    if [ ! -f "devpets.zip" ]; then
        echo "ERROR: Failed to download project"
        exit 1
    fi
    
    echo "Extracting project..."
    unzip -q devpets.zip
    
    if [ ! -d "$PROJECT_DIR" ]; then
        echo "ERROR: Failed to extract project"
        exit 1
    fi
    
    echo "SUCCESS: Project downloaded and extracted successfully"
}

# Deploy infrastructure
deploy_infrastructure() {
    echo "Deploying infrastructure..."
    
    cd "$TEMP_DIR/$PROJECT_DIR"
    
    # Run the Ansible deployment
    ansible-playbook -i localhost, -c local ansible/deploy-all.yml
    
    echo "SUCCESS: Infrastructure deployment completed"
}

# Deploy applications (if present)
deploy_applications() {
    echo "INFO: Skipping applications deployment - infrastructure only mode"
    echo "INFO: Only PostgreSQL, MailHog, and Jenkins are deployed"
}

# Show deployment status
show_status() {
    echo "Deployment Status:"
    echo "=================="
    
    # Wait a moment for pods to be ready
    sleep 5
    
    # Check infrastructure services
    echo "Infrastructure Services:"
    kubectl get pods -n devops-pets 2>/dev/null || echo "No pods found in devops-pets namespace"
    
    echo ""
    echo "Port Forwarding:"
    echo "Jenkins: http://localhost:8082"
    echo "MailHog: http://localhost:8025"
    echo "PostgreSQL: localhost:5432"
    
    echo ""
    echo "Useful Commands:"
    echo "kubectl get pods -n devops-pets"
    echo "kubectl logs -n devops-pets <pod-name>"
    echo "kubectl describe pod -n devops-pets <pod-name>"
    echo "pkill -f 'kubectl port-forward'  # Stop port forwarding"
}

# Cleanup function
cleanup() {
    echo "Cleaning up temporary files..."
    echo "PRESERVING:"
    echo "- Jenkins home: ./jenkins_home/"
    echo "- Docker images: devops-pets-*"
    echo "- Kubernetes cluster: devops-pets"
    echo "- Port forwarding processes"
    echo ""
    echo "REMOVING:"
    echo "- Temporary download directory: $TEMP_DIR"
    
    # Keep a backup of important files if needed
    if [ -d "$TEMP_DIR/$PROJECT_DIR" ]; then
        echo "Creating backup of important files..."
        mkdir -p ./deployment-backup
        cp -r "$TEMP_DIR/$PROJECT_DIR/ansible" ./deployment-backup/ 2>/dev/null || true
        cp -r "$TEMP_DIR/$PROJECT_DIR/k8s" ./deployment-backup/ 2>/dev/null || true
        echo "Backup created at: ./deployment-backup/"
    fi
    
    rm -rf "$TEMP_DIR"
    echo "Cleanup completed!"
}

# Wait for port forwarding to be ready
wait_for_port_forwarding() {
    echo "Waiting for port forwarding to be ready..."
    
    # Wait for Jenkins port
    local jenkins_ready=false
    local mailhog_ready=false
    local attempts=0
    local max_attempts=30
    
    while [ $attempts -lt $max_attempts ]; do
        if curl -s http://localhost:8082 > /dev/null 2>&1; then
            jenkins_ready=true
            echo "SUCCESS: Jenkins port forwarding is ready"
        fi
        
        if curl -s http://localhost:8025 > /dev/null 2>&1; then
            mailhog_ready=true
            echo "SUCCESS: MailHog port forwarding is ready"
        fi
        
        if [ "$jenkins_ready" = true ] && [ "$mailhog_ready" = true ]; then
            echo "SUCCESS: All port forwarding is ready!"
            break
        fi
        
        echo "Waiting for port forwarding... (attempt $((attempts + 1))/$max_attempts)"
        sleep 2
        attempts=$((attempts + 1))
    done
    
    if [ $attempts -eq $max_attempts ]; then
        echo "WARNING: Port forwarding may not be fully ready, but deployment completed"
    fi
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
    
    # Wait for port forwarding to be ready
    wait_for_port_forwarding
    
    # Show status
    show_status
    
    echo ""
    echo "SUCCESS: Deployment completed successfully!"
    echo "The project is now running in the devops-pets namespace."
    echo "Infrastructure services deployed:"
    echo "- Jenkins: http://localhost:8082"
    echo "- MailHog: http://localhost:8025"
    echo "- PostgreSQL: localhost:5432"
    echo ""
    echo "To stop port forwarding: pkill -f 'kubectl port-forward'"
    echo ""
    echo "Press Ctrl+C to exit (port forwarding will continue running)"
    
    # Keep the script running to maintain port forwarding
    while true; do
        sleep 10
        # Check if port forwarding is still running
        if ! pgrep -f "kubectl port-forward" > /dev/null; then
            echo "WARNING: Port forwarding has stopped"
            break
        fi
    done
}

# Run main function
main "$@" 