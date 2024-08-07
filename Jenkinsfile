pipeline {
   environment {
        DOCKER_CREDENTIALS = credentials('docker_registry_login') // Replace with your credential ID
   }
  options {
    disableConcurrentBuilds()
  }
  agent {
    kubernetes {
        yamlFile 'jenkins-pod.yml'
    }
  }
  stages {
    stage('Docker Login') {
        steps {
            container('docker') {
                script {
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin dcr.bondhan.local"
                }
            }
        }
    }
    stage('Build Docker Image') {
      steps {
        container('docker') {
          sh 'apk add make'
          sh 'apk add git'
//           sh 'make docker'
        }
      }
    }
    stage('Tag & Push Docker Image') {
      steps {
        container('docker') {
          sh 'cat /etc/hosts'
          sh 'docker pull alpine:latest'
          sh 'docker tag alpine:latest dcr.bondhan.local/alpine:latest'
          sh 'docker push dcr.bondhan.local/alpine:latest'
//           sh 'docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:2.7.0'
//           sh 'docker push dcr.bondhan.local/krakend:2.7.0'
        }
      }
    }
  }

}