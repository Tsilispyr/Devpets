# 🚀 DevOps Pets - Complete Automated Deployment

## 📋 Project Overview

DevOps Pets is a comprehensive DevOps project featuring:
- **Backend**: Spring Boot application with JWT authentication
- **Frontend**: Vue.js application with modern UI
- **Database**: PostgreSQL with persistent storage
- **Email Testing**: MailHog for development
- **CI/CD**: Jenkins with pre-configured pipelines
- **Containerization**: Docker & Kubernetes (Kind)
- **Automation**: Ansible for complete infrastructure automation

## 🎯 Quick Start (One Command)

### **For Complete Automation:**
```bash
# Download and execute the deployment script
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash
```

**This single command will:**
- ✅ **Detect your operating system** automatically
- ✅ **Install all required dependencies** (only if missing)
- ✅ **Clone the repository** or extract from zip if present
- ✅ **Verify project structure** and files
- ✅ **Deploy the complete application** with Ansible
- ✅ **Display access URLs** when finished
- ✅ **Handle all prompts automatically** (non-interactive mode)
- ✅ **Install missing tools automatically** (Docker, Kind, kubectl, Java, Node.js, etc.)

**No user interaction required!** The script detects when running via `curl | bash` and handles everything automatically, including installing any missing tools with proper permissions in `/usr/local/bin`.

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

#### **Method 4: If curl doesn't work**
```bash
# Download with wget
wget -O deploy.sh https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh && chmod +x deploy.sh && ./deploy.sh

# Or download manually and run
# 1. Visit: https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh
# 2. Save as deploy.sh
# 3. Run: chmod +x deploy.sh && ./deploy.sh
```

## 🌐 Access URLs

After successful deployment:
- **Frontend**: http://localhost:8081
- **Backend API**: http://localhost:8080
- **Jenkins**: http://localhost:8082
- **MailHog**: http://localhost:8025

## 👥 Default Users

- **User**: `user` / `user`
- **Admin**: `admin` / `admin`
- **Doctor**: `Doctor` / `Doctor`
- **Shelter**: `shelter` / `shelter`

## 🔐 Authentication System

This application uses **JWT (JSON Web Token)** based authentication. Users can register and login through the application's built-in authentication system.

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

## 🏗️ System Architecture

- **Frontend**: Vue.js with JWT authentication
- **Backend**: Spring Boot REST API with JWT security
- **Database**: PostgreSQL with persistent storage
- **Email**: MailHog for development testing
- **CI/CD**: Jenkins with automated pipelines
- **Containerization**: Docker & Kubernetes (Kind)
- **Automation**: Ansible for infrastructure management

## 🛠️ What Gets Installed Automatically

### **Tools (only if missing):**
- ✅ Docker & Docker Compose
- ✅ Kubernetes (Kind) & Kubectl
- ✅ Java (OpenJDK 17) & Maven 3.9.5
- ✅ Node.js 18 & npm
- ✅ Git, Python3, pip
- ✅ Ansible with required collections

### **Services Deployed:**
- ✅ PostgreSQL Database
- ✅ MailHog Email Service
- ✅ Backend Application
- ✅ Frontend Application
- ✅ Jenkins CI/CD

## 🔧 Jenkins Pipeline

The Jenkins pipeline automatically:
1. **Checks** all required tools
2. **Creates** Kind cluster if needed
3. **Cleans** project resources
4. **Builds** Docker images
5. **Deploys** with Ansible
6. **Verifies** deployment
7. **Starts** port forwarding

## 📚 Documentation

- **[Quick Start Guide](QUICK_START_GUIDE.md)** - Detailed step-by-step instructions
- **[Installation Guide](INSTALLATION_GUIDE.md)** - Comprehensive setup guide
- **[System Architecture](SYSTEM_ARCHITECTURE.md)** - Technical architecture details

## 🚀 Features

- **🔄 Complete Automation** - One command deployment with zero user interaction
- **🛡️ Error Handling** - Robust error handling and recovery with automatic retries
- **🔧 Tool Management** - Installs only missing tools, preserves existing ones
- **🧹 Clean Deployment** - Fresh deployment every time with automatic cleanup
- **📊 Health Monitoring** - Automatic health checks and system requirements validation
- **🌐 Port Management** - Automatic port forwarding and service exposure
- **🔐 Security** - JWT authentication system with role-based access
- **📱 Responsive UI** - Modern Vue.js frontend with excellent UX
- **🌍 Cross-Platform** - Works on Linux, macOS, and Windows (WSL)
- **📡 Network Validation** - Automatic internet connectivity and system requirements checks
- **🔄 Smart Recovery** - Handles corrupted directories and failed downloads automatically

## 🎉 Getting Started

1. **Run the deployment script** (see Quick Start above)
2. **Wait for completion** (5-10 minutes)
3. **Access the application** via the URLs above
4. **Start using the system** with default users

## 📞 Support

If you encounter issues:
1. Check the deployment logs
2. Verify all services are running: `kubectl get pods -n devops-pets`
3. Check service logs: `kubectl logs <pod-name> -n devops-pets`
4. Restart services if needed: `kubectl rollout restart deployment/<name> -n devops-pets`

---

**🎯 DevOps Pets - Complete DevOps Automation in One Command!**



 
