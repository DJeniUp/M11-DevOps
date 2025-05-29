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
                sshagent(credentials: ['key-jenkins']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no laborant@target '
                            docker pull ttl.sh/myapp:2h &&
                            docker stop myapp || true &&
                            docker rm myapp || true &&
                            docker run -d --name myapp -p 4444:4444 ttl.sh/myapp:2h
                        '
                    '''
                }
            }
        }
    }
}
