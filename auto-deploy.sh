#!/bin/bash

# DevOps Pets - Universal Auto-Deployment Script
# This script can be run directly from curl and handles all deployment scenarios
# Usage: curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check system requirements
check_system_requirements() {
    print_status "Checking system requirements..."
    
    # Check available disk space (need at least 5GB)
    local available_space=$(df . | awk 'NR==2 {print $4}')
    local required_space=5242880  # 5GB in KB
    
    if [ "$available_space" -lt "$required_space" ]; then
        print_error "Insufficient disk space. Need at least 5GB free space."
        print_error "Available: $((available_space / 1024 / 1024))GB"
        exit 1
    fi
    
    # Check available memory (need at least 2GB)
    local available_memory=$(free | awk 'NR==2{printf "%.0f", $7/1024/1024}')
    local required_memory=2
    
    if [ "$available_memory" -lt "$required_memory" ]; then
        print_warning "Low memory detected. Available: ${available_memory}GB, Recommended: ${required_memory}GB"
        print_warning "Deployment may be slow or fail with insufficient memory"
    fi
    
    print_success "System requirements check passed"
}

# Function to check internet connectivity
check_internet() {
    print_status "Checking internet connectivity..."
    
    if ping -c 1 google.com >/dev/null 2>&1; then
        print_success "Internet connectivity confirmed"
    else
        print_error "No internet connectivity detected"
        print_error "Please check your network connection and try again"
        exit 1
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command_exists apt-get; then
            echo "debian"
        elif command_exists yum; then
            echo "rhel"
        elif command_exists dnf; then
            echo "fedora"
        else
            echo "unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Function to install dependencies based on OS
install_dependencies() {
    local os=$(detect_os)
    
    print_status "Detected OS: $os"
    
    case $os in
        "debian")
            print_status "Installing dependencies on Debian/Ubuntu..."
            sudo apt-get update
            sudo apt-get install -y git curl wget unzip
            if ! command_exists ansible; then
                print_status "Installing Ansible..."
                sudo apt-get install -y software-properties-common
                sudo apt-add-repository --yes --update ppa:ansible/ansible
                sudo apt-get install -y ansible
            fi
            ;;
        "rhel"|"fedora")
            print_status "Installing dependencies on RHEL/Fedora..."
            if command_exists dnf; then
                sudo dnf update -y
                sudo dnf install -y git curl wget unzip
                if ! command_exists ansible; then
                    print_status "Installing Ansible..."
                    sudo dnf install -y ansible
                fi
            else
                sudo yum update -y
                sudo yum install -y git curl wget unzip
                if ! command_exists ansible; then
                    print_status "Installing Ansible..."
                    sudo yum install -y ansible
                fi
            fi
            ;;
        "macos")
            print_status "Installing dependencies on macOS..."
            if ! command_exists brew; then
                print_error "Homebrew is required on macOS. Please install it first:"
                print_error "https://brew.sh/"
                exit 1
            fi
            brew update
            brew install git curl wget
            # unzip comes pre-installed on macOS
            if ! command_exists ansible; then
                print_status "Installing Ansible..."
                brew install ansible
            fi
            ;;
        *)
            print_error "Unsupported operating system: $os"
            print_error "Please install git, curl, wget, unzip, and ansible manually"
            exit 1
            ;;
    esac
}

