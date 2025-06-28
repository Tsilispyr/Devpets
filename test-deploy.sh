#!/bin/bash

# DevOps Pets - Test Infrastructure Deployment
# Run with: curl -fsSL "https://raw.githubusercontent.com/Tsilispyr/Devpets/main/test-deploy.sh?t=$(date +%s)" | bash

set -e

echo "DevOps Pets - Test Infrastructure Deployment"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Function to detect OS and install prerequisites
install_prerequisites() {
    echo -e "${YELLOW}Installing prerequisites...${NC}"
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install -y git curl wget unzip software-properties-common
        
        # Install Ansible
        if ! command -v ansible &> /dev/null; then
            echo -e "${YELLOW}Installing Ansible...${NC}"
            sudo apt-add-repository --yes --update ppa:ansible/ansible
            sudo apt install -y ansible
        fi
        
        # Install Docker
        if ! command -v docker &> /dev/null; then
            echo -e "${YELLOW}Installing Docker...${NC}"
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
        fi
        
        # Install Kind
        if ! command -v kind &> /dev/null; then
            echo -e "${YELLOW}Installing Kind...${NC}"
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
            chmod +x ./kind
            sudo mv ./kind /usr/local/bin/kind
            sudo chown root:root /usr/local/bin/kind
            sudo chmod 755 /usr/local/bin/kind
        fi
        
        # Install kubectl
        if ! command -v kubectl &> /dev/null; then
            echo -e "${YELLOW}Installing kubectl...${NC}"
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            sudo mv kubectl /usr/local/bin/
            sudo chown root:root /usr/local/bin/kubectl
            sudo chmod 755 /usr/local/bin/kubectl
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git curl wget ansible docker kind kubectl
    else
        echo -e "${BOLD_RED}ERR! Unsupported OS: $OSTYPE${NC}"
        echo -e "${YELLOW}Please install the following manually:${NC}"
        echo "- Git, Ansible, Docker, Kind, kubectl"
        exit 1
    fi
    
    echo -e "${BOLD_GREEN}OK! Prerequisites installed${NC}"
}

# Function to setup repository
setup_repository() {
    echo -e "${YELLOW}Setting up repository...${NC}"
    
    # Check if we're already in the project directory
    if [ -f "ansible/deploy-all.yml" ] && [ -f "ansible/inventory.ini" ]; then
        echo -e "${BLUE}Already in project directory, updating repository...${NC}"
        git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "Could not update repository"
    else
        echo -e "${BLUE}Cloning repository...${NC}"
        # Create a temporary directory for cloning
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        
        # Clone the repository
        git clone https://github.com/Tsilispyr/Devpets.git pets-devops
        cd pets-devops
        
        # Update PROJECT_ROOT to point to the cloned directory
        PROJECT_ROOT="$(pwd)"
        echo -e "${BLUE}Repository cloned to: $PROJECT_ROOT${NC}"
    fi
    
    # Verify essential files exist
    if [ ! -f "ansible/inventory.ini" ]; then
        echo -e "${BOLD_RED}ERR! Inventory file not found after repository setup${NC}"
        exit 1
    fi
    
    if [ ! -f "ansible/deploy-all.yml" ]; then
        echo -e "${BOLD_RED}ERR! deploy-all.yml not found after repository setup${NC}"
        exit 1
    fi
    
    echo -e "${BOLD_GREEN}OK! Repository setup completed${NC}"
}

# Function to run test deployment
run_test_deployment() {
    echo -e "${YELLOW}Running infrastructure deployment...${NC}"
    
    # Change to project root directory
    cd "$PROJECT_ROOT"
    
    # Check if deploy-all.yml exists
    if [ ! -f "ansible/deploy-all.yml" ]; then
        echo -e "${BOLD_RED}ERR! deploy-all.yml not found at $PROJECT_ROOT/ansible/deploy-all.yml${NC}"
        exit 1
    fi
    
    # Run the deployment
    echo -e "${BLUE}Starting infrastructure deployment from $PROJECT_ROOT...${NC}"
    ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml --flush-cache
    
    echo -e "${BOLD_GREEN}OK! Infrastructure deployment completed!${NC}"
}

# Function to display final status
display_status() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BOLD_GREEN}OK! DevOps Pets infrastructure deployment completed!${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${YELLOW}Infrastructure Services Deployed:${NC}"
    echo -e "Jenkins: ${GREEN}http://localhost:8082${NC}"
    echo -e "MailHog: ${GREEN}http://localhost:8025${NC}"
    echo -e "PostgreSQL: ${GREEN}Running in cluster${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${YELLOW}Useful commands:${NC}"
    echo -e "1. Check services: ${GREEN}kubectl get all -n devops-pets${NC}"
    echo -e "2. View logs: ${GREEN}kubectl logs -n devops-pets${NC}"
    echo -e "3. Stop port forwarding: ${GREEN}pkill -f 'kubectl port-forward'${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}DevOps Pets - Test Infrastructure Deployment${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo -e "${YELLOW}Project root: $PROJECT_ROOT${NC}"
    echo -e "${YELLOW}Script directory: $SCRIPT_DIR${NC}"
    
    # Install prerequisites
    install_prerequisites
    
    # Setup repository
    setup_repository
    
    # Run test deployment
    run_test_deployment
    
    # Display final status
    display_status
}

# Run main function
main "$@" 