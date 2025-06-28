pipeline {
    agent any
    
    environment {
        PROJECT_ROOT = '/workspace'
        KUBECONFIG = '/root/.kube/config'
        DOCKER_SOCKET = '/var/run/docker.sock'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '=== Checking out code from GitHub ==='
                checkout scm
            }
        }
        
        stage('Build Backend') {
            steps {
                echo '=== Building Backend Application ==='
                dir('Ask') {
                    sh '''
                        echo "Building Java backend..."
                        mvn clean package -DskipTests
                        echo "Backend build completed!"
                    '''
                }
            }
        }
        
        stage('Build Frontend') {
            steps {
                echo '=== Building Frontend Application ==='
                dir('frontend') {
                    sh '''
                        echo "Installing frontend dependencies..."
                        npm install
                        echo "Building frontend..."
                        npm run build
                        echo "Frontend build completed!"
                    '''
                }
            }
        }
        
        stage('Create Docker Images') {
            steps {
                echo '=== Creating Docker Images ==='
                sh '''
                    echo "Building backend Docker image..."
                    docker build -t devops-pets-backend:latest Ask/
                    
                    echo "Building frontend Docker image..."
                    docker build -t devops-pets-frontend:latest frontend/
                    
                    echo "Docker images created successfully!"
                '''
            }
        }
        
        stage('Deploy to Kind Cluster') {
            steps {
                echo '=== Deploying to Kind Cluster ==='
                sh '''
                    echo "Checking Kind cluster status..."
                    kind get clusters
                    
                    echo "Setting kubectl context..."
                    kubectl config use-context kind-devops-pets
                    
                    echo "Deploying backend..."
                    kubectl apply -f k8s/backend/backend-deployment.yaml -n devops-pets
                    kubectl apply -f k8s/backend/backend-service.yaml -n devops-pets
                    
                    echo "Deploying frontend..."
                    kubectl apply -f k8s/frontend/frontend-deployment.yaml -n devops-pets
                    kubectl apply -f k8s/frontend/frontend-service.yaml -n devops-pets
                    
                    echo "Waiting for deployments to be ready..."
                    kubectl wait --for=condition=available --timeout=300s deployment/backend -n devops-pets
                    kubectl wait --for=condition=available --timeout=300s deployment/frontend -n devops-pets
                    
                    echo "Deployment completed successfully!"
                '''
            }
        }
        
        stage('Verify Deployment') {
            steps {
                echo '=== Verifying Deployment ==='
                sh '''
                    echo "Checking pod status..."
                    kubectl get pods -n devops-pets
                    
                    echo "Checking services..."
                    kubectl get services -n devops-pets
                    
                    echo "Checking backend logs..."
                    kubectl logs -l app=backend -n devops-pets --tail=20
                    
                    echo "Checking frontend logs..."
                    kubectl logs -l app=frontend -n devops-pets --tail=20
                    
                    echo "Deployment verification completed!"
                '''
            }
        }
    }
    
    post {
        success {
            echo '=== Pipeline Completed Successfully! ==='
            echo 'Backend: http://localhost:8080 (via port-forward)'
            echo 'Frontend: http://localhost:8081 (via port-forward)'
            echo 'MailHog: http://localhost:8025'
            echo 'Jenkins: http://localhost:8082'
        }
        failure {
            echo '=== Pipeline Failed! ==='
            echo 'Check the logs above for errors.'
        }
        always {
            echo '=== Pipeline Finished ==='
        }
    }
}
