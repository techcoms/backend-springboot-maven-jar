pipeline {
    agent any
    
    environment {
        // Application settings
        APP_NAME          = 'my-java-app'
        WAR_FILE          = 'target/*.war'

        // Docker settings
        DOCKER_IMAGE      = "${APP_NAME}:${BUILD_NUMBER}"
        CONTAINER_NAME    = "test-container-${BUILD_NUMBER}"
        HOST_PORT         = '8081'
        CONTAINER_PORT    = '8080'

        // SonarQube setting
        SONAR_HOST_URL    = 'http://13.126.141.57:9000'

        // Production Tomcat settings - YOUR PROVIDED SERVER
        TOMCAT_HOST       = '13.126.141.57'
        TOMCAT_PORT       = '8081'                                 // For display URL
        TOMCAT_USER       = 'tomcat'                                // Update if your SSH user is different
        TOMCAT_WEBAPPS    = '/opt/tomcat/webapps'                  // Common path; adjust if needed
        TOMCAT_SSH_CRED   = 'tomcat-prod-ssh'                      // Jenkins SSH credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "feature", url: "https://github.com/techcoms/backend-springboot-maven-jar.git"
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn clean test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                          -Dsonar.projectKey=spring-boot-demo \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.login=\${SONAR_AUTH_TOKEN}
                    """
                }
            }
        }
        
        stage('Package WAR') {
            steps {
                sh 'mvn package -DskipTests'
                archiveArtifacts artifacts: 'target/*.war', fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}")
                }
            }
        }

        stage('Test Docker Container') {
            steps {
                script {
                    try {
                        sh """
                            docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}
                        """

                        timeout(time: 3, unit: 'MINUTES') {
                            waitUntil {
                                script {
                                    def response = sh(
                                        script: "curl -s -o /dev/null -w '%{http_code}' http://13.126.141.57:${HOST_PORT}/",
                                        returnStdout: true
                                    ).trim()
                                    return response == '200'
                                }
                            }
                        }

                        echo "Docker container started and application is responding!"
                    } finally {
                        sh "docker stop ${CONTAINER_NAME} || true"
                        sh "docker rm ${CONTAINER_NAME} || true"
                    }
                }
            }
        }

        stage('Deploy Review App') {
            when {
                not { branch 'main' }
            }
            steps {
                echo "=== Review App for branch: ${env.BRANCH_NAME} ==="
                echo "Preview would be available at a temporary URL if configured"
            }
        }

        stage('Manual Approval for Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    echo "=================================================================="
                    echo "Review before approving production deployment:"
                    echo "• SonarQube Report: ${SONAR_HOST_URL}/dashboard?id=${SONAR_PROJECT_KEY}"
                    echo "• Docker Image Built: ${DOCKER_IMAGE}"
                    echo "• Production URL after deploy: http://${TOMCAT_HOST}:${TOMCAT_PORT}/"
                    echo "=================================================================="
                }
                input message: 'Deploy this build to Production Tomcat server?',
                      ok: 'Deploy to Production'
            }
        }

        stage('Deploy to Production Tomcat') {
            when {
                branch 'main'
            }
            steps {
                sshagent(credentials: [TOMCAT_SSH_CRED]) {
                    sh """
                        echo "Copying WAR file to production Tomcat..."
                        scp -o StrictHostKeyChecking=no ${WAR_FILE} ${TOMCAT_USER}@${TOMCAT_HOST}:${TOMCAT_WEBAPPS}/ROOT.war

                        echo "Optional: Restarting Tomcat to apply new deployment..."
                        ssh -o StrictHostKeyChecking=no ${TOMCAT_USER}@${TOMCAT_HOST} '
                            sudo systemctl restart tomcat || echo "Auto-deploy in progress..."
                        '
                    """
                    echo "=================================================================="
                    echo "Deployment successful!"
                    echo "Your application is now live at:"
                    echo "http://${TOMCAT_HOST}:${TOMCAT_PORT}/"
                    echo "=================================================================="
                }
            }
        }
    }

    post {
        always {
            cleanWs(deleteDirs: true)
            sh 'docker rmi ${DOCKER_IMAGE} || true'
        }
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed - please check the logs.'
        }
    }
}
