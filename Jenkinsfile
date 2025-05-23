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
                withCredentials([sshUserPrivateKey(credentialsId: 'key-jenkins',
                                                   keyFileVariable: 'ssh_key',
                                                   usernameVariable: 'ssh_user')]) {
                    sh """

                    chmod +x main
                    
                    mkdir -p ~/.ssh
                    ssh-keyscan target >> ~/.ssh/known_hosts
                    scp -i ${ssh_key} main ${ssh_user}@target:

                    """
                    
                }
            }
        }
    }
}
