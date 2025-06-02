pipeline {
    agent any

    environment {
        IMAGE_NAME = 'ttl.sh/myapp:2h'
        KUBECONFIG = 'kubeconfig.yaml'  // path inside workspace or provide as secret file
    }

    stages {
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
                    """
                }
            }
        }
    }
}
