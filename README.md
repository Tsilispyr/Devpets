# DevOps Pets - Complete Automated Deployment

## Project Overview

DevOps Pets is a comprehensive DevOps automation project that demonstrates a complete CI/CD pipeline using modern technologies. This project automatically deploys a full-stack application with PostgreSQL, MailHog, and Jenkins in a Kubernetes environment.

### Key Features

- **Detect your operating system** automatically
- **Install all required dependencies** (only if missing)
- **Clone the repository** or extract from zip if present
- **Verify project structure** and files
- **Deploy the complete application** with Ansible
- **Display access URLs** when finished
- **Handle all prompts automatically** (non-interactive mode)
- **Install missing tools automatically** (Docker, Kind, kubectl, Java, Node.js, etc.)

### One-Line Deployment

```bash
curl -fsSL https://raw.githubusercontent.com/Tsilispyr/Devpets/main/curl-deploy.sh | bash
```

### Manual Deployment

```bash
# Clone the repository
git clone https://github.com/Tsilispyr/Devpets.git
cd Devpets

# Run deployment
./deploy.sh
```

## System Requirements

- **Operating System**: Linux (Ubuntu/Debian), macOS, or Windows with WSL
- **Internet Connection**: Required for downloading dependencies
- **Administrator Privileges**: Required for installing system packages
- **Minimum RAM**: 4GB (8GB recommended)
- **Disk Space**: 10GB free space

## What Gets Deployed

### Backend Application
- **Technology**: Spring Boot (Java)
- **Database**: PostgreSQL
- **Authentication**: JWT-based
- **API**: RESTful endpoints
- **Port**: 8080 (internal)

### Frontend Application
- **Technology**: Vue.js 3
- **UI Framework**: Modern responsive design
- **Port**: 8081 (internal)

### Jenkins CI/CD
- **Version**: LTS
- **Plugins**: Pre-installed with essential plugins
- **Port**: 8082
- **Security**: Unsecured mode (no login required)

### MailHog
- **Purpose**: Email testing service
- **Port**: 8025
- **Features**: Web UI for email inspection

### PostgreSQL
- **Version**: 15
- **Database**: petdb
- **Username**: petuser
- **Port**: 5432 (internal)

## Access URLs

After successful deployment, you can access the services at:

- **MailHog Email Testing**: http://localhost:8025
- **Jenkins CI/CD**: http://localhost:8082
- **Frontend Application**: http://localhost:8081 (if exposed)
- **Backend API**: http://localhost:8080 (if exposed)

## System Architecture

The project uses a modern microservices architecture:

- **Containerization**: Docker containers for all services
- **Orchestration**: Kubernetes (Kind) for local development
- **Automation**: Ansible for deployment automation
- **CI/CD**: Jenkins with pre-configured pipelines
- **Database**: PostgreSQL with persistent storage
- **Email Testing**: MailHog for development email testing

## What Gets Installed Automatically

The deployment script automatically installs missing dependencies:

- **Docker & Docker Compose**
- **Kubernetes (Kind) & Kubectl**
- **Java (OpenJDK 17) & Maven 3.9.5**
- **Node.js 18 & npm**
- **Git, Python3, pip**

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Stop port forwarding
   pkill -f 'kubectl port-forward'
   
   # Kill processes using ports
   sudo lsof -ti:8025 | xargs kill -9
   sudo lsof -ti:8082 | xargs kill -9
   ```

2. **Docker Permission Issues**
   ```bash
   # Add user to docker group
   sudo usermod -aG docker $USER
   # Log out and back in
   ```

3. **Kubernetes Cluster Issues**
   ```bash
   # Delete and recreate cluster
   kind delete cluster --name devops-pets
   ./deploy.sh
   ```

### Useful Commands

```bash
# Check service status
./check-services.sh

# View logs
kubectl logs -n devops-pets

# Access Jenkins
kubectl port-forward svc/jenkins 8082:8080 -n devops-pets

# Access MailHog
kubectl port-forward svc/mailhog 8025:8025 -n devops-pets

# Clean up everything
kind delete cluster --name devops-pets
docker system prune -af
```

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



 
