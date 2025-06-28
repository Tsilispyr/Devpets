# Jenkins Setup Guide - DevOps Pets Project

## Overview
This guide covers the manual setup of Jenkins for the DevOps Pets project using the persistent jenkins_home approach.

## Current Status
✅ Jenkins container running on port 8082  
✅ Authentication disabled  
✅ CSRF protection disabled  
✅ 79 plugins installed  
✅ Host tools mounted (docker, kubectl, git, maven, node, etc.)

## Access Jenkins
- **URL**: http://localhost:8082
- **Authentication**: None required
- **Port**: 8082

## Manual Setup Steps

### 1. Configure Tools
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

### 2. Configure Credentials
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

### 3. Create Pipeline Job
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

### 4. Configure Email (Optional)
Go to **Manage Jenkins → Configure System**

#### Extended E-mail Notification
- **SMTP server**: smtp.gmail.com
- **SMTP Port**: 587
- **Use SSL**: ✅
- **Use TLS**: ✅
- **Username**: your-email@gmail.com
- **Password**: your-app-password

## Jenkinsfile Structure
The pipeline should include:
1. **Checkout** code from GitHub
2. **Build** backend with Maven
3. **Build** frontend with Node.js
4. **Test** applications
5. **Build** Docker images
6. **Deploy** to Kubernetes

## Persistent Storage
All configurations are stored in:
- **Host**: `pets-devops/jenkins_home/`
- **Container**: `/var/jenkins_home/`

### Important Folders
- `jenkins_home/jobs/` - Job configurations
- `jenkins_home/plugins/` - Installed plugins
- `jenkins_home/users/` - User configurations
- `jenkins_home/workspace/` - Build workspaces

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

## Next Steps
1. Configure tools in Jenkins UI
2. Set up credentials
3. Create pipeline job
4. Test the pipeline
5. Configure email notifications (optional)

## Benefits of This Approach
- ✅ **Persistent**: All configurations saved in jenkins_home
- ✅ **Portable**: Can be backed up and restored
- ✅ **Flexible**: Easy to customize per developer
- ✅ **Reliable**: No dependency on external automation
- ✅ **Scalable**: Each developer has their own environment 