# Ansible Deployment for DevOps Pets

This directory contains Ansible playbooks for deploying the DevOps Pets application to Kubernetes.

## Prerequisites

The following tools must be installed on your system:

- **Docker** - Container runtime
- **Kind** - Kubernetes in Docker
- **Kubectl** - Kubernetes command line tool
- **Java** - Java Runtime Environment
- **Node.js** - Node.js runtime
- **npm** - Node Package Manager
- **Git** - Version control
- **Python 3** - Python interpreter
- **pip** - Python package manager
- **Maven** - Build tool
- **Docker Compose** - Multi-container Docker applications

## Installation

### Install Ansible Collections
```bash
ansible-galaxy collection install -r requirements.yml
```

## Usage

### 1. Check Prerequisites Only (No Installation)
```bash
cd ansible
ansible-playbook -i inventory.ini check-only.yml
```

This will check if all required tools are available without installing anything.

### 2. Setup System (Check + Install Missing Tools)
```bash
cd ansible
ansible-playbook -i inventory.ini setup-system.yml
```

This will:
1. Check all prerequisites
2. Install any missing tools automatically
3. Set proper permissions and configurations
4. Verify all installations

### 3. Full Deployment with Auto-Installation
```bash
cd ansible
ansible-playbook -i inventory.ini deploy-all.yml
```

This will:
1. Check and install all prerequisites
2. Build Docker images
3. Load images into Kind
4. Deploy all Kubernetes manifests
5. Wait for deployments to be ready

### 4. Manual Deployment (Backend Only)
```bash
cd ansible
ansible-playbook -i inventory.ini deploy.yml
```

## Playbooks

- **check-only.yml**: Checks if all required tools are available (no installation)
- **setup-system.yml**: Checks and installs all missing tools
- **install-prerequisites.yml**: Installation logic (imported by other playbooks)
- **deploy-all.yml**: Complete deployment including prerequisites installation
- **deploy.yml**: Deploys only the backend application to Kubernetes
- **tasks/prerequisites.yml**: Legacy installation (not used by default)

## Installation Details

### What Gets Installed

#### Docker
- Official Docker CE repository
- Docker service enabled and started
- User added to docker group
- Proper socket permissions

#### Kind & Kubectl
- Downloaded to `/usr/local/bin/`
- Executable permissions (755)
- Root ownership

#### Java
- OpenJDK 17
- JAVA_HOME environment variable set
- Added to user's bashrc

#### Node.js & npm
- NodeSource repository (v18.x)
- Latest stable versions

#### Other Tools
- Git, Python 3, pip, Maven via apt
- Docker Compose binary download

### Permissions & Security
- All binaries installed to `/usr/local/bin/`
- Proper ownership (root:root)
- Executable permissions (755)
- Docker socket permissions (666)
- User added to docker group

## Prerequisites Check Output

The prerequisites check will display:
- Status of each tool (✓ AVAILABLE or ✗ MISSING)
- Version information for available tools
- Summary of missing tools
- Clear instructions if tools are missing

Example output:
```
========================================
SYSTEM SETUP SUMMARY
========================================
Total tools checked: 12
Available tools: 8
Tools to install: 4

TOOLS TO INSTALL:
- Node.js (Node.js runtime)
- npm (Node Package Manager)
- Maven (Build tool)
- Docker Compose (Docker Compose)

Starting installation...
========================================
```

## Troubleshooting

1. **Permission errors**: Run with `--ask-become-pass` if sudo password is required
2. **Network issues**: Ensure internet connectivity for downloads
3. **Repository errors**: Check if system is Ubuntu/Debian based
4. **Service failures**: Check systemd status for Docker service
5. **Path issues**: Ensure `/usr/local/bin` is in PATH

## System Requirements

- Ubuntu/Debian based system
- Internet connectivity
- Sudo privileges
- At least 2GB RAM
- 10GB free disk space 