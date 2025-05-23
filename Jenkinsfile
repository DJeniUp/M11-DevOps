pipeline {
    agent any

    tools {
        go "1.24.1"
    }

    environment {
        TARGET_HOST = "target"
        TARGET_USER = "laborant"
        TARGET_KEY = "~/.ssh/jenkins"
    }

    stages {
        stage('Test') {
            steps {
                sh 'go test ./...'
            }
        }

        stage('Build') {
            steps {
                sh 'go build -o main main.go'
                sh 'ls -l' // перевіримо, що main створився
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['jenkins-key']) {
                    sh '''
                        mkdir -p ~/.ssh
                        ssh-keyscan -H $TARGET_HOST >> ~/.ssh/known_hosts
                        scp -o StrictHostKeyChecking=no main $TARGET_USER@$TARGET_HOST:~
                    '''
                }
            }
        }

        stage('Run Artifact') {
            steps {
                sshagent(credentials: ['jenkins-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $TARGET_USER@$TARGET_HOST 'chmod +x ~/main && ~/main > ~/main_output.txt 2>&1 &'
                    '''
                }
            }
        }
    }
}
