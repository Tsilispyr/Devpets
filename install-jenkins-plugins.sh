#!/bin/bash

echo "🔧 Installing Jenkins plugins..."

# Create plugins directory if it doesn't exist
mkdir -p jenkins_home/plugins

# Download basic plugins
cd jenkins_home/plugins

# List of essential plugins
plugins=(
    "git:5.0.0"
    "workflow-aggregator:596.v8c21c963d92d"
    "kubernetes:1.11.3"
    "docker-workflow:1.28"
    "pipeline-stage-view:2.28"
    "blueocean:1.25.8"
    "credentials:1271.vd859a_199b_a_dc"
    "ssh-credentials:1.23"
    "plain-credentials:143.v1b_df4b_1c2c638"
    "structs:324.va_f5d6774f3a_d"
    "scm-api:676.v886669a_199a_a_"
    "git-client:4.11.0"
    "junit:1183.v1b_490d892b_8c"
    "mailer:456.vd8fa_2c2c638c"
    "matrix-project:785.v06b_7f47b_c631"
    "ant:485.vf34069fef73c"
    "maven-plugin:3.20"
    "gradle:1.39"
    "nodejs:1.5.1"
    "htmlpublisher:1.32"
)

echo "📥 Downloading plugins..."

for plugin in "${plugins[@]}"; do
    name=$(echo $plugin | cut -d: -f1)
    version=$(echo $plugin | cut -d: -f2)
    echo "Downloading $name:$version"
    
    # Download plugin
    curl -L -o "${name}.jpi" "https://updates.jenkins.io/download/plugins/${name}/${version}/${name}.hpi" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Downloaded $name"
    else
        echo "❌ Failed to download $name"
    fi
done

echo "✅ Plugin installation completed!"
echo "📁 Plugins installed in: $(pwd)"
ls -la *.jpi 2>/dev/null | wc -l | xargs echo "Total plugins:" 