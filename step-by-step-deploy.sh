#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}OK! $1${NC}"
}

print_error() {
    echo -e "${RED}ERR! $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}WARN: $1${NC}"
}

# Function to wait for Kubernetes resources to be ready
wait_for_ready() {
    local resource_type=$1
    local resource_name=$2
    local namespace=$3
    local max_attempts=30
    local attempt=1
    
    echo "Waiting for $resource_type/$resource_name to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        if kubectl get $resource_type $resource_name -n $namespace --no-headers 2>/dev/null | grep -q "Running\|Ready"; then
            print_success "$resource_type/$resource_name is ready!"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts - waiting 10 seconds..."
        sleep 10
        attempt=$((attempt + 1))
    done
    
    print_error "$resource_type/$resource_name failed to become ready after $max_attempts attempts"
    return 1
}

# Function to wait for Docker image to be built
wait_for_image_build() {
    local image_name=$1
    local max_attempts=60
    local attempt=1
    
    echo "Waiting for Docker image $image_name to be built..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker images | grep -q "$image_name"; then
            print_success "Docker image $image_name built successfully!"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts - waiting 5 seconds..."
        sleep 5
        attempt=$((attempt + 1))
    done
    
    print_error "Docker image $image_name failed to build after $max_attempts attempts"
    return 1
}

# Function to wait for image to be loaded in Kind cluster
wait_for_image_loaded() {
    local image_name=$1
    local cluster_name=$2
    local max_attempts=30
    local attempt=1
    
    echo "Waiting for image $image_name to be loaded in Kind cluster..."
    
    while [ $attempt -le $max_attempts ]; do
        if docker exec ${cluster_name}-control-plane crictl images | grep -q "$image_name"; then
            print_success "Image $image_name loaded in Kind cluster successfully!"
            return 0
        fi
        
        echo "Attempt $attempt/$max_attempts - waiting 5 seconds..."
        sleep 5
        attempt=$((attempt + 1))
    done
    
    print_error "Image $image_name failed to load in Kind cluster after $max_attempts attempts"
    return 1
}

