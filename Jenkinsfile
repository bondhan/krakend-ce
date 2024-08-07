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
        container('golang') {
          sh 'make docker-internal'
        }
      }
    }
    stage('Tag & Push') {
      steps {
        container('docker') {
          sh 'docker tag devopsfaith/krakend:2.7.0 dcr.bondhan.local/krakend:2.7.0'
          sh 'docker push dcr.bondhan.local/krakend:2.7.0'
        }
      }
    }
  }

}