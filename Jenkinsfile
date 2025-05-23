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
        stage('Deploy') {
            steps {
                sshagent(credentials: ['jenkins-key']) {
                    sh '''
                        mkdir -p ~/.ssh
                        ssh-keyscan -H target >> ~/.ssh/known_hosts
                        scp main laborant@target:~
                    '''
                }
            }
        }
    }
}
