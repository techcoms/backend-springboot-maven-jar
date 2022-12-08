pipeline{
    agent any
    environments {
        DOCKERHUB_REPO = "techcoms/backend-springboot-maven-jar"
    }
    tools{
        maven "maven-3.8.6"
    }
    stages{
        stage("git checkout"){
            steps{
                git credentialsId: 'github-creds', url: 'https://github.com/techcoms/backend-springboot-maven-jar.git'
            }
        }
        stage("build artifacts with maven"){
            steps{
                sh "mvn clean package"
            }
        }
        stage("build docker image"){
            steps {
                sh "docker build -t ${DOCKERHUB_REPO}:${BUILD_NUMBER} ."
            }
        }
        stage("login to dockerhub and push image"){
            steps { 
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) { 
                    sh "docker login -u $USERNAME -p $PASSWORD "
                    sh "docker push ${DOCKERHUB_REPO}:${BUILD_NUMBER}"
  
                      }
                  }
             }     
    }
}
