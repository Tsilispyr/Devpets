#!/bin/bash

# Make this script executable
chmod +x "$0"

echo "Deploying Jenkins on host system for better tool access..."

# Stop ALL existing Jenkins containers
echo "Stopping all existing Jenkins containers..."
docker stop $(docker ps -q --filter "ancestor=jenkins/jenkins:lts") 2>/dev/null || true
docker rm $(docker ps -aq --filter "ancestor=jenkins/jenkins:lts") 2>/dev/null || true

# Get current directory for workspace mount
PROJECT_ROOT=$(pwd)
echo "Project root: $PROJECT_ROOT"

# Create jenkins_home directory if it doesn't exist
mkdir -p jenkins_home

# Set proper permissions for jenkins_home
sudo chown -R 1000:1000 jenkins_home 2>/dev/null || true
sudo chmod -R 755 jenkins_home 2>/dev/null || true

# Run Jenkins on host with all necessary mounts (same as start-jenkins-with-tools.sh)
docker run -d \
  --name jenkins-devops-pets \
  --restart unless-stopped \
  -p 8082:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PROJECT_ROOT/jenkins_home:/var/jenkins_home" \
  -v "$PROJECT_ROOT/kubeconfig:/root/.kube/config" \
  -v "$PROJECT_ROOT:/workspace" \
  -v /usr/local/bin:/usr/local/bin:ro \
  -v "$PROJECT_ROOT/jenkins-setup/init.groovy:/usr/share/jenkins/ref/init.groovy.d/init.groovy" \
  -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
  --user 1000:1000 \
  jenkins/jenkins:lts

echo "Jenkins deployed on host system!"
echo "Access Jenkins at: http://localhost:8082"
echo "Jenkins data persisted in: $PROJECT_ROOT/jenkins_home"
echo "Init script mounted: $PROJECT_ROOT/jenkins-setup/init.groovy" 