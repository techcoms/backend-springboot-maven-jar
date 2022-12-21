pipeline{ 
      options {
    buildDiscarder(logRotator(numToKeepStr: '2', artifactNumToKeepStr: '6'))
  }
    agent any
    environment {
        DOCKERHUB_REPO = "techcoms/backend-springboot-maven-jar"
//         GITHUB_URL = "${params.url}"
//         BRANCH = "${params.branch}"
    }
    tools{
        maven "maven-3.8.6"
    }
    stages{
        stage("git checkout"){
            steps{
                  git branch: "dev", credentialsId: 'github-creds', url: "https://github.com/techcoms/backend-springboot-maven-jar.git"
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
          stage('run a docker container'){
                steps{
                   sh "docker run -d -p 8181:8080 ${DOCKERHUB_REPO}:${BUILD_NUMBER}"
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
    post{
        changed{
            mail to: "techcomsdevops@gmail.com",
            subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
        }
    }
}

