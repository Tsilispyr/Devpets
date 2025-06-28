# Jenkins Clean Setup Guide - DevOps Pets Project

## Overview
This guide covers the standard Jenkins setup for the DevOps Pets project with manual configuration.

## Current Status
✅ Jenkins container ready to start  
✅ Host tools mounted (docker, kubectl, git, maven, node, etc.)  
✅ Clean jenkins_home directory  
✅ No automation scripts  

## Start Jenkins

```bash
cd pets-devops && ./start-jenkins-with-tools.sh
```

## Access Jenkins
- **URL**: http://localhost:8082
- **Initial Setup**: Required (standard Jenkins setup wizard)
- **Port**: 8082

## Get Initial Admin Password

```bash
docker exec jenkins-devops-pets cat /var/jenkins_home/secrets/initialAdminPassword
```

## Manual Setup Steps

### 1. Complete Setup Wizard
1. Go to http://localhost:8082
2. Enter the initial admin password
3. Choose "Install suggested plugins" or "Select plugins to install"
4. Create admin user
5. Set Jenkins URL (http://localhost:8082)
6. Start using Jenkins

### 2. Install Required Plugins
Go to **Manage Jenkins → Manage Plugins → Available**

Install these plugins:
- **Git** - for GitHub integration
- **Pipeline** - for Jenkinsfiles
- **Workflow Aggregator** - for advanced pipelines
- **Maven Integration** - for Java builds
- **NodeJS** - for frontend builds
- **Docker Pipeline** - for Docker operations
- **Kubernetes** - for K8s deployments
- **Credentials Binding** - for secrets management
- **SSH Agent** - for SSH connections
- **Email Extension** - for email notifications

### 3. Configure Tools
Go to **Manage Jenkins → Global Tool Configuration**

#### Maven Configuration
- **Name**: Maven 3.9.5
- **MAVEN_HOME**: `/usr/bin/mvn` (host mounted)
- **Install automatically**: ❌ (using host tools)

#### Node.js Configuration  
- **Name**: Node.js 18
- **Install automatically**: ❌ (using host tools)
- **Path**: `/usr/bin/node` (host mounted)

#### Git Configuration
- **Name**: Git
- **Path to Git executable**: `/usr/bin/git` (host mounted)

### 4. Configure Credentials
Go to **Manage Jenkins → Manage Credentials → System → Global credentials**

#### Docker Registry (if needed)
- **Kind**: Username with password
- **Scope**: Global
- **Username**: your-docker-username
- **Password**: your-docker-password
- **ID**: docker-registry

#### GitHub (if needed)
- **Kind**: Username with password or SSH
- **Scope**: Global
- **ID**: github-credentials

### 5. Create Pipeline Job
Go to **New Item**

#### Job Configuration
- **Name**: devops-pets-pipeline
- **Type**: Pipeline
- **Description**: DevOps Pets Application Pipeline

#### Pipeline Configuration
- **Definition**: Pipeline script from SCM
- **SCM**: Git
- **Repository URL**: https://github.com/Tsilispyr/Devpets
- **Branch**: */main
- **Script Path**: Jenkinsfile

### 6. Configure Email (Optional)
Go to **Manage Jenkins → Configure System**

#### Extended E-mail Notification
- **SMTP server**: smtp.gmail.com
- **SMTP Port**: 587
- **Use SSL**: ✅
- **Use TLS**: ✅
- **Username**: your-email@gmail.com
- **Password**: your-app-password

## Available Host Tools
The following tools are mounted from host:
- **Docker**: `/usr/bin/docker`
- **Kubectl**: `/usr/bin/kubectl`
- **Kind**: `/usr/bin/kind`
- **Git**: `/usr/bin/git`
- **Java**: `/usr/bin/java`
- **Maven**: `/usr/bin/mvn`
- **Node.js**: `/usr/bin/node`
- **NPM**: `/usr/bin/npm`
- **Python3**: `/usr/bin/python3`
- **Pip3**: `/usr/bin/pip3`

## Persistent Storage
All configurations are stored in:
- **Host**: `pets-devops/jenkins_home/`
- **Container**: `/var/jenkins_home/`

### Important Folders
- `jenkins_home/jobs/` - Job configurations
- `jenkins_home/plugins/` - Installed plugins
- `jenkins_home/users/` - User configurations
- `jenkins_home/workspace/` - Build workspaces

## Troubleshooting

### Jenkins Not Accessible
```bash
# Check container status
docker ps | grep jenkins

# Check logs
docker logs jenkins-devops-pets

# Restart if needed
docker restart jenkins-devops-pets
```

### Tools Not Found
- Verify tools are mounted in start script
- Check host tool installations
- Restart Jenkins container

### Plugin Issues
- Go to **Manage Jenkins → Manage Plugins**
- Check for updates
- Restart Jenkins if needed

## Benefits of This Approach
- ✅ **Standard**: Uses official Jenkins setup wizard
- ✅ **Clean**: No automation scripts or custom configurations
- ✅ **Persistent**: All configurations saved in jenkins_home
- ✅ **Flexible**: Easy to customize per developer
- ✅ **Reliable**: Standard Jenkins behavior
- ✅ **Maintainable**: No custom code to maintain 