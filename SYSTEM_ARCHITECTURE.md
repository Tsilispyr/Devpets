# 🏗️ DevOps Pets - Complete System Architecture

## 📋 System Overview

DevOps Pets is a complete DevOps environment featuring:

### **🎯 Core Principles:**
- **Single Server**: Everything runs on the same server
- **Kind Cluster**: Kubernetes cluster inside Docker
- **Jenkins Integration**: Jenkins runs inside the Kind cluster
- **Ansible Automation**: Complete automation
- **Fresh Builds**: Clean, updated images every time
- **One-Command Deployment**: Complete automation with a single command

## 🚀 Deployment Architecture

### **One-Command Deployment Process:**
```bash
# Single command that does everything
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.sh | bash
```

This command automatically:
1. **Detects OS** and installs appropriate dependencies
2. **Installs tools** (only if missing)
3. **Clones repository** or extracts from zip
4. **Verifies project structure**
5. **Runs Ansible deployment**
6. **Displays access URLs**

## 🔄 How the Jenkinsfile Works

### **Stage 1: Check Tools**
```bash
# Verifies all required tools exist
which kind && kind --version
which docker && docker --version
which kubectl && kubectl version --client
which mvn && mvn -v
which npm && npm -v
which node && node -v
which git && git --version
which ansible && ansible --version
```

### **Stage 2: Create Kind Cluster**
```bash
# Creates Kind cluster if it doesn't exist
if ! kind get clusters | grep -q "kind"; then
    kind create cluster --config kind-config.yaml --name kind
fi
kind export kubeconfig --name kind
```

### **Stage 3: Clean Project Resources**
```bash
# Removes only project-specific resources
kubectl delete namespace devops-pets --ignore-not-found=true
docker stop $(docker ps -q --filter "ancestor=devops-pets-*") 2>/dev/null || true
docker rmi $(docker images | grep devops-pets | awk '{print $3}') 2>/dev/null || true
```

### **Stage 4: Build and Load Images**
```bash
# Builds fresh Docker images
docker build -t devops-pets-backend:latest ./Ask
docker build -t devops-pets-frontend:latest ./frontend

# Loads images into Kind cluster
kind load docker-image devops-pets-backend:latest
kind load docker-image devops-pets-frontend:latest
```

### **Stage 5: Deploy with Ansible**
```bash
# Applies all K8s manifests with Ansible
cd ansible
ansible-playbook -i inventory.ini deploy-all.yml
```

### **Stage 6: Verify Deployment**
```bash
# Verifies everything is running
kubectl get pods -n devops-pets
kubectl get services -n devops-pets
kubectl get deployments -n devops-pets
```

### **Stage 7: Port Forward Services**
```bash
# Exposes services to localhost
kubectl port-forward svc/frontend 8081:80 &
kubectl port-forward svc/backend 8080:8080 &
kubectl port-forward svc/mailhog 8025:8025 &
kubectl port-forward svc/jenkins 8082:8080 &
```

## 🏗️ Ansible Deployment Process

### **1. Prerequisites Installation**
- Checks if tools exist
- Installs missing tools automatically
- Sets proper permissions and ownership
- Places binaries in `/usr/local/bin`

### **2. Kind Cluster Creation**
- Checks if cluster exists
- Creates new cluster if needed
- Uses `kind-config.yaml` configuration
- Exports kubeconfig

### **3. Clean and Rebuild**
- Stops old project containers
- Removes old project images
- Performs Docker system prune
- Prepares for clean build

### **4. Docker Image Building**
- Builds backend image (Spring Boot)
- Builds frontend image (Vue.js)
- Builds Jenkins image (custom with all tools)
- Loads all into Kind cluster

### **5. Kubernetes Deployment**
- Creates namespace `devops-pets`
- Applies PostgreSQL (DB, Service, PVC, Secret)
- Applies MailHog (Email testing)
- Applies Backend (Spring Boot app)
- Applies Frontend (Vue.js app)
- Applies Jenkins (CI/CD)

### **6. Dynamic Health Checks & Waiting**
- Waits for PostgreSQL to be ready (dynamic timeout)
- Waits for MailHog to be ready (dynamic timeout)
- Waits for Backend to be ready (dynamic timeout)
- Waits for Frontend to be ready (dynamic timeout)
- Waits for Jenkins to be ready (dynamic timeout)

### **7. Verification**
- Checks all pods are running
- Displays status report
- Shows access URLs

## 🎯 Key Questions Answered

### **1. What does the Jenkinsfile do?**
The Jenkinsfile is a **CI/CD pipeline** that:
- ✅ Checks prerequisites
- ✅ Creates Kind cluster if needed
- ✅ Cleans project resources
- ✅ Builds Docker images
- ✅ Deploys to Kubernetes
- ✅ Verifies deployment
- ✅ Exposes services

