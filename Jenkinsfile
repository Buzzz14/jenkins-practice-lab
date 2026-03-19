pipeline { 

  

    agent any 

  

    environment { 

        IMAGE_NAME = "buzzz14/jenkins-practice-lab" 

        IMAGE_TAG = "${BUILD_NUMBER}" 

    } 

  

    stages { 

  

        stage('Build') { 

            steps { 

                echo "Building application..." 

            } 

        } 

  

        stage('Parallel Tests') { 

            parallel { 

  

                stage('Unit Tests') { 

                    steps { 

                        sh 'bash unit-test.sh' 

                    } 

                } 

  

                stage('Integration Tests') { 

                    steps { 

                        sh 'bash integration-test.sh' 

                    } 

                } 

  

                stage('Security Scan') { 

                    steps { 

                        sh 'bash security-test.sh' 

                    } 

                } 

  

            } 

        } 

  

        stage('Build Docker Image') { 

            steps { 

                sh ''' 

                echo "Building Docker image..." 

                docker build -t $IMAGE_NAME:$IMAGE_TAG . 

                docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest 

                ''' 

            } 

        } 

  

        stage('Push Image to Docker Hub') { 

            steps { 

                withCredentials([usernamePassword( 

                    credentialsId: 'dockerhub-creds', 

                    usernameVariable: 'DOCKER_USER', 

                    passwordVariable: 'DOCKER_PASS' 

                )]) { 

                    sh ''' 

                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin 

                    docker push $IMAGE_NAME:$IMAGE_TAG 

                    docker push $IMAGE_NAME:latest 

                    ''' 

                } 

            } 

        } 

  

        stage('Deploy to Kubernetes') { 

            steps { 

                withCredentials([file( 

                    credentialsId: 'kubeconfig', 

                    variable: 'KUBECONFIG_FILE' 

                )]) { 

                    sh ''' 

                    echo "Setting kubeconfig..." 

                    export KUBECONFIG=$KUBECONFIG_FILE 

  

                    echo "Checking cluster..." 

                    kubectl get nodes 

  

                    echo "Deploying..." 

                    kubectl set image deployment/jenkins-app \ 

                    jenkins-app=$IMAGE_NAME:$IMAGE_TAG 

  

                    kubectl rollout status deployment/jenkins-app --timeout=60s 

                    ''' 

                } 

            } 

        } 

    } 

} 
