pipeline {
  options {
    disableConcurrentBuilds()
  }
  agent {
    kubernetes {
        yamlFile 'jenkins-pod.yml'
    }
  }
  stages {
    stage('Build') {
      steps {
        container('docker') {
          sh 'apk add make'
          sh 'apk add git'
          sh 'make docker'
        }
      }
    }
    stage('Tag & Push') {
      steps {
        container('docker') {
          sh 'docker tag docker.io/devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:2.7.0'
          sh 'docker push dcr.bondhan.local/krakend:2.7.0'
        }
      }
    }
  }

}