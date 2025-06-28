#!/bin/bash

# DevOps Pets - Complete One-Line Deployment
# Run with: curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash

set -e

echo "🚀 DevOps Pets - Complete Deployment"
echo "==================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Use relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Function to detect OS and install prerequisites
install_prerequisites() {
    echo -e "${YELLOW}📦 Installing prerequisites...${NC}"
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        sudo apt update
        sudo apt install -y git curl wget unzip software-properties-common
        
        # Install Ansible
        if ! command -v ansible &> /dev/null; then
            echo -e "${YELLOW}🔧 Installing Ansible...${NC}"
            sudo apt-add-repository --yes --update ppa:ansible/ansible
            sudo apt install -y ansible
        fi
        
        # Install Docker
        if ! command -v docker &> /dev/null; then
            echo -e "${YELLOW}🐳 Installing Docker...${NC}"
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo usermod -aG docker $USER
            rm get-docker.sh
        fi
        
        # Install Kind
        if ! command -v kind &> /dev/null; then
            echo -e "${YELLOW}⚙️ Installing Kind...${NC}"
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
            chmod +x ./kind
            sudo mv ./kind /usr/local/bin/kind
            sudo chown root:root /usr/local/bin/kind
            sudo chmod 755 /usr/local/bin/kind
        fi
        
        # Install kubectl
        if ! command -v kubectl &> /dev/null; then
            echo -e "${YELLOW}🔧 Installing kubectl...${NC}"
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            chmod +x kubectl
            sudo mv kubectl /usr/local/bin/
            sudo chown root:root /usr/local/bin/kubectl
            sudo chmod 755 /usr/local/bin/kubectl
        fi
        
        # Install Java
        if ! command -v java &> /dev/null; then
            echo -e "${YELLOW}☕ Installing Java...${NC}"
            sudo apt install -y openjdk-21-jdk
        fi
        
        # Install Node.js
        if ! command -v node &> /dev/null; then
            echo -e "${YELLOW}📦 Installing Node.js...${NC}"
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
            sudo apt install -y nodejs
        fi
        
        # Install Maven
        if ! command -v mvn &> /dev/null; then
            echo -e "${YELLOW}🔨 Installing Maven...${NC}"
            sudo apt install -y maven
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}🍺 Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install git curl wget ansible docker kind kubectl openjdk@21 node maven
    else
        echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
        echo -e "${YELLOW}Please install the following manually:${NC}"
        echo "- Git, Ansible, Docker, Kind, kubectl, Java, Node.js, Maven"
        exit 1
    fi
    
    echo -e "${GREEN}✅ Prerequisites installed${NC}"
}

# Function to run Ansible deployment
run_ansible_deployment() {
    echo -e "${YELLOW}🔧 Running Ansible deployment...${NC}"
    
    # Change to project root directory
    cd "$PROJECT_ROOT"
    
    # Check if inventory exists
    if [ ! -f "ansible/inventory.ini" ]; then
        echo -e "${RED}❌ Inventory file not found at $PROJECT_ROOT/ansible/inventory.ini${NC}"
        exit 1
    fi
    
    # Check if deploy-all.yml exists
    if [ ! -f "ansible/deploy-all.yml" ]; then
        echo -e "${RED}❌ deploy-all.yml not found at $PROJECT_ROOT/ansible/deploy-all.yml${NC}"
        exit 1
    fi
    
    # Run the deployment
    echo -e "${BLUE}🚀 Starting Ansible deployment from $PROJECT_ROOT...${NC}"
    ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
    
    echo -e "${GREEN}✅ Deployment completed!${NC}"
}

# Function to run port forwarding with retry
run_port_forwarding() {
    echo -e "${YELLOW}🔌 Starting port forwarding...${NC}"
    
    # Change to project root directory
    cd "$PROJECT_ROOT"
    
    # Function to start port forwarding with retry
    start_port_forward_with_retry() {
        local service=$1
        local port=$2
        local script=$3
        local max_retries=3
        local retry_count=0
        
        echo -e "${YELLOW}📡 Starting $service port forwarding on port $port...${NC}"
        
        while [ $retry_count -lt $max_retries ]; do
            # Kill any existing port forwarding
            pkill -f "kubectl port-forward.*$service" 2>/dev/null || true
            
            # Start port forwarding
            if [ -f "ansible/$script" ]; then
                bash "ansible/$script"
            else
                # Fallback to direct kubectl command
                nohup kubectl port-forward svc/$service $port:$port -n devops-pets > /dev/null 2>&1 &
                sleep 3
            fi
            
            # Check if port forwarding is working
            if curl -s http://localhost:$port >/dev/null 2>&1; then
                echo -e "${GREEN}✅ $service port forwarding started successfully on port $port${NC}"
                return 0
            else
                retry_count=$((retry_count + 1))
                echo -e "${YELLOW}⚠️ $service port forwarding failed, retrying... (attempt $retry_count/$max_retries)${NC}"
                sleep 5
            fi
        done
        
        echo -e "${RED}❌ Failed to start $service port forwarding after $max_retries attempts${NC}"
        return 1
    }
    
    # Start MailHog port forwarding
    start_port_forward_with_retry "mailhog" "8025" "start-mailhog-port-forward.sh"
    
    # Start Jenkins port forwarding
    start_port_forward_with_retry "jenkins" "8082" "start-jenkins-port-forward.sh"
    
    echo -e "${GREEN}✅ Port forwarding setup completed${NC}"
}

# Function to display final status
display_status() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${GREEN}🎉 DevOps Pets deployment completed!${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${YELLOW}📋 Access URLs:${NC}"
    echo -e "📧 MailHog: ${GREEN}http://localhost:8025${NC}"
    echo -e "🔧 Jenkins: ${GREEN}http://localhost:8082${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${YELLOW}📋 Useful commands:${NC}"
    echo -e "1. Check services: ${GREEN}cd $PROJECT_ROOT && ./check-services.sh${NC}"
    echo -e "2. View logs: ${GREEN}kubectl logs -n devops-pets${NC}"
    echo -e "3. Stop port forwarding: ${GREEN}pkill -f 'kubectl port-forward'${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}🚀 DevOps Pets - Complete Auto Deployment${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${YELLOW}📍 Project root: $PROJECT_ROOT${NC}"
    echo -e "${YELLOW}📍 Script directory: $SCRIPT_DIR${NC}"
    
    # Install prerequisites
    install_prerequisites
    
    # Run Ansible deployment
    run_ansible_deployment
    
    # Run port forwarding with retry
    run_port_forwarding
    
    # Display final status
    display_status
}

# Run main function
main "$@" 