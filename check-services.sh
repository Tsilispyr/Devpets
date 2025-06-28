#!/bin/bash

# DevOps Pets Infrastructure Status Checker
# This script checks the status of infrastructure services only

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
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

# Check if namespace exists
check_namespace() {
    print_header "Checking Namespace"
    
    if kubectl get namespace "$NAMESPACE" &>/dev/null; then
        print_success "Namespace '$NAMESPACE' exists"
        return 0
    else
        print_error "Namespace '$NAMESPACE' not found"
        return 1
    fi
}

# Check pods status
check_pods() {
    print_header "Checking Pods"
    
    if ! check_namespace; then
        return 1
    fi
    
    local pods=$(kubectl get pods -n "$NAMESPACE" --no-headers 2>/dev/null || echo "")
    
    if [ -z "$pods" ]; then
        print_warning "No pods found in namespace '$NAMESPACE'"
        return 1
    fi
    
    echo "$pods" | while IFS= read -r pod_line; do
        if [ -n "$pod_line" ]; then
            local pod_name=$(echo "$pod_line" | awk '{print $1}')
            local ready=$(echo "$pod_line" | awk '{print $2}')
            local status=$(echo "$pod_line" | awk '{print $3}')
            local age=$(echo "$pod_line" | awk '{print $5}')
            
            if [ "$ready" = "1/1" ] && [ "$status" = "Running" ]; then
                print_success "$pod_name: Ready ($status, $age)"
            else
                print_error "$pod_name: Not ready ($ready, $status, $age)"
fi
        fi
    done
}

# Check services status
check_services() {
    print_header "Checking Services"
    
    if ! check_namespace; then
        return 1
    fi
    
    local services=$(kubectl get services -n "$NAMESPACE" --no-headers 2>/dev/null || echo "")
    
    if [ -z "$services" ]; then
        print_warning "No services found in namespace '$NAMESPACE'"
        return 1
    fi
    
    echo "$services" | while IFS= read -r service_line; do
        if [ -n "$service_line" ]; then
            local service_name=$(echo "$service_line" | awk '{print $1}')
            local service_type=$(echo "$service_line" | awk '{print $2}')
            local cluster_ip=$(echo "$service_line" | awk '{print $3}')
            local external_ip=$(echo "$service_line" | awk '{print $4}')
            local ports=$(echo "$service_line" | awk '{print $5}')
            local age=$(echo "$service_line" | awk '{print $6}')
            
            print_success "$service_name: $service_type ($cluster_ip, $ports, $age)"
fi
    done
}

# Check deployments status
check_deployments() {
    print_header "Checking Deployments"
    
    if ! check_namespace; then
        return 1
    fi
    
    local deployments=$(kubectl get deployments -n "$NAMESPACE" --no-headers 2>/dev/null || echo "")
    
    if [ -z "$deployments" ]; then
        print_warning "No deployments found in namespace '$NAMESPACE'"
        return 1
    fi
    
    echo "$deployments" | while IFS= read -r deployment_line; do
        if [ -n "$deployment_line" ]; then
            local deployment_name=$(echo "$deployment_line" | awk '{print $1}')
            local ready=$(echo "$deployment_line" | awk '{print $2}')
            local up_to_date=$(echo "$deployment_line" | awk '{print $3}')
            local available=$(echo "$deployment_line" | awk '{print $4}')
            local age=$(echo "$deployment_line" | awk '{print $5}')
            
            if [ "$ready" = "1/1" ] && [ "$available" = "1" ]; then
                print_success "$deployment_name: Ready ($ready, $up_to_date, $available, $age)"
            else
                print_error "$deployment_name: Not ready ($ready, $up_to_date, $available, $age)"
fi
        fi
    done
}

# Check port forwarding
check_port_forwarding() {
    print_header "Checking Port Forwarding"
    
    local jenkins_pf=$(pgrep -f "kubectl port-forward.*jenkins.*8082" || echo "")
    local mailhog_pf=$(pgrep -f "kubectl port-forward.*mailhog.*8025" || echo "")
    
    if [ -n "$jenkins_pf" ]; then
        print_success "Jenkins port forwarding is active (PID: $jenkins_pf)"
    else
        print_error "Jenkins port forwarding is not active"
    fi
    
    if [ -n "$mailhog_pf" ]; then
        print_success "MailHog port forwarding is active (PID: $mailhog_pf)"
else
        print_error "MailHog port forwarding is not active"
fi
}

# Check service accessibility
check_accessibility() {
    print_header "Checking Service Accessibility"
    
    # Check Jenkins
    if curl -s http://localhost:8082 >/dev/null 2>&1; then
        print_success "Jenkins is accessible at http://localhost:8082"
else
        print_error "Jenkins is not accessible at http://localhost:8082"
fi

    # Check MailHog
    if curl -s http://localhost:8025 >/dev/null 2>&1; then
        print_success "MailHog is accessible at http://localhost:8025"
    else
        print_error "MailHog is not accessible at http://localhost:8025"
    fi
}

# Display summary
display_summary() {
    print_header "Summary"
    
    print_color $BLUE "Infrastructure Services:"
    print_color $GREEN "- Jenkins: http://localhost:8082"
    print_color $GREEN "- MailHog: http://localhost:8025"
    print_color $BLUE "- PostgreSQL: Running in cluster (no external access)"
    
    print_color $BLUE ""
    print_color $BLUE "Useful Commands:"
    print_color $BLUE "- View all resources: kubectl get all -n $NAMESPACE"
    print_color $BLUE "- View logs: kubectl logs -n $NAMESPACE <pod-name>"
    print_color $BLUE "- Stop port forwarding: pkill -f 'kubectl port-forward'"
    print_color $BLUE "- Delete everything: kubectl delete namespace $NAMESPACE --force"
}

# Main function
main() {
    print_header "DevOps Pets Infrastructure Status Check"
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not available"
        exit 1
    fi
    
    # Run all checks
    check_pods
    check_services
    check_deployments
    check_port_forwarding
    check_accessibility
    
    # Display summary
    display_summary
}

# Run main function
main "$@" 