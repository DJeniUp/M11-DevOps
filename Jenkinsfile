pipeline {
    agent any

    tools {
       go "1.24.1"
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
                sh '''
                docker build -t ttl.sh/myapp:2h .
                docker push ttl.sh/myapp:2h
                '''
            }
        }
        stage('Deploy to Docker VM') {
            steps {
                sshagent(credentials: ['jenkins-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no laborant@target << 'EOF'
                      docker pull ttl.sh/myapp:2h
                      docker rm -f myapp || true
                      docker run -d -p 4444:4444 --name myapp ttl.sh/myapp:2h
                    EOF
                    '''
                }
            }
        }
    }
}
