pipeline{
    agent any
    tools{
        maven "maven3"
    }
    stages{
        stage(git checkout){
            steps{
                git branch: 'master', credentialsId: 'github-creds', url: 'https://github.com/techcoms/backend-springboot-maven-jar.git'
            }
        }
        stage(build with maven){
            steps{
                sh "mvn clean package"
            }
        }
        stage(build docker image){
            steps{
                docker build -t techcoms/springboot-backend-jar .
            }
        }
        stage(push image to docker hub){
            steps{
                sh "docker login -u techcoms -p janakiram@123"
                sh "docker push techcoms/springboot-backend-jar"
            }
        }
         
    }
}
