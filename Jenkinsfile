pipeline {
  options {
    disableConcurrentBuilds()
  }
  agent {
    kubernetes {
        environment {
            POD_TEMPLATE = readFile('jenkins-pod.yaml')
        }
        podTemplate(yaml: env.POD_TEMPLATE) {}
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