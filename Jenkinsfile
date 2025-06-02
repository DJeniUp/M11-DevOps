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
                kubernetesDeploy(configs: 'k8s/myapp.yaml', kubeconfigId: 'k8s-token')
            }
        }
    }
}
