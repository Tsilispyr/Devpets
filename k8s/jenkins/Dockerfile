FROM jenkins/jenkins:lts

USER root

# Install essential packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    zip \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Java (if not already present)
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Maven
RUN wget https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz \
    && tar -xzf apache-maven-3.9.6-bin.tar.gz \
    && mv apache-maven-3.9.6 /opt/maven \
    && rm apache-maven-3.9.6-bin.tar.gz

# Set environment variables
ENV MAVEN_HOME=/opt/maven
ENV PATH=$PATH:$MAVEN_HOME/bin
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Verify installations
RUN git --version \
    && node --version \
    && npm --version \
    && java -version \
    && mvn --version

# Grant Jenkins access to Docker socket
# Create a docker group with the same GID as the host's docker.sock
# and add the jenkins user to it.
RUN DOCKER_SOCKET_GID=$(stat -c '%g' /var/run/docker.sock) && \
    groupadd -g $DOCKER_SOCKET_GID docker || true && \
    usermod -aG docker jenkins

RUN git config --global --add safe.directory '*'
RUN curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Switch back to jenkins user
USER jenkins
