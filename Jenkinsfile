pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        IMAGE_NAME = 'ttl.sh/myapp:1h'
        VM_IP = '172.16.0.4'
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

        stage('Docker Build and Push') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME} .
                    docker push ${IMAGE_NAME}
                """
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${VM_IP} '
                            docker pull ${IMAGE_NAME} &&
                            docker stop myapp || true &&
                            docker rm myapp || true &&
                            docker run -d -p 4444:4444 --name myapp ${IMAGE_NAME}
                        '
                    """
                }
            }
        }
        
    }
}
