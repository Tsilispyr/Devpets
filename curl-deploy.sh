#!/bin/bash

# DevOps Pets Infrastructure Deployment via curl
# This script can be run directly from curl and deploys infrastructure only
# Usage: curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/curl-deploy.sh | bash

set -e  # Stop on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CLUSTER_NAME="devops-pets"
NAMESPACE="devops-pets"

# Helper functions
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    print_color $BLUE "=========================================="
    print_color $BLUE "$1"
    print_color $BLUE "=========================================="
}

print_success() {
    print_color $GREEN "✅ $1"
}

print_error() {
    print_color $RED "❌ $1"
}

print_warning() {
    print_color $YELLOW "⚠️  $1"
}

# Check if required tools are available
check_tools() {
    print_header "Checking Required Tools"
    
    local tools=("docker" "kubectl" "kind" "ansible-playbook")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        else
            print_success "$tool is available"
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_warning "Please install the missing tools and try again"
        exit 1
    fi
    
    print_success "All required tools are available"
}

# Setup project directory
setup_project() {
    print_header "Setting up Project Directory"
    
    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    PROJECT_ROOT="$SCRIPT_DIR"
    
    print_success "Project root: $PROJECT_ROOT"
    
    # Check if we're in the right directory
    if [ ! -f "$PROJECT_ROOT/ansible/deploy-all.yml" ]; then
        print_error "deploy-all.yml not found in $PROJECT_ROOT/ansible/"
        print_error "Please run this script from the project root directory"
        exit 1
    fi
    
    print_success "Project structure verified"
}

# Clean up existing deployment
cleanup_existing() {
    print_header "Cleaning up Existing Deployment"
    
    print_color $BLUE "Stopping any existing port forwarding..."
    pkill -f "kubectl port-forward" 2>/dev/null || true
    
    print_color $BLUE "Removing devops-pets images only..."
    docker images | grep devops-pets | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || true
    
    print_color $BLUE "Deleting existing namespace (PVs will be preserved)..."
    kubectl delete namespace "$NAMESPACE" --force --grace-period=0 --timeout=10s 2>/dev/null || true
    
    print_color $BLUE "Deleting existing cluster..."
    kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true
    
    print_success "Cleanup completed (jenkins_home, docker tools, PVs preserved)"
}

# Deploy infrastructure
deploy_infrastructure() {
    print_header "Deploying Infrastructure"
    
    print_color $BLUE "This will deploy:"
    print_color $BLUE "- PostgreSQL database"
    print_color $BLUE "- Jenkins CI/CD server"
    print_color $BLUE "- MailHog email testing"
    print_color $BLUE ""
    print_color $BLUE "Frontend and Backend will be deployed separately later"
    
    # Change to project root
    cd "$PROJECT_ROOT"
    
    # Run Ansible deployment
    print_header "Running Ansible Infrastructure Deployment"
    
    if ansible-playbook -i localhost, --connection=local "ansible/deploy-all.yml"; then
        print_success "Infrastructure deployment completed successfully!"
    else
        print_error "Infrastructure deployment failed!"
        print_warning "Check the logs above for details"
        exit 1
    fi
}

# Display final status
show_status() {
    print_header "Deployment Status"
    
    print_color $BLUE "Checking cluster status..."
    
    if kubectl get namespace "$NAMESPACE" &>/dev/null; then
        print_success "Namespace '$NAMESPACE' exists"
        
        print_color $BLUE "Pods in namespace:"
        kubectl get pods -n "$NAMESPACE" || print_warning "No pods found"
        
        print_color $BLUE "Services in namespace:"
        kubectl get services -n "$NAMESPACE" || print_warning "No services found"
        
        print_color $BLUE "Deployments in namespace:"
        kubectl get deployments -n "$NAMESPACE" || print_warning "No deployments found"
        
    else
        print_error "Namespace '$NAMESPACE' not found"
    fi
    
    print_header "Access URLs"
    print_color $GREEN "Jenkins: http://localhost:8082"
    print_color $GREEN "MailHog: http://localhost:8025"
    print_color $BLUE "PostgreSQL: Running in cluster (no external access)"
    
    print_header "Useful Commands"
    print_color $BLUE "Check all resources: kubectl get all -n $NAMESPACE"
    print_color $BLUE "View logs: kubectl logs -n $NAMESPACE <pod-name>"
    print_color $BLUE "Stop port forwarding: pkill -f 'kubectl port-forward'"
    print_color $BLUE "Delete everything: kubectl delete namespace $NAMESPACE --force"
}

# Main script execution
main() {
    print_header "DevOps Pets Infrastructure Deployment via curl"
    
    # Check tools
    check_tools
    
    # Setup project
    setup_project
    
    # Cleanup existing deployment
    cleanup_existing
    
    # Deploy infrastructure
    deploy_infrastructure
    
    # Show final status
    show_status
    
    print_header "Deployment Complete!"
    print_success "Infrastructure is ready for use"
    print_color $BLUE "Next step: Deploy frontend and backend applications"
}

# Run main function
main "$@" 