# DevOps Pets Architecture Guide

## Overview

This project follows a **separation of concerns** architecture with two distinct layers:

### 🏗️ **Infrastructure Layer (Ansible)**
- **Purpose**: Deploy and manage infrastructure services
- **Tools**: Ansible, Kind, Kubernetes
- **Services**: PostgreSQL, MailHog, Jenkins
- **Frequency**: One-time setup or infrastructure changes

### 🚀 **Application Layer (Jenkins)**
- **Purpose**: Build and deploy applications
- **Tools**: Jenkins, Docker, Kubernetes
- **Services**: Frontend, Backend
- **Frequency**: Continuous deployment on code changes

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    DEVOPS PETS SYSTEM                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   ANSIBLE       │    │    JENKINS      │                │
│  │ (Infrastructure)│    │ (Applications)  │                │
│  └─────────────────┘    └─────────────────┘                │
│           │                       │                        │
│           ▼                       ▼                        │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              KIND KUBERNETES CLUSTER                │    │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐   │    │
│  │  │ PostgreSQL  │ │   MailHog   │ │   Jenkins   │   │    │
│  │  │ (Database)  │ │ (Email)     │ │ (CI/CD)     │   │    │
│  │  └─────────────┘ └─────────────┘ └─────────────┘   │    │
│  │                                                     │    │
│  │  ┌─────────────┐ ┌─────────────┐                   │    │
│  │  │  Backend    │ │  Frontend   │                   │    │
│  │  │ (Spring)    │ │  (Vue.js)   │                   │    │
│  │  └─────────────┘ └─────────────┘                   │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Deployment Flow

### 1. **Infrastructure Deployment (Ansible)**
```bash
# Deploy infrastructure once
ansible-playbook ansible/deploy-all.yml --become
```

**What it does:**
- Creates Kind cluster
- Deploys PostgreSQL (database)
- Deploys MailHog (email service)
- Deploys Jenkins (CI/CD server)
- Sets up RBAC and networking

### 2. **Application Deployment (Jenkins)**
```bash
# Jenkins automatically triggers on code changes
# Or manually trigger from Jenkins UI
```

**What it does:**
- Builds frontend Docker image
- Builds backend Docker image
- Deploys applications to Kubernetes
- Sets up port forwarding
- Runs tests and verification

## Service Dependencies

### Infrastructure Dependencies
```
PostgreSQL ← Backend (requires database)
MailHog ← Backend (requires email service)
Jenkins ← None (standalone CI/CD)
```

### Application Dependencies
```
Frontend ← Backend API
Backend ← PostgreSQL + MailHog
```

## Port Mapping

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| Frontend | 80 | 8081 | Web UI |
| Backend | 8080 | 8080 | API |
| PostgreSQL | 5432 | - | Database |
| MailHog | 1025/8025 | - | Email |
| Jenkins | 8080 | 8082 | CI/CD |

## File Structure

```
pets-devops/
├── ansible/                    # Infrastructure automation
│   ├── deploy-all.yml         # Main infrastructure playbook
│   └── tasks/                 # Ansible task files
├── k8s/                       # Kubernetes manifests
│   ├── postgres/              # Database infrastructure
│   ├── mailhog/               # Email infrastructure
│   ├── jenkins/               # CI/CD infrastructure
│   ├── backend/               # Backend application
│   └── frontend/              # Frontend application
├── Jenkinsfile                # Application deployment pipeline
├── Ask/                       # Backend source code
├── frontend/                  # Frontend source code
└── jenkins-dockerfile         # Jenkins container image
```

## Workflow

### Initial Setup
1. **Clone repository**
2. **Run infrastructure deployment**: `ansible-playbook ansible/deploy-all.yml --become`
3. **Access Jenkins**: `kubectl port-forward service/jenkins 8082:8080 -n devops-pets`
4. **Configure Jenkins pipeline** (pre-configured)

### Daily Development
1. **Make code changes** (frontend/backend)
2. **Push to Git**
3. **Jenkins automatically builds and deploys**
4. **Access applications**:
   - Frontend: http://localhost:8081
   - Backend: http://localhost:8080

### Infrastructure Changes
1. **Modify infrastructure manifests** (k8s/postgres, k8s/mailhog, k8s/jenkins)
2. **Run infrastructure deployment**: `ansible-playbook ansible/deploy-all.yml --become`
3. **Applications continue running** (no interruption)

## Benefits of This Architecture

### ✅ **Separation of Concerns**
- Infrastructure management separate from application deployment
- Different teams can work independently
- Clear responsibility boundaries

### ✅ **Stability**
- Infrastructure changes don't affect running applications
- Applications can be redeployed without infrastructure changes
- Rollback capabilities for each layer

### ✅ **Scalability**
- Easy to add new applications
- Infrastructure can be scaled independently
- Multiple environments possible

### ✅ **Maintainability**
- Clear documentation and structure
- Modular design
- Easy troubleshooting

## Troubleshooting

### Infrastructure Issues
```bash
# Check infrastructure status
kubectl get pods -n devops-pets -l app=postgres
kubectl get pods -n devops-pets -l app=mailhog
kubectl get pods -n devops-pets -l app=jenkins

# View infrastructure logs
kubectl logs -n devops-pets deployment/postgres
kubectl logs -n devops-pets deployment/mailhog
kubectl logs -n devops-pets deployment/jenkins
```

### Application Issues
```bash
# Check application status
kubectl get pods -n devops-pets -l app=backend
kubectl get pods -n devops-pets -l app=frontend

# View application logs
kubectl logs -n devops-pets deployment/backend
kubectl logs -n devops-pets deployment/frontend
```

### Common Commands
```bash
# Access services
kubectl port-forward service/frontend 8081:80 -n devops-pets
kubectl port-forward service/backend 8080:8080 -n devops-pets
kubectl port-forward service/jenkins 8082:8080 -n devops-pets

# Access Jenkins (no login required)
# Open http://localhost:8082 in your browser
```

## Next Steps

1. **Test the infrastructure deployment**
2. **Configure Jenkins pipeline**
3. **Deploy applications via Jenkins**
4. **Set up monitoring and logging**
5. **Implement automated testing**
6. **Add production deployment pipeline** 