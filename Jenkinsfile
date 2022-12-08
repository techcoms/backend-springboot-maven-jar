pipeline{
    agent any
    tools{
        maven "maven-3.8.6"
    }
    stages{
        stage("git checkout"){
            steps{
                git branch: 'master', credentialsId: 'github-creds', url: 'https://github.com/techcoms/backend-springboot-maven-jar.git'
            }
        }
        stage("build artifacts with maven"){
            steps{
                sh "mvn clean package"
            }
        }
        stage("build docker image"){
            steps{
//                 sh "docker build -t techcoms/springboot-backend-jar ."
                   sh "docker --version"
            }
        }
//         stage("login to dockerhub and push image"){
//             steps{
//                 sh "docker login -u techcoms -p janakiram@123"
//                 sh "docker push techcoms/springboot-backend-jar"
//             }
//         }
         
    }
}