# Main deployment function
main() {
    print_status "STARTING STEP-BY-STEP DEPLOYMENT"
    
    # Step 1: Harsh cleanup
    print_status "STEP 1: HARSH CLEANUP"
    echo "Stopping and removing all devops-pets containers..."
    docker ps -a | grep devops-pets | awk '{print $1}' | xargs -r docker stop 2>/dev/null || true
    docker ps -a | grep devops-pets | awk '{print $1}' | xargs -r docker rm 2>/dev/null || true
    
    echo "Removing all devops-pets images..."
    docker images | grep devops-pets | awk '{print $3}' | xargs -r docker rmi -f 2>/dev/null || true
    
    echo "Deleting kind cluster..."
    kind delete cluster --name devops-pets 2>/dev/null || echo "Cluster already deleted"
    
    echo "Cleaning up any remaining containers..."
    docker ps -a | grep -E "(jenkins|postgres|mailhog)" | awk '{print $1}' | xargs -r docker stop 2>/dev/null || true
    docker ps -a | grep -E "(jenkins|postgres|mailhog)" | awk '{print $1}' | xargs -r docker rm 2>/dev/null || true
    
    print_success "Cleanup completed"
    
    # Step 2: Create Kind cluster
    print_status "STEP 2: CREATING KIND CLUSTER"
    kind create cluster --name devops-pets --config kind-config.yaml
    print_success "Kind cluster created"
    
    echo "Verifying cluster..."
    kind get clusters
    kubectl cluster-info
    
    # Step 3: Create namespace
    print_status "STEP 3: CREATING NAMESPACE"
    kubectl create namespace devops-pets
    print_success "Namespace created"
    
    echo "Verifying namespace..."
    kubectl get namespaces | grep devops-pets
    
    # Step 4: Build Jenkins image
    print_status "STEP 4: BUILDING JENKINS IMAGE"
    docker build -t devops-pets-jenkins:latest k8s/jenkins/ &
    JENKINS_BUILD_PID=$!
    
    # Wait for Jenkins image to be built
    wait_for_image_build "devops-pets-jenkins"
    wait $JENKINS_BUILD_PID
    
    echo "Verifying Jenkins image..."
    docker images | grep devops-pets-jenkins
    
    # Step 5: Load Jenkins image to Kind cluster
    print_status "STEP 5: LOADING JENKINS IMAGE TO KIND CLUSTER"
    kind load docker-image devops-pets-jenkins:latest --name devops-pets
    
    # Wait for image to be loaded
    wait_for_image_loaded "devops-pets-jenkins" "devops-pets"
    
    # Step 6: Apply Jenkins manifests
    print_status "STEP 6: APPLYING JENKINS MANIFESTS"
    kubectl apply -f k8s/jenkins/ -n devops-pets
    print_success "Jenkins manifests applied"
    
    echo "Verifying Jenkins resources..."
    kubectl get all -n devops-pets
    
    # Step 7: Wait for Jenkins to be ready
    print_status "STEP 7: WAITING FOR JENKINS TO BE READY"
    wait_for_ready "deployment" "jenkins" "devops-pets"
    
    # Step 8: Build and deploy PostgreSQL
    print_status "STEP 8: BUILDING POSTGRESQL IMAGE"
    docker build -t devops-pets-postgres:latest k8s/postgres/ &
    POSTGRES_BUILD_PID=$!
    
    wait_for_image_build "devops-pets-postgres"
    wait $POSTGRES_BUILD_PID
    
    print_status "STEP 8.1: LOADING POSTGRESQL IMAGE TO KIND CLUSTER"
    kind load docker-image devops-pets-postgres:latest --name devops-pets
    wait_for_image_loaded "devops-pets-postgres" "devops-pets"
    
    print_status "STEP 8.2: APPLYING POSTGRESQL MANIFESTS"
    kubectl apply -f k8s/postgres/ -n devops-pets
    print_success "PostgreSQL manifests applied"
    
    print_status "STEP 8.3: WAITING FOR POSTGRESQL TO BE READY"
    wait_for_ready "deployment" "postgres" "devops-pets"
    
    # Step 9: Build and deploy MailHog
    print_status "STEP 9: BUILDING MAILHOG IMAGE"
    docker build -t devops-pets-mailhog:latest k8s/mailhog/ &
    MAILHOG_BUILD_PID=$!
    
    wait_for_image_build "devops-pets-mailhog"
    wait $MAILHOG_BUILD_PID
    
    print_status "STEP 9.1: LOADING MAILHOG IMAGE TO KIND CLUSTER"
    kind load docker-image devops-pets-mailhog:latest --name devops-pets
    wait_for_image_loaded "devops-pets-mailhog" "devops-pets"
    
    print_status "STEP 9.2: APPLYING MAILHOG MANIFESTS"
    kubectl apply -f k8s/mailhog/ -n devops-pets
    print_success "MailHog manifests applied"
    
    print_status "STEP 9.3: WAITING FOR MAILHOG TO BE READY"
    wait_for_ready "deployment" "mailhog" "devops-pets"
    
    # Step 10: Build and deploy Backend
    print_status "STEP 10: BUILDING BACKEND IMAGE"
    docker build -t devops-pets-backend:latest Ask/ &
    BACKEND_BUILD_PID=$!
    
    wait_for_image_build "devops-pets-backend"
    wait $BACKEND_BUILD_PID
    
    print_status "STEP 10.1: LOADING BACKEND IMAGE TO KIND CLUSTER"
    kind load docker-image devops-pets-backend:latest --name devops-pets
    wait_for_image_loaded "devops-pets-backend" "devops-pets"
    
    print_status "STEP 10.2: APPLYING BACKEND MANIFESTS"
    kubectl apply -f k8s/backend/ -n devops-pets
    print_success "Backend manifests applied"
    
    print_status "STEP 10.3: WAITING FOR BACKEND TO BE READY"
    wait_for_ready "deployment" "backend" "devops-pets"
    
    # Step 11: Build and deploy Frontend
    print_status "STEP 11: BUILDING FRONTEND IMAGE"
    docker build -t devops-pets-frontend:latest frontend/ &
    FRONTEND_BUILD_PID=$!
    
    wait_for_image_build "devops-pets-frontend"
    wait $FRONTEND_BUILD_PID
    
    print_status "STEP 11.1: LOADING FRONTEND IMAGE TO KIND CLUSTER"
    kind load docker-image devops-pets-frontend:latest --name devops-pets
    wait_for_image_loaded "devops-pets-frontend" "devops-pets"
    
    print_status "STEP 11.2: APPLYING FRONTEND MANIFESTS"
    kubectl apply -f k8s/frontend/ -n devops-pets
    print_success "Frontend manifests applied"
    
    print_status "STEP 11.3: WAITING FOR FRONTEND TO BE READY"
    wait_for_ready "deployment" "frontend" "devops-pets"
    
    # Step 12: Final verification
    print_status "STEP 12: FINAL VERIFICATION"
    echo "All pods in devops-pets namespace:"
    kubectl get pods -n devops-pets
    
    echo "All services in devops-pets namespace:"
    kubectl get services -n devops-pets
    
    # Step 13: Port forwarding (only at the end)
    print_status "STEP 13: SETTING UP PORT FORWARDING"
    echo "Setting up port forwarding for Jenkins (8082) and MailHog (8025)..."
    
    # Start port forwarding in background
    kubectl port-forward -n devops-pets service/jenkins 8082:8080 &
    JENKINS_PF_PID=$!
    
    kubectl port-forward -n devops-pets service/mailhog 8025:1025 &
    MAILHOG_PF_PID=$!
    
    # Wait a moment for port forwarding to establish
    sleep 5
    
    print_success "Port forwarding started!"
    echo "Jenkins: http://localhost:8082"
    echo "MailHog: http://localhost:8025"
    echo ""
    print_success "DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo ""
    echo "To stop port forwarding, run:"
    echo "kill $JENKINS_PF_PID $MAILHOG_PF_PID"
}

# Run main function
main "$@" 