### **2. Does it go to the same server as the Kind cluster?**
**YES!** Jenkins runs **inside** the Kind cluster:
- Jenkins pod → Kind cluster → Docker → Host server
- Everything is on the same server
- Jenkins can access all services

### **3. Does Ansible start a new Kind?**
**YES!** Ansible:
- ✅ Checks if Kind cluster exists
- ✅ Creates new cluster if needed
- ✅ Uses `kind-config.yaml`
- ✅ Exports kubeconfig

### **4. Does it create clean, updated images?**
**YES!** Ansible:
- ✅ Stops old project containers
- ✅ Removes old project images
- ✅ Performs Docker system prune
- ✅ Builds new images from scratch

### **5. Does it do all operations in sequence with waits?**
**YES!** Ansible:
- ✅ Applies manifests in correct order
- ✅ Waits for each deployment to be ready
- ✅ Dynamic timeouts for each service
- ✅ Error handling at each step
- ✅ Stops if something fails

## 🔧 System Architecture

```
Host Server (Ubuntu/Debian/macOS/Windows)
├── Docker Engine
│   ├── Kind Cluster (Kubernetes)
│   │   ├── PostgreSQL Pod (Database)
│   │   ├── MailHog Pod (Email Testing)
│   │   ├── Backend Pod (Spring Boot)
│   │   ├── Frontend Pod (Vue.js)
│   │   └── Jenkins Pod ← CI/CD Pipeline
│   └── Docker Images
├── Ansible (Automation)
├── Local Tools (kind, kubectl, etc.)
└── Deployment Script (deploy.sh)
```

## 🎛️ Jenkins Integration

### **Pre-configured Features:**
- ✅ **Credentials**: Git and kubeconfig automatically configured
- ✅ **Job**: `backend-pipeline-devops-pets` ready to use
- ✅ **Security**: Unsecured mode (no login required)
- ✅ **Pipeline**: Complete CI/CD with Ansible integration
- ✅ **Tools**: All required tools installed in Jenkins container

### **How it works:**
1. Jenkins runs inside the Kind cluster
2. Can access all services
3. Uses the same kubeconfig
4. Executes the Jenkinsfile pipeline
5. Deploys to the same cluster

## 🚀 Advantages

### **Single Server:**
- ✅ Everything on the same server
- ✅ Simple management
- ✅ Less complexity
- ✅ Easy troubleshooting

### **Complete Automation:**
- ✅ One-command deployment
- ✅ Automatic tool installation
- ✅ Dynamic health checks
- ✅ Error handling and recovery
- ✅ Cross-platform support

### **Fresh Deployments:**
- ✅ Clean builds every time
- ✅ No stale data
- ✅ Consistent environment
- ✅ Reproducible deployments

### **Tool Management:**
- ✅ Installs only missing tools
- ✅ Preserves existing tools
- ✅ Proper permissions
- ✅ Cross-platform compatibility

## 🔐 Security Features

### **JWT Authentication:**
- ✅ Built-in authentication system
- ✅ No external dependencies
- ✅ Secure token-based auth
- ✅ Role-based access control

### **Container Security:**
- ✅ Isolated containers
- ✅ Network policies
- ✅ Resource limits
- ✅ Security contexts

## 📊 Monitoring & Logging

### **Health Checks:**
- ✅ Pod readiness probes
- ✅ Service health monitoring
- ✅ Automatic restart on failure
- ✅ Status reporting

### **Logging:**
- ✅ Container logs
- ✅ Application logs
- ✅ System logs
- ✅ Error tracking

## 🌐 Network Architecture

### **Port Configuration:**
- **Frontend**: 8081 (HTTP)
- **Backend API**: 8080 (HTTP)
- **MailHog**: 8025 (HTTP)
- **Jenkins**: 8082 (HTTP)
- **PostgreSQL**: 5432 (internal)

### **Service Discovery:**
- ✅ Kubernetes DNS
- ✅ Service mesh
- ✅ Load balancing
- ✅ Health checks

## 🔄 Deployment Flow

```
1. User runs deploy.sh
   ↓
2. OS detection & dependency installation
   ↓
3. Repository setup (clone/extract)
   ↓
4. Ansible deployment
   ↓
5. Kind cluster creation
   ↓
6. Docker image building
   ↓
7. Kubernetes deployment
   ↓
8. Health verification
   ↓
9. Port forwarding
   ↓
10. Success display
```

## 🎉 Success Metrics

After successful deployment:
- ✅ All services running
- ✅ Health checks passing
- ✅ Ports accessible
- ✅ Authentication working
- ✅ CI/CD pipeline ready
- ✅ Database persistent
- ✅ Email testing available

---

**🚀 DevOps Pets - Complete Automation Architecture!** 