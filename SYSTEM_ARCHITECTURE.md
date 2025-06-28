# DevOps Pets - Complete System Architecture

## System Overview

DevOps Pets is a comprehensive DevOps automation project that demonstrates modern CI/CD practices using containerization, orchestration, and automation tools. The system is designed to be completely self-contained and deployable with a single command.

### Key Components

- **Containerization**: Docker containers for all services
- **Orchestration**: Kubernetes (Kind) for local development
- **Automation**: Ansible for deployment automation
- **CI/CD**: Jenkins with pre-configured pipelines
- **Database**: PostgreSQL with persistent storage
- **Email Testing**: MailHog for development email testing
- **Frontend**: Vue.js 3 with modern UI
- **Backend**: Spring Boot with JWT authentication

## Deployment Architecture

### One-Command Deployment

The system supports multiple deployment methods:

1. **curl | bash**: Direct execution from GitHub
2. **Git clone**: Manual repository cloning
3. **ZIP extraction**: Fallback method for offline deployment

### Automated Process Flow

1. **System Detection**: Automatically detects OS and architecture
2. **Dependency Installation**: Installs missing tools only
3. **Repository Setup**: Clones or extracts project files
4. **Tool Verification**: Ensures all required tools are available
5. **Cluster Creation**: Sets up Kind Kubernetes cluster
6. **Resource Cleanup**: Removes old project resources
7. **Image Building**: Builds fresh Docker images
8. **Kubernetes Deployment**: Deploys all services
9. **Health Verification**: Waits for all services to be ready
10. **Port Forwarding**: Exposes services locally
11. **Success Display**: Shows access URLs and next steps

### Tool Management

The system intelligently manages tools:

- **Installs only missing tools**: Preserves existing installations
- **Proper permissions**: Sets correct ownership and permissions
- **Cross-platform compatibility**: Works on Linux, macOS, and Windows
- **Error handling**: Graceful failure and recovery
- **Version management**: Uses stable, tested versions

## Ansible Deployment Process

The Ansible playbook orchestrates the complete deployment:

### Prerequisites Check
- **Checks prerequisites**
- **Creates Kind cluster if needed**
- **Cleans project resources**
- **Builds Docker images**
- **Deploys to Kubernetes**
- **Verifies deployment**
- **Exposes services**

### Cluster Management
- **Checks if Kind cluster exists**
- **Creates new cluster if needed**
- **Uses `kind-config.yaml`**
- **Exports kubeconfig**

### Resource Cleanup
- **Stops old project containers**
- **Removes old project images**
- **Performs Docker system prune**
- **Builds new images from scratch**

### Deployment Process
- **Applies manifests in correct order**
- **Waits for each deployment to be ready**
- **Dynamic timeouts for each service**
- **Error handling at each step**
- **Stops if something fails**

## System Architecture

### Container Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Host System                              │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Kind Cluster  │  │   Docker        │  │   Jenkins   │ │
│  │   (Kubernetes)  │  │   Images        │  │   Home      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │ PostgreSQL  │  │   MailHog   │  │     Jenkins         │ │
│  │   (Pod)     │  │   (Pod)     │  │     (Pod)           │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Network Architecture

- **Internal Communication**: Kubernetes service mesh
- **External Access**: Port forwarding to localhost
- **Database Access**: Internal cluster networking
- **Email Testing**: MailHog web interface

### Storage Architecture

- **Persistent Volumes**: PostgreSQL data persistence
- **Jenkins Home**: Configuration and job persistence
- **Docker Images**: Local image registry
- **Temporary Storage**: Build artifacts and logs

## Jenkins Integration

The Jenkins server is pre-configured with:

- **Credentials**: Git and kubeconfig automatically configured
- **Job**: `backend-pipeline-devops-pets` ready to use
- **Security**: Unsecured mode (no login required)
- **Pipeline**: Complete CI/CD with Ansible integration
- **Tools**: All required tools installed in Jenkins container

### Jenkins Pipeline Features

- **Multi-stage pipeline**: Build, test, deploy
- **Ansible integration**: Automated infrastructure management
- **Docker support**: Containerized builds
- **Kubernetes deployment**: Direct cluster deployment
- **Health monitoring**: Service verification
- **Error handling**: Graceful failure recovery

## Advantages

### Complete Automation
- **Everything on the same server**
- **Simple management**
- **Less complexity**
- **Easy troubleshooting**

### One-Command Deployment
- **One-command deployment**
- **Automatic tool installation**
- **Dynamic health checks**
- **Error handling and recovery**
- **Cross-platform support**

### Clean Builds
- **Clean builds every time**
- **No stale data**
- **Consistent environment**
- **Reproducible deployments**

### Smart Tool Management
- **Installs only missing tools**
- **Preserves existing tools**
- **Proper permissions**
- **Cross-platform compatibility**

### Built-in Security
- **Built-in authentication system**
- **No external dependencies**
- **Secure token-based auth**
- **Role-based access control**

### Container Security
- **Isolated containers**
- **Network policies**
- **Resource limits**
- **Security contexts**

### Health Monitoring
- **Pod readiness probes**
- **Service health monitoring**
- **Automatic restart on failure**
- **Status reporting**

### Comprehensive Logging
- **Container logs**
- **Application logs**
- **System logs**
- **Error tracking**

## Network Architecture

### Service Communication

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Frontend  │────│   Backend   │────│ PostgreSQL  │
│   (Vue.js)  │    │ (Spring)    │    │  Database   │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       │                   │                   │
       ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Jenkins   │    │   MailHog   │    │   Kind      │
│   (CI/CD)   │    │ (Email)     │    │ (K8s)       │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Network Features
- **Kubernetes DNS**
- **Service mesh**
- **Load balancing**
- **Health checks**

### Port Configuration

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| Frontend | 8081 | 8081 | Web UI |
| Backend | 8080 | 8080 | API |
| Jenkins | 8080 | 8082 | CI/CD |
| MailHog | 8025 | 8025 | Email Testing |
| PostgreSQL | 5432 | - | Database |

### Security Features

- **Network isolation**: Services communicate only through defined interfaces
- **Port forwarding**: Controlled external access
- **Service accounts**: Limited permissions for each service
- **Resource limits**: Prevents resource exhaustion
- **Health checks**: Automatic failure detection

## Success Metrics

The deployment is considered successful when:

- **All services running**
- **Health checks passing**
- **Ports accessible**
- **Authentication working**
- **CI/CD pipeline ready**
- **Database persistent**
- **Email testing available**

## Conclusion

**DevOps Pets - Complete Automation Architecture!**

This system demonstrates modern DevOps practices with complete automation, containerization, and orchestration. The architecture is designed to be scalable, maintainable, and easy to deploy in any environment. 