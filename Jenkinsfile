def getBranchUtilsFromEnv(envB) {
    if (envB == 'production') {
        return 'master'
    } else if (envB == 'demo') {
        return 'master'
    } else if(envB == 'sandbox') {
        return 'release'
    } else if(envB == 'staging') {
        return 'development'
    } else {
        return 'development'
    }
}

pipeline {
  options {
    disableConcurrentBuilds()
    timestamps()
  }
  agent {
    kubernetes {
      yamlFile 'jenkins-pod.yml'
    }
  }
  parameters {
    choice(
      name: 'CI_GIT_TYPE',
      choices: ['', 'branch', 'commit', 'tag'],
      description: 'Which Environment?'
    )
    string(
      name: 'CI_GIT_SOURCE',
      defaultValue: '',
      description: 'Which git source?'
    )
  }
  environment {
    DOCKER_CREDENTIALS = credentials('docker_registry_login')
    KRAKEND_REPO = 'krakend-ce'
    SINBAD_ENV = "${env.JOB_BASE_NAME}"
    UTILS_BRANCH = getBranchUtilsFromEnv(SINBAD_ENV)
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
//           sh 'make docker'
           sh "echo SINBAD_ENV=${SINBAD_ENV}"
           sh "echo UTILS_BRANCH=${UTILS_BRANCH}"
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
