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
        sh '''
            mkdir -p ~/.ssh
            ssh-keyscan -H target >> ~/.ssh/known_hosts
            scp -i ~/.ssh/jenkins main laborant@target:~
        '''
    }
}

    }
}
