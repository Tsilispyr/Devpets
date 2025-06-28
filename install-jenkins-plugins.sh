#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
NC='\033[0m' # No Color

echo "Installing Jenkins plugins..."

# Create plugins directory if it doesn't exist
mkdir -p jenkins_home/plugins

# List of plugins to install
plugins=(
    "git"
    "pipeline"
    "workflow-aggregator"
    "kubernetes"
    "docker-plugin"
    "email-ext"
    "slack"
    "htmlpublisher"
    "junit"
    "maven-plugin"
    "gradle"
    "nodejs"
    "ssh-slaves"
    "credentials"
    "plain-credentials"
    "ssh-credentials"
    "git-client"
    "git-server"
    "scm-api"
    "script-security"
    "structs"
    "workflow-api"
    "workflow-basic-steps"
    "workflow-cps"
    "workflow-durable-task-step"
    "workflow-job"
    "workflow-multibranch"
    "workflow-scm-step"
    "workflow-step-api"
    "workflow-support"
    "pipeline-build-step"
    "pipeline-input-step"
    "pipeline-milestone-step"
    "pipeline-model-api"
    "pipeline-model-definition"
    "pipeline-model-extensions"
    "pipeline-stage-step"
    "pipeline-stage-tags-metadata"
    "pipeline-stage-view"
    "workflow-aggregator"
    "matrix-project"
    "jquery3-api"
    "font-awesome-api"
    "ionicons-api"
    "jackson2-api"
    "jakarta-activation-api"
    "jakarta-mail-api"
    "javax-activation-api"
    "javax-mail-api"
    "jaxb"
    "joda-time-api"
    "json-api"
    "json-path-api"
    "jsoup"
    "junit"
    "kubernetes-client-api"
    "kubernetes-credentials"
    "mailer"
    "metrics"
    "mina-sshd-api-common"
    "mina-sshd-api-core"
    "nodejs"
    "okhttp-api"
    "oss-symbols-api"
    "pipeline-groovy-lib"
    "plugin-util-api"
    "snakeyaml-api"
    "token-macro"
    "trilead-api"
    "variant"
)

# Download each plugin
for plugin in "${plugins[@]}"; do
    name="$plugin.jpi"
    url="https://updates.jenkins.io/latest/$name"
    
    echo "Downloading $name..."
    if curl -L -o "jenkins_home/plugins/$name" "$url"; then
        echo -e "${BOLD_GREEN}OK! Downloaded $name${NC}"
    else
        echo -e "${BOLD_RED}ERR! Failed to download $name${NC}"
    fi
done

echo -e "${BOLD_GREEN}OK! Plugin installation completed!${NC}"
echo "Plugins installed in: $(pwd)" 