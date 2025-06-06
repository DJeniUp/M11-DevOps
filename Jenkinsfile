pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        IMAGE_NAME = 'myapp:latest'
        EC2_USER = 'ec2-user'
        EC2_IP = '13.60.182.222' 
        SSH_KEY = 'ec2-ssh-key'  
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
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Save Docker Image to tar') {
            steps {
                sh "docker save ${IMAGE_NAME} -o myapp.tar"
            }
        }

        stage('Copy image to EC2') {
            steps {
                sh "scp -o StrictHostKeyChecking=no -i ${SSH_KEY} myapp.tar ${EC2_USER}@${EC2_IP}:/home/${EC2_USER}/"
            }
        }

        stage('Load image and run container on EC2') {
            steps {
                sh """
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${EC2_USER}@${EC2_IP} '
                    docker load -i /home/${EC2_USER}/myapp.tar &&
                    docker stop myapp || true &&
                    docker rm myapp || true &&
                    docker run -d -p 4444:4444 --name myapp ${IMAGE_NAME}
                '
                """
            }
        }
    }
}
