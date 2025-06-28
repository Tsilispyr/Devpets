#!/bin/bash

# DevOps Pets - One-Line Deployment Script
# This script can be run from anywhere to deploy the project
# Usage: curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/curl-deploy.sh | bash

set -e

echo "🚀 DevOps Pets - One-Line Deployment"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/Tsilispyr/Devpets.git"
REPO_DIR="Devpets"
CURRENT_DIR="$(pwd)"

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

# Function to setup repository
setup_repository() {
    echo -e "${YELLOW}📁 Setting up repository...${NC}"
    
    # Remove existing directory if it exists
    if [ -d "$REPO_DIR" ]; then
        echo -e "${YELLOW}📂 Repository exists, updating...${NC}"
        cd "$REPO_DIR"
        git fetch origin
        git reset --hard origin/main
        cd "$CURRENT_DIR"
    else
        echo -e "${YELLOW}📂 Cloning repository...${NC}"
        git clone "$REPO_URL" "$REPO_DIR"
    fi
    
    echo -e "${GREEN}✅ Repository ready at $CURRENT_DIR/$REPO_DIR${NC}"
}

# Function to run deployment
run_deployment() {
    echo -e "${YELLOW}🔧 Running deployment...${NC}"
    
    cd "$REPO_DIR"
    
    # Check if deploy.sh exists
    if [ ! -f "deploy.sh" ]; then
        echo -e "${RED}❌ deploy.sh not found in $REPO_DIR${NC}"
        exit 1
    fi
    
    # Make deploy.sh executable
    chmod +x deploy.sh
    
    # Run the deployment
    echo -e "${BLUE}🚀 Starting deployment from $REPO_DIR...${NC}"
    ./deploy.sh
    
    echo -e "${GREEN}✅ Deployment completed!${NC}"
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
    echo -e "${YELLOW}📋 Project location:${NC}"
    echo -e "📍 ${GREEN}$CURRENT_DIR/$REPO_DIR${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${YELLOW}📋 Useful commands:${NC}"
    echo -e "1. Check services: ${GREEN}cd $REPO_DIR && ./check-services.sh${NC}"
    echo -e "2. View logs: ${GREEN}kubectl logs -n devops-pets${NC}"
    echo -e "3. Stop port forwarding: ${GREEN}pkill -f 'kubectl port-forward'${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Main execution
main() {
    echo -e "${BLUE}🚀 DevOps Pets - One-Line Auto Deployment${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${YELLOW}📍 Current directory: $CURRENT_DIR${NC}"
    
    # Install prerequisites
    install_prerequisites
    
    # Setup repository
    setup_repository
    
    # Run deployment
    run_deployment
    
    # Display final status
    display_status
}

# Run main function
main "$@" 