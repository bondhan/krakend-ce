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
    stage('Docker login') {
        steps {
            container('docker') {
                script {
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin dcr.bondhan.local"
                }
            }
        }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'apk add make'
          sh 'make docker'
        }
      }
    }
    stage('Tag, push image for develop branch') {
      when {
        branch 'develop'
      }
      steps {
        container('docker') {
          sh 'docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:develop'
          sh 'docker push dcr.bondhan.local/krakend:develop'
        }
      }
    }
    stage('Tag, push image for master branch') {
      when {
        branch 'master'
      }
      steps {
        container('docker') {
          sh 'docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:latest'
          sh 'docker push dcr.bondhan.local/krakend:latest'
        }
      }
    }
  }
}
