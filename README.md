# DevOps Pets Project

A complete DevOps infrastructure with Jenkins, PostgreSQL, and MailHog using Kubernetes (Kind) and Ansible.

## 🚀 Quick Start

### Option 1: Direct from GitHub (Recommended)
```bash
# Download and run directly from GitHub
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/deploy.yml | ansible-playbook -i localhost, -c local -
```

### Option 2: Local Deployment
```bash
# Clone and run locally
git clone https://github.com/Tsilispyr/Devpets.git
cd Devpets
ansible-playbook deploy.yml
```

## 📋 What Gets Deployed

### Infrastructure Services
- **Jenkins**: CI/CD server (http://localhost:8082)
- **PostgreSQL**: Database server (running in cluster)
- **MailHog**: Email testing tool (http://localhost:8025)

### Applications (if present)
- **Frontend**: Vue.js application (http://localhost:8081)
- **Backend**: Spring Boot application (http://localhost:8080)

## 🔧 Prerequisites

The playbook will automatically install:
- Docker
- Kind (Kubernetes in Docker)
- Kubectl
- Ansible

## 📁 Project Structure

```
pets-devops/
├── deploy.yml                 # Main deployment playbook
├── ansible/
│   ├── deploy-all.yml        # Infrastructure deployment
│   ├── deploy-applications.yml # Applications deployment
│   └── tasks/                # Tool installation tasks
├── k8s/                      # Kubernetes manifests
│   ├── jenkins/
│   ├── postgres/
│   └── mailhog/
├── frontend/                 # Vue.js application (optional)
├── backend/                  # Spring Boot application (optional)
└── jenkins_home/            # Jenkins persistent data
```

## 🛠️ Useful Commands

```bash
# Check all services
kubectl get all -n devops-pets

# View logs
kubectl logs -n devops-pets <pod-name>

# Stop port forwarding
pkill -f 'kubectl port-forward'

# Clean up everything
kind delete cluster --name devops-pets
```

## 🔄 Deployment Process

1. **Tools Installation**: Automatically installs Docker, Kind, Kubectl
2. **Cleanup**: Removes existing resources (preserves jenkins_home)
3. **Cluster Creation**: Creates fresh Kind cluster
4. **Image Building**: Builds custom Docker images
5. **Deployment**: Applies Kubernetes manifests
6. **Verification**: Waits for all pods to be ready
7. **Port Forwarding**: Sets up access to services

## 📝 Notes

- Jenkins home directory is preserved between deployments
- All services run in the same namespace (`devops-pets`)
- Port forwarding runs in background
- Applications are deployed only if present in the repository

## 🆘 Troubleshooting

If deployment fails:
1. Check if Docker is running
2. Ensure ports 8082, 8025 are available
3. Run `kubectl get pods -n devops-pets` to check pod status
4. Check logs with `kubectl logs -n devops-pets <pod-name>`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Check the troubleshooting section
- Review the logs for error messages



 
