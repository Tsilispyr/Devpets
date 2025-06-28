# 🚀 DevOps Pets - Complete Installation & Usage Guide

## 📋 Overview

This document describes the complete installation, execution, and usage of the DevOps Pets application in a local development environment. The project now features **complete automation** with one-command deployment.

## 🎯 Quick Start (Recommended)

### **One Command Deployment:**
```bash
# Download and execute the deployment script
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash
```

This single command will:
- ✅ Detect your operating system
- ✅ Install all required dependencies
- ✅ Clone the repository
- ✅ Verify project structure
- ✅ Deploy the complete application
- ✅ Display access URLs

## 🔐 Authentication System

The application uses **JWT (JSON Web Token) authentication** for security. Users can register and login through the application without needing an external user management system.

## ⚙️ System Requirements

### **Minimum Requirements:**
- **Operating System**: Linux (Ubuntu/Debian), macOS, or Windows with WSL
- **RAM**: At least 2GB available
- **Disk Space**: At least 10GB free space
- **Internet**: Stable internet connection
- **Permissions**: Sudo/Administrator access

### **What Gets Installed Automatically:**
- ✅ **Docker** - Container runtime
- ✅ **Kind** - Kubernetes in Docker
- ✅ **Kubectl** - Kubernetes CLI
- ✅ **Java** - OpenJDK 17
- ✅ **Maven** - Build tool (version 3.9.5)
- ✅ **Node.js** - v18.x
- ✅ **npm** - Node Package Manager
- ✅ **Git** - Version control
- ✅ **Python 3** - Python interpreter
- ✅ **pip** - Python package manager
- ✅ **Docker Compose** - Multi-container apps
- ✅ **Ansible** - Automation tool

## 🚀 Installation Methods

### **Method 1: Automated Script (Recommended)**

```bash
# Download and execute in one command
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash
```

### **Method 2: Manual Download & Execute**

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh -o deploy.sh

# Make it executable
chmod +x deploy.sh

# Run the deployment
./deploy.sh
```

### **Method 3: Git Clone & Execute**

```bash
# Clone the repository
git clone https://github.com/Tsilispyr/Devpets.git

# Navigate to project directory
cd Devpets

# Run the deployment script
./deploy.sh
```

### **Method 4: Manual Step-by-Step**

```bash
# 1. Clone the repository
git clone https://github.com/Tsilispyr/Devpets.git
cd Devpets

# 2. Install Ansible (Ubuntu/Debian)
sudo apt update
sudo apt install -y ansible python3-pip

# 3. Install Ansible collections
cd ansible
ansible-galaxy collection install -r requirements.yml
cd ..

# 4. Run the deployment
ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
```

## 🌐 Accessing Services

After successful deployment, access the services at:

- **Frontend Application**: http://localhost:8081
- **Backend API**: http://localhost:8080
- **Jenkins CI/CD**: http://localhost:8082
- **MailHog Email Testing**: http://localhost:8025

## 👥 Default Users

The system comes with pre-configured users:

- **Regular User**: `user` / `user`
- **Administrator**: `admin` / `admin`
- **Doctor**: `Doctor` / `Doctor`
- **Shelter**: `shelter` / `shelter`

## 🏗️ What Gets Deployed

### **Kubernetes Services:**
1. **Namespace**: `devops-pets`
2. **PostgreSQL**: Database with persistent storage
3. **MailHog**: Email testing service
4. **Backend**: Spring Boot application
5. **Frontend**: Vue.js application
6. **Jenkins**: CI/CD with pre-configured jobs

### **Port Configuration:**
- **Frontend**: 8081
- **Backend API**: 8080
- **MailHog**: 8025
- **Jenkins**: 8082

## 🔧 Jenkins Setup

### **Pre-configured Features:**
- ✅ **Credentials**: Git and kubeconfig automatically configured
- ✅ **Job**: `backend-pipeline-devops-pets` ready to use
- ✅ **Security**: Unsecured mode (no login required)
- ✅ **Pipeline**: Complete CI/CD with Ansible integration

### **Using Jenkins:**
1. Open http://localhost:8082
2. Find the job `backend-pipeline-devops-pets`
3. Click "Build Now"
4. Monitor the pipeline execution

## 📊 Deployment Process

The automated deployment includes:

1. **System Check** - Verify OS and requirements
2. **Dependency Installation** - Install missing tools only
3. **Repository Setup** - Clone or extract project
4. **Tool Verification** - Ensure all tools are available
5. **Kind Cluster** - Create Kubernetes cluster if needed
6. **Clean Deployment** - Remove old project resources
7. **Image Building** - Build fresh Docker images
8. **Kubernetes Deployment** - Deploy all services
9. **Health Verification** - Wait for all services to be ready
10. **Port Forwarding** - Expose services locally
11. **Success Display** - Show access URLs

## 🔍 Troubleshooting

### **Common Issues:**

#### **1. Permission Errors**
```bash
# If sudo password is required
ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml --ask-become-pass
```

#### **2. Network Connectivity Issues**
```bash
# Check internet connectivity
ping google.com
curl -I https://download.docker.com
```

#### **3. Disk Space Issues**
```bash
# Check available disk space
df -h
```

#### **4. Memory Issues**
```bash
# Check available RAM
free -h
```

#### **5. Port Conflicts**
```bash
# Check if ports are already in use
netstat -tulpn | grep :808
```

### **Service Logs:**
  ```bash
# Jenkins logs
kubectl logs deployment/jenkins -n devops-pets

# Backend logs
kubectl logs deployment/backend -n devops-pets

# Frontend logs
kubectl logs deployment/frontend -n devops-pets

# PostgreSQL logs
kubectl logs deployment/postgres -n devops-pets
```

### **Service Status:**
```bash
# Check all pods status
kubectl get pods -n devops-pets

# Check all services
kubectl get services -n devops-pets

# Check all deployments
kubectl get deployments -n devops-pets
```

## 🧹 Cleanup

### **Complete Cleanup:**
```bash
# Remove all project resources
ansible-playbook -i ansible/inventory.ini ansible/clean-and-rebuild.yml
```

### **Partial Cleanup:**
```bash
# Remove only Kubernetes resources
kubectl delete namespace devops-pets

# Remove only Docker images
docker rmi $(docker images | grep devops-pets | awk '{print $3}')
```

## 🔄 Redeployment

### **Fresh Redeployment:**
```bash
# Clean and redeploy everything
ansible-playbook -i ansible/inventory.ini ansible/clean-and-rebuild.yml
```

### **Update Deployment:**
```bash
# Deploy without cleaning (faster)
ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
```

## 📞 Support

If you encounter issues:

1. **Check the deployment logs** for error messages
2. **Verify all services are running**: `kubectl get pods -n devops-pets`
3. **Check service logs**: `kubectl logs <pod-name> -n devops-pets`
4. **Restart services if needed**: `kubectl rollout restart deployment/<name> -n devops-pets`
5. **Check system resources**: CPU, RAM, and disk space

## 🎉 Success!

After successful deployment, you will have:
- ✅ Complete DevOps environment
- ✅ Automated CI/CD pipeline
- ✅ Containerized applications
- ✅ Kubernetes orchestration
- ✅ Email testing capabilities
- ✅ Database persistence
- ✅ JWT authentication system
- ✅ Modern responsive UI

---

**🚀 DevOps Pets - Complete Automation in One Command!**