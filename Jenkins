pipeline {
    environment {
        registry = "projectdocker1203/prod"
        registryCredential = 'dockerhubid'
    }
    agent any
    stages {
        stage('Fetch Code From Github') {
          steps {
              git branch: 'Dev', url: 'https://github.com/vivekbagde000/webappproject.git'
          }
        }
        stage('Build') {
          steps {
              sh 'mvn clean install'
          }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Copy Artifact To Docker Master') {
            steps {
                sh 'scp /var/lib/jenkins/workspace/pipeline/target/LoginWebApp.war dockeradmin@172.31.37.17:/opt/docker'
            }
        }
        stage('Copy Artifact') {
            steps {
                sh 'cp -R /var/lib/jenkins/workspace/pipeline/target /opt/projectdocker/'
            }
        }
        stage('Create Docker image from dockerfile') {
            steps {
                sh 'docker build -t projectdocker1203/testtomcat:$BUILD_NUMBER /opt/projectdocker/.'
                sh 'docker build -t projectdocker1203/testmysql:$BUILD_NUMBER /opt/projectdocker/db/.'
            }
            post {
                success {
                    echo 'Images has been created from dockerfile'
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                sh 'docker push projectdocker1203/testtomcat:$BUILD_NUMBER'
                sh 'docker push projectdocker1203/testmysql:$BUILD_NUMBER'
            }
        }
        stage('Delete Images and container from EC2') {
            steps {
                sh 'ansible Dev -m shell -a "docker rm -f tomcattest"'
                sh 'ansible Dev -m shell -a "docker rm -f db"'
            }
        }
        stage('Create Container in Docker EC2') {
            steps {
                sh 'ansible Dev -m shell -a "docker run -d --name db -p 3306:3306 -v /opt/docker/db:/var/lib/mysql projectdocker1203/testmysql:$BUILD_NUMBER"'
                sh 'ansible Dev -m shell -a "docker run -d --name tomcattest --link db:db -p 8080:8080 projectdocker1203/testtomcat:$BUILD_NUMBER"'
            }
            post {
                success {
                    echo 'container has been created in docker master'
                }
            }
        }
        stage('Delete Existing Images in Jenkins Host') {
            steps {
                sh 'docker rmi projectdocker1203/testtomcat:$BUILD_NUMBER'
                sh 'docker rmi projectdocker1203/testmysql:$BUILD_NUMBER'
                sh 'docker rmi -f tomcat:latest'
                sh 'docker rmi -f mysql:5.7'
                
            }
        }
    }
}
