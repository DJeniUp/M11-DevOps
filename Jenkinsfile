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

        stage('Docker Build and Push') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME} .
                    docker push ${IMAGE_NAME}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Inject token from Jenkins credentials, write kubeconfig.yaml
                withCredentials([string(credentialsId: 'k8s-token', variable: 'KUBE_TOKEN')]) {
                    sh """
                    cat > kubeconfig.yaml <<EOF
                    apiVersion: v1
                    kind: Config
                    clusters:
                    - cluster:
                        insecure-skip-tls-verify: true
                        server: https://k8s:6443
                      name: my-cluster
                    contexts:
                    - context:
                        cluster: my-cluster
                        user: jenkins-robot
                      name: default
                    current-context: default
                    users:
                    - name: jenkins-robot
                      user:
                        token: ${KUBE_TOKEN}
                    EOF

                    kubectl --kubeconfig=kubeconfig.yaml apply -f definition.yaml
                    kubectl run
                    """
                }
            }
        }
    }
}
