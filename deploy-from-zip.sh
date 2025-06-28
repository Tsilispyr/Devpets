#!/bin/bash

# DevOps Pets - Automated Deployment from ZIP
# This script handles ZIP downloads and updates existing projects

set -e  # Exit on any error

# Check if running in non-interactive mode (piped from curl)
NON_INTERACTIVE=false
if [ ! -t 0 ]; then
    NON_INTERACTIVE=true
fi

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

# Function to handle repository setup/update
setup_repository() {
    local repo_url="https://github.com/Tsilispyr/Devpets.git"
    local project_name="Devpets"
    
    # Check if directory already exists
    if [ -d "$project_name" ]; then
        print_warning "Directory $project_name already exists"
        
        # Check if running in non-interactive mode
        if [ "$NON_INTERACTIVE" = true ]; then
            print_status "Non-interactive mode detected. Checking existing directory..."
            
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
                    print_status "Existing directory appears corrupted. Removing and setting up fresh..."
                    rm -rf "$project_name"
                fi
            fi
        else
            # Interactive mode - ask user
            echo "Options:"
            echo "1. Update existing directory with latest changes (git pull)"
            echo "2. Remove existing directory and setup fresh"
            echo "3. Use existing directory as-is"
            read -p "Choose option (1/2/3): " -n 1 -r
            echo
            
            case $REPLY in
                1)
                    print_status "Updating existing directory..."
                    cd "$project_name"
                    
                    # Check if it's a git repository
                    if [ -d ".git" ]; then
                        # Update remote if needed
                        local current_remote=$(git remote get-url origin 2>/dev/null || echo "")
                        if [ "$current_remote" != "$repo_url" ]; then
                            print_status "Updating remote URL..."
                            git remote set-url origin "$repo_url"
                        fi
                        
                        # Pull latest changes
                        print_status "Pulling latest changes..."
                        git fetch origin
                        git checkout main
                        if git pull origin main; then
                            print_success "Repository updated successfully"
                        else
                            print_warning "Git pull failed, but continuing with existing files..."
                        fi
                    else
                        print_error "Directory is not a git repository. Please choose option 2 to setup fresh."
                        exit 1
                    fi
                    return
                    ;;
                2)
                    print_status "Removing existing directory..."
                    rm -rf "$project_name"
                    ;;
                3)
                    print_status "Using existing directory as-is..."
                    cd "$project_name"
                    return
                    ;;
                *)
                    print_error "Invalid option. Exiting."
                    exit 1
                    ;;
            esac
        fi
    fi
    
    # Check if zip file exists (from GitHub download)
    if [ -f "Devpets-main.zip" ]; then
        print_status "Found Devpets-main.zip from GitHub download..."
        print_status "Extracting zip file..."
        unzip -q "Devpets-main.zip"
        if [ -d "Devpets-main" ]; then
            mv "Devpets-main" "$project_name"
            print_success "Extracted and renamed to $project_name"
        else
            print_error "Failed to extract zip file"
            exit 1
        fi
    else
        print_error "Devpets-main.zip not found in current directory"
        print_error "Please download the ZIP file from GitHub first"
        exit 1
    fi
    
    cd "$project_name"
}

# Function to verify project structure
verify_project() {
    print_status "Verifying project structure..."
    
    local required_files=(
        "ansible/deploy-all.yml"
        "ansible/inventory.ini"
        "Ask/Dockerfile"
        "frontend/Dockerfile"
        "jenkins-dockerfile"
        "kind-config.yaml"
        "Jenkinsfile"
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
    print_status "Starting deployment with Ansible..."
    
    # Check if we're in the right directory
    if [ ! -f "ansible/deploy-all.yml" ]; then
        print_error "deploy-all.yml not found. Please run this script from the project root."
        exit 1
    fi
    
    # Run Ansible deployment
    ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
    
    if [ $? -eq 0 ]; then
        print_success "Deployment completed successfully!"
    else
        print_error "Deployment failed!"
        exit 1
    fi
}

# Function to display access information
display_access_info() {
    print_success "🎉 DevOps Pets is now running!"
    echo
    echo "🌐 Access URLs:"
    echo "   Frontend:    http://localhost:8081"
    echo "   Backend API: http://localhost:8080"
    echo "   Jenkins:     http://localhost:8082"
    echo "   Mailhog:     http://localhost:8025"
    echo
    echo "📋 Useful commands:"
    echo "   Check pods:     kubectl get pods -n devops-pets"
    echo "   Check services: kubectl get services -n devops-pets"
    echo "   View logs:      kubectl logs <pod-name> -n devops-pets"
    echo
    echo "🔧 To stop the application:"
    echo "   kubectl delete namespace devops-pets"
    echo
}

# Main execution
main() {
    echo "🚀 DevOps Pets - Automated Deployment from ZIP"
    echo "=============================================="
    echo
    
    # Check system requirements
    check_system_requirements
    
    # Check internet connectivity
    check_internet
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        print_warning "Running as root is not recommended"
        
        # Check if running in non-interactive mode
        if [ "$NON_INTERACTIVE" = true ]; then
            print_status "Non-interactive mode detected. Continuing with root privileges..."
        else
            # Interactive mode - ask user
            read -p "Do you want to continue? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
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