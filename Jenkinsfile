pipeline {
  options {
    disableConcurrentBuilds()
  }
  agent {
    kubernetes {
     podTemplate(cloud: 'homek8s', yaml: readFile('jenkins-pod.yaml'))
    }
  }
  stages {
//     stage('Clone') {
//       steps {
//           withCredentials([string(credentialsId: 'github-secret-SbgVa', variable: 'GITHUB_TOKEN')]) {
//           sh 'git clone https://${GITHUB_TOKEN}@github.com/bondhan/krakend-ce.git .'
//         }
//       }
//     }
    stage('Compile') {
      steps {
        container('golang') {
          sh 'apk add make'
          sh 'make build'
        }
      }
    }
  }
}