pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        IMAGE_NAME = 'ttl.sh/myapp:2h'
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

        stage('Docker Build') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME} .
                    docker push ${IMAGE_NAME}
                """
            }
        }

        stage('Deploy to Docker VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'key_jenkins', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                        echo "Connecting to VM using SSH key..."
                        ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no laborant@${VM_IP} 'echo OK'

                        echo "Deploying Docker image..."
                        ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no laborant@${VM_IP} "
                            docker pull ${IMAGE_NAME} &&
                            docker stop myapp || true &&
                            docker rm myapp || true &&
                            docker run -d --name myapp -p 4444:4444 ${IMAGE_NAME}
                        "
                    '''
                }
            }
        }
    }
}