# Function to setup/update repository
setup_repository() {
    local repo_url="https://github.com/Tsilispyr/Devpets.git"
    local project_name="Devpets"
    
    # Check if directory already exists
    if [ -d "$project_name" ]; then
        print_warning "Directory $project_name already exists"
        
        # Check if the existing directory is a git repository
        if [ -d "$project_name/.git" ]; then
            print_status "Existing directory is a git repository. Updating with latest changes..."
            cd "$project_name"
            
            # Check if remote is correct
            local current_remote=$(git remote get-url origin 2>/dev/null || echo "")
            if [ "$current_remote" != "$repo_url" ]; then
                print_status "Updating remote URL to correct repository..."
                git remote set-url origin "$repo_url"
            fi
            
            # Fetch latest changes
            print_status "Fetching latest changes from remote repository..."
            git fetch origin
            
            # Check if we're on the main branch
            local current_branch=$(git branch --show-current)
            if [ "$current_branch" != "main" ]; then
                print_status "Switching to main branch..."
                git checkout main
            fi
            
            # Pull latest changes
            print_status "Pulling latest changes..."
            if git pull origin main; then
                print_success "Repository updated successfully"
            else
                print_warning "Git pull failed, but continuing with existing files..."
            fi
            
            return
        else
            # Not a git repository, check if it has required files
            if [ -f "$project_name/ansible/deploy-all.yml" ] && [ -f "$project_name/Ask/Dockerfile" ]; then
                print_status "Existing directory appears valid but not a git repository. Converting to git repository..."
                cd "$project_name"
                
                # Initialize git repository
                git init
                git remote add origin "$repo_url"
                git fetch origin
                git checkout -b main origin/main
                
                print_success "Converted to git repository and updated"
                return
            else
                print_status "Existing directory appears corrupted. Removing and cloning fresh..."
                rm -rf "$project_name"
            fi
        fi
    fi
    
    # Check if zip file exists (from GitHub download) - optional fallback
    if [ -f "Devpets-main.zip" ]; then
        print_status "Found Devpets-main.zip from GitHub download..."
        print_status "Extracting zip file..."
        unzip -q "Devpets-main.zip"
        if [ -d "Devpets-main" ]; then
            mv "Devpets-main" "$project_name"
            print_success "Extracted and renamed to $project_name"
        else
            print_error "Failed to extract zip file, falling back to git clone"
            print_status "Cloning repository from $repo_url..."
            git clone "$repo_url" "$project_name"
        fi
    else
        print_status "Cloning repository from $repo_url..."
        
        # Try git clone with retry
        local max_retries=3
        local retry_count=0
        
        while [ $retry_count -lt $max_retries ]; do
            if git clone "$repo_url" "$project_name"; then
                print_success "Repository cloned successfully"
                break
            else
                retry_count=$((retry_count + 1))
                if [ $retry_count -lt $max_retries ]; then
                    print_warning "Git clone failed, retrying... (attempt $retry_count/$max_retries)"
                    sleep 2
                else
                    print_error "Failed to clone repository after $max_retries attempts"
                    exit 1
                fi
            fi
        done
    fi
    
    cd "$project_name"
}

# Function to verify project structure
verify_project() {
    print_status "Verifying project structure..."
    
    local required_files=(
        "ansible/deploy-all.yml"
        "ansible/inventory.ini"
        "k8s/jenkins/Dockerfile"
        "k8s/jenkins/jenkins-deployment.yaml"
        "k8s/postgres/postgres-deployment.yaml"
        "k8s/mailhog/mailhog-deployment.yaml"
        "kind-config.yaml"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Required file missing: $file"
            exit 1
        fi
    done
    
    print_success "Project structure verified"
}

# Function to deploy application
deploy_application() {
    print_status "Starting infrastructure deployment with Ansible..."
    
    # Check if we're in the right directory
    if [ ! -f "ansible/deploy-all.yml" ]; then
        print_error "deploy-all.yml not found. Please run this script from the project root."
        exit 1
    fi
    
    # Run Ansible infrastructure deployment
    ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
    
    if [ $? -eq 0 ]; then
        print_success "Infrastructure deployment completed successfully!"
    else
        print_error "Infrastructure deployment failed!"
        exit 1
    fi
    
    # Deploy applications if deploy-applications.yml exists
    if [ -f "ansible/deploy-applications.yml" ]; then
        print_status "Starting applications deployment with Ansible..."
        ansible-playbook -i ansible/inventory.ini ansible/deploy-applications.yml
        
        if [ $? -eq 0 ]; then
            print_success "Applications deployment completed successfully!"
        else
            print_error "Applications deployment failed!"
            exit 1
        fi
    else
        print_warning "Applications deployment skipped (deploy-applications.yml not found)"
    fi
}

# Function to display access information
display_access_info() {
    print_success "DevOps Pets is now running!"
    echo
    echo "Access URLs:"
    echo "   Jenkins:     http://localhost:8082"
    echo "   Mailhog:     http://localhost:8025"
    echo "   PostgreSQL:  Running in cluster"
    
    # Check if applications were deployed
    if [ -f "ansible/deploy-applications.yml" ]; then
        echo "   Frontend:    http://localhost:8081"
        echo "   Backend API: http://localhost:8080"
    fi
    
    echo
    echo "Useful commands:"
    echo "   Check pods:     kubectl get pods -n devops-pets"
    echo "   Check services: kubectl get services -n devops-pets"
    echo "   View logs:      kubectl logs <pod-name> -n devops-pets"
    echo
    echo "To stop the application:"
    echo "   kubectl delete namespace devops-pets"
    echo
    echo "To update the application:"
    echo "   curl -sSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/auto-deploy.sh | bash"
    echo
}

# Main execution
main() {
    echo "DevOps Pets - Universal Auto-Deployment"
    echo "======================================"
    echo
    
    # Check system requirements
    check_system_requirements
    
    # Check internet connectivity
    check_internet
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root is not recommended"
        print_status "Continuing with root privileges..."
    fi
    
    # Install dependencies
    install_dependencies
    
    # Setup repository
    setup_repository
    
    # Verify project structure
    verify_project
    
    # Deploy application
    deploy_application
    
    # Display access information
    display_access_info
}

# Handle script interruption
trap 'print_error "Script interrupted by user"; exit 1' INT TERM

# Run main function
main "$@" 