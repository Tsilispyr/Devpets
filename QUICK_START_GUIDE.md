# 🚀 DevOps Pets - Complete Quick Start Guide

## 📋 Overview

This is a complete DevOps project featuring:
- **Backend**: Spring Boot application with JWT authentication
- **Frontend**: Vue.js application with modern UI
- **Database**: PostgreSQL with persistent storage
- **Email Testing**: MailHog for development
- **CI/CD**: Jenkins with pre-configured pipelines
- **Containerization**: Docker & Kubernetes (Kind)
- **Automation**: Ansible for complete infrastructure automation

## 🎯 One Command Deployment

### **Complete Automation (Recommended):**
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

### **Alternative Methods:**

#### **Method 1: Download & Execute**
```bash
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh -o deploy.sh && chmod +x deploy.sh && ./deploy.sh
```

#### **Method 2: Git Clone & Execute**
```bash
git clone https://github.com/Tsilispyr/Devpets.git && cd Devpets && ./deploy.sh
```

#### **Method 3: Manual Deployment**
```bash
git clone https://github.com/Tsilispyr/Devpets.git && cd Devpets && sudo apt-get update && sudo apt-get install -y ansible && ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml
```

## 🛠️ What Gets Installed Automatically

### **Tools (only if missing):**
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

### **What Gets Preserved:**
- 🔒 **Existing tools** - Not reinstalled if present
- 🔒 **Kind cluster** - Preserved if exists
- 🔒 **System tools** - Not touched

### **What Gets Cleaned:**
- 🧹 **Project containers** - Only our project containers
- 🧹 **Project images** - Only our project images
- 🧹 **Project namespace** - Only the devops-pets namespace

## 🏗️ What Gets Deployed

### **Kubernetes Services:**
1. **Namespace**: `devops-pets`
2. **PostgreSQL**: Database with persistent storage
3. **MailHog**: Email testing service
4. **Backend**: Spring Boot application
5. **Frontend**: Vue.js application
6. **Jenkins**: CI/CD with pre-configured jobs

### **Port Configuration:**
- **Frontend**: http://localhost:8081
- **Backend API**: http://localhost:8080
- **MailHog**: http://localhost:8025
- **Jenkins**: http://localhost:8082

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

## 📊 Pipeline Stages

The Jenkins pipeline automatically:

1. **Check Tools** - Verify all required tools (without installation)
2. **Create Kind Cluster** - Create cluster if needed
3. **Clean Project Resources** - Remove only project resources
4. **Build and Load Images** - Docker build & load into kind
5. **Deploy with Ansible** - Kubernetes deployment
6. **Verify Deployment** - Health checks for all services
7. **Port Forward Services** - Expose services locally

## 🔍 Troubleshooting

### **Common Issues:**

#### **1. Permission Errors**
```bash
# If sudo password is required
ansible-playbook -i ansible/inventory.ini ansible/deploy-all.yml --ask-become-pass
```

#### **2. Network Issues**
```bash
# Check connectivity
ping google.com
curl -I https://download.docker.com
```

#### **3. Disk Space**
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

## 👥 Default Users

The system comes with pre-configured users:

- **Regular User**: `user` / `user`
- **Administrator**: `admin` / `admin`
- **Doctor**: `Doctor` / `Doctor`
- **Shelter**: `shelter` / `shelter`

## 🔐 Authentication System

The application uses **JWT (JSON Web Token)** based authentication. Users can register and login through the application without needing an external user management system.

## 👤 User Roles and Permissions

### **User**
- View animals in the Animal tab
- Request adoption for single or multiple animals
- Browse available pets

### **Shelter**
- View all available animals
- Approve or reject adoption requests
- Delete animals
- Submit new animal requests for approval

### **Doctor**
- View all animals
- Approve animal health checks
- Review adoption requests

### **Admin**
- All permissions from Shelter and Doctor roles
- Manage users (view, delete, modify roles)
- Approve animal requests
- Full system administration

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

## 🎯 System Requirements

### **Minimum Requirements:**
- **Operating System**: Linux (Ubuntu/Debian), macOS, or Windows with WSL
- **RAM**: At least 2GB available
- **Disk Space**: At least 10GB free space
- **Internet**: Stable internet connection
- **Permissions**: Sudo/Administrator access

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
- ✅ **Preserved existing tools and cluster**

---

**🚀 DevOps Pets - Complete Automation in One Command!** 