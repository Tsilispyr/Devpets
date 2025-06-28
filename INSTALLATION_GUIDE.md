# DevOps Pets - Complete Installation & Usage Guide

## Overview

DevOps Pets is a comprehensive DevOps automation project that demonstrates modern CI/CD practices. This guide provides detailed instructions for installing and using the complete system.

### What This Project Does

- **Detect your operating system** automatically
- **Install all required dependencies**
- **Clone the repository**
- **Verify project structure**
- **Deploy the complete application**
- **Display access URLs**

## System Requirements

### Minimum Requirements
- **Operating System**: Linux (Ubuntu 20.04+), macOS 10.15+, or Windows 10+ with WSL2
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 10GB free space
- **Internet Connection**: Required for downloading dependencies
- **Administrator Privileges**: Required for installing system packages

### Required Software (Installed Automatically)
- **Docker** - Container runtime
- **Kind** - Kubernetes in Docker
- **Kubectl** - Kubernetes CLI
- **Java** - OpenJDK 17
- **Maven** - Build tool (version 3.9.5)
- **Node.js** - v18.x
- **npm** - Node Package Manager
- **Git** - Version control
- **Python 3** - Python interpreter
- **pip** - Python package manager
- **Docker Compose** - Multi-container apps
- **Ansible** - Automation tool

## Installation Methods

### Method 1: One-Line Installation (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/curl-deploy.sh | bash
```

This command will:
1. Download the deployment script
2. Install all missing dependencies
3. Clone the repository
4. Deploy the complete application
5. Display access URLs

### Method 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/Tsilispyr/Devpets.git
cd Devpets

# Run the deployment script
./deploy.sh
```

### Method 3: From ZIP File

```bash
# Download the ZIP file
wget https://github.com/Tsilispyr/Devpets/archive/refs/heads/main.zip -O Devpets-main.zip

# Extract and run
unzip Devpets-main.zip
cd Devpets-main
./deploy.sh
```

### Method 4: Step-by-Step Manual Installation

```bash
# 1. Install system dependencies
sudo apt update
sudo apt install -y git curl wget unzip software-properties-common

# 2. Install Ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# 3. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 4. Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# 5. Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# 6. Install Java and Maven
sudo apt install -y openjdk-17-jdk maven

# 7. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 8. Clone and deploy
git clone https://github.com/Tsilispyr/Devpets.git
cd Devpets
./deploy.sh
```

## Accessing Services

After successful deployment, you can access the following services:

### Web Interfaces
- **MailHog Email Testing**: http://localhost:8025
- **Jenkins CI/CD**: http://localhost:8082

### Internal Services
- **Frontend Application**: http://localhost:8081 (if exposed)
- **Backend API**: http://localhost:8080 (if exposed)
- **PostgreSQL Database**: localhost:5432 (internal)

### Default Credentials
- **Jenkins**: No authentication required (unsecured mode)
- **Database**: petuser / petdb (internal access only)

## What Gets Deployed

### Core Services
1. **PostgreSQL Database**
   - Version: 15
   - Database: petdb
   - Username: petuser
   - Persistent storage enabled

2. **MailHog Email Service**
   - Purpose: Email testing for development
   - Web UI: http://localhost:8025
   - SMTP Port: 1025

3. **Jenkins CI/CD Server**
   - Version: LTS
   - Port: 8082
   - Pre-installed plugins
   - Unsecured mode (no login required)

### Application Components
1. **Backend Application**
   - Technology: Spring Boot (Java)
   - Authentication: JWT-based
   - API: RESTful endpoints
   - Database: PostgreSQL

2. **Frontend Application**
   - Technology: Vue.js 3
   - UI: Modern responsive design
   - Authentication: JWT integration

## Jenkins Setup

The Jenkins server comes pre-configured with:

- **Credentials**: Git and kubeconfig automatically configured
- **Job**: `backend-pipeline-devops-pets` ready to use
- **Security**: Unsecured mode (no login required)
- **Pipeline**: Complete CI/CD with Ansible integration

### Jenkins Features
- Pre-installed essential plugins
- Host tools mounted (docker, kubectl, git, maven, node)
- Persistent configuration storage
- Automatic pipeline execution

### Accessing Jenkins
1. Open http://localhost:8082 in your browser
2. No login required (unsecured mode)
3. Navigate to the `backend-pipeline-devops-pets` job
4. Click "Build Now" to start the pipeline

## Troubleshooting

### Common Issues

#### 1. Port Already in Use
```bash
# Stop existing port forwarding
pkill -f 'kubectl port-forward'

# Kill processes using specific ports
sudo lsof -ti:8025 | xargs kill -9
sudo lsof -ti:8082 | xargs kill -9
```

#### 2. Docker Permission Issues
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker
```

#### 3. Kubernetes Cluster Issues
```bash
# Delete and recreate cluster
kind delete cluster --name devops-pets
./deploy.sh
```

#### 4. Ansible Connection Issues
```bash
# Check Ansible installation
ansible --version

# Reinstall Ansible if needed
sudo apt remove ansible
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible
```

### Useful Commands

```bash
# Check service status
./check-services.sh

# View Kubernetes pods
kubectl get pods -n devops-pets

# View service logs
kubectl logs -n devops-pets

# Restart services
kubectl rollout restart deployment/jenkins -n devops-pets
kubectl rollout restart deployment/mailhog -n devops-pets

# Access service shells
kubectl exec -it <pod-name> -n devops-pets -- /bin/bash

# Check cluster status
kind get clusters
kubectl cluster-info
```

### Log Locations
- **Application Logs**: `kubectl logs -n devops-pets`
- **Jenkins Logs**: `kubectl logs -n devops-pets deployment/jenkins`
- **MailHog Logs**: `kubectl logs -n devops-pets deployment/mailhog`
- **System Logs**: `journalctl -u docker`

## Maintenance

### Updating the Application
```bash
# Pull latest changes
cd Devpets
git pull origin main

# Redeploy
./deploy.sh
```

### Cleaning Up
```bash
# Stop all services
kubectl delete namespace devops-pets

# Delete cluster
kind delete cluster --name devops-pets

# Clean Docker
docker system prune -af

# Remove project files
rm -rf Devpets
```

### Backup and Restore
```bash
# Backup Jenkins configuration
cp -r jenkins_home jenkins_home_backup

# Restore Jenkins configuration
rm -rf jenkins_home
cp -r jenkins_home_backup jenkins_home
```

## Success!

After successful deployment, you will have:

- **Complete DevOps environment**
- **Automated CI/CD pipeline**
- **Containerized applications**
- **Kubernetes orchestration**
- **Email testing capabilities**
- **Database persistence**
- **JWT authentication system**
- **Modern responsive UI**

**DevOps Pets - Complete Automation in One Command!**