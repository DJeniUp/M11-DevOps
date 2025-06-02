pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        IMAGE_NAME = 'ttl.sh/myapp:2h'
    }

    stages {
        stage('Test') {
            steps {
                sh "go test ./..."
            }
        }

        stage('Build') {
            steps {
                sh 'go build -o main main.go'
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME} .
                    docker push ${IMAGE_NAME}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: 'k8s-token', variable: 'KUBE_TOKEN')]) {
                    sh '''
                    export KUBECONFIG=kubeconfig.yaml
                    kubectl config set-cluster my-cluster --server=https://<K8S-API-SERVER> --insecure-skip-tls-verify=true
                    kubectl config set-credentials jenkins-user --token=$KUBE_TOKEN
                    kubectl config set-context default --cluster=my-cluster --user=jenkins-user
                    kubectl config use-context default
                    kubectl apply -f definition.yaml
                    '''
                }
            }
        }
    }
}